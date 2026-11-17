"""Textbook extension: fixed-target context interventions on a local ABC corpus."""
from __future__ import annotations

import argparse
from collections import Counter, defaultdict
import hashlib
import json
import math
from pathlib import Path
import random
import re
import resource
import sys
import time

import torch
from torch import nn
from torch.nn import functional as F


class SequenceModel(nn.Module):
    """Small GRU or causally masked Transformer; predict the final target."""

    def __init__(self, kind: str, vocab: int, length: int) -> None:
        super().__init__()
        self.kind = kind
        self.embedding = nn.Embedding(vocab, 32)
        if kind == "gru":
            self.core = nn.GRU(32, 64, batch_first=True)
            self.output = nn.Linear(64, vocab)
        else:
            self.position = nn.Embedding(length, 32)
            layer = nn.TransformerEncoderLayer(
                32, 4, 64, dropout=0.0, batch_first=True, norm_first=True
            )
            self.core = nn.TransformerEncoder(layer, 2, enable_nested_tensor=False)
            self.output = nn.Linear(32, vocab)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        z = self.embedding(x)
        if self.kind == "gru":
            z, _ = self.core(z)  # Every independent window starts with zero state.
        else:
            z = z + self.position(torch.arange(x.shape[1], device=x.device))
            mask = torch.ones(x.shape[1], x.shape[1], device=x.device, dtype=torch.bool).triu(1)
            z = self.core(z, mask=mask)
        return self.output(z[:, -1])


class Ngram:
    """Add-alpha character model, using the longest observed suffix."""

    def __init__(self, vocab: int, order: int = 5, alpha: float = 0.1) -> None:
        self.vocab, self.order, self.alpha = vocab, order, alpha
        self.counts: dict[tuple[int, ...], Counter[int]] = defaultdict(Counter)

    def fit(self, examples: list[tuple[list[int], int]]) -> None:
        for x, y in examples:
            for size in range(self.order):
                self.counts[tuple(x[-size:]) if size else ()][y] += 1

    def probabilities(self, x: list[int]) -> torch.Tensor:
        for size in range(min(len(x), self.order - 1), -1, -1):
            key = tuple(x[-size:]) if size else ()
            if key in self.counts:
                counts = self.counts[key]
                return torch.tensor(
                    [(counts[i] + self.alpha) / (counts.total() + self.alpha * self.vocab)
                     for i in range(self.vocab)], dtype=torch.float64
                )
        raise ValueError("Cannot evaluate an unfitted n-gram")


def load_corpus(path: Path, seed: int) -> tuple[dict[str, list[tuple[str, str]]], str]:
    """Group exact canonical score duplicates before splitting whole tunes."""
    raw = path.read_bytes()
    text = raw.decode("utf-8").replace("\r\n", "\n").replace("\r", "\n")
    starts = list(re.finditer(r"(?m)^X:", text))
    if not starts:
        raise ValueError("Expected ABC tunes beginning with X:; export the official songs unchanged")
    groups: dict[str, list[tuple[str, str]]] = defaultdict(list)
    for i, start in enumerate(starts):
        tune = text[start.start():starts[i + 1].start() if i + 1 < len(starts) else len(text)].strip() + "\n"
        # Keep key/meter/length, inline fields and score; ignore other header metadata.
        lines = []
        for line in tune.splitlines():
            line = line.split("%", 1)[0].strip()
            if re.match(r"^[A-Za-z]:", line) and line[:2] not in {"K:", "M:", "L:"}:
                continue
            lines.append(re.sub(r"\s+", "", line))
        canonical = "".join(lines)
        if not canonical or not re.search(r"(?m)^K:", tune):
            raise ValueError(f"Tune {i} has no key field or score")
        group = hashlib.sha256(canonical.encode()).hexdigest()
        tune_id = f"{group}:{i}:{hashlib.sha256(tune.encode()).hexdigest()}"
        groups[group].append((tune_id, tune))
    keys = sorted(groups)
    random.Random(seed).shuffle(keys)
    if len(keys) < 10:
        raise ValueError("Need at least ten distinct score groups for an 80/10/10 split")
    a, b = int(0.8 * len(keys)), int(0.9 * len(keys))
    splits = {name: [item for key in part for item in groups[key]]
              for name, part in zip(("train", "validation", "test"), (keys[:a], keys[a:b], keys[b:]))}
    return splits, hashlib.sha256(raw).hexdigest()


def synchronize(device: torch.device) -> None:
    if device.type == "cuda":
        torch.cuda.synchronize(device)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--abc", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--seed", type=int, default=17)
    parser.add_argument("--split-seed", type=int, default=17)
    parser.add_argument("--steps", type=int, default=20)
    parser.add_argument("--batch", type=int, default=8)
    parser.add_argument("--contexts", type=int, nargs="+", default=[8, 32, 64])
    parser.add_argument("--eval-targets", type=int, default=128, help="Maximum targets per evaluation split")
    parser.add_argument("--generate", type=int, default=128, help="New characters per sample")
    parser.add_argument("--device", choices=["cpu", "cuda"], default="cpu")
    parser.add_argument("--threads", type=int, default=1)
    parser.add_argument("--abc-check", action="store_true", help="Parse samples with optional music21")
    args = parser.parse_args()
    if min(args.steps, args.batch, args.eval_targets, args.generate, args.threads, *args.contexts) < 1:
        parser.error("All sizes must be positive")
    if args.out.exists():
        parser.error("--out must be a new directory, to preserve earlier runs")
    args.out.mkdir(parents=True)
    torch.set_num_threads(args.threads)
    random.seed(args.seed)
    torch.manual_seed(args.seed)
    if args.device == "cuda" and not torch.cuda.is_available():
        parser.error("CUDA requested but unavailable")
    device = torch.device(args.device)
    splits, digest = load_corpus(args.abc, args.split_seed)
    chars = sorted(set("".join(tune for _, tune in splits["train"])))
    stoi = {char: i + 1 for i, char in enumerate(chars)}  # 0 is UNK, never a corpus character.
    length = max(args.contexts)
    encoded = {name: [[stoi.get(c, 0) for c in tune] for _, tune in tunes]
               for name, tunes in splits.items()}
    positions = {name: [(i, t) for i, tune in enumerate(tunes) for t in range(length, len(tune))]
                 for name, tunes in encoded.items()}
    if any(not pool for pool in positions.values()):
        raise ValueError("Each split needs at least one tune longer than max(contexts)")
    rng = random.Random(args.seed)
    schedule = rng.choices(positions["train"], k=args.steps * args.batch)
    examples = [(encoded["train"][i][t-length:t], encoded["train"][i][t]) for i, t in schedule]
    evaluation = {}
    for name in ("validation", "test"):
        evaluation[name] = sorted(random.Random(args.split_seed + 1).sample(
            positions[name], min(args.eval_targets, len(positions[name]))))
    report = {
        "config": {k: str(v) if isinstance(v, Path) else v for k, v in vars(args).items()},
        "corpus_sha256": digest, "torch": torch.__version__, "python": sys.version,
        "vocabulary": ["<UNK>"] + chars,
        "split_tune_ids": {name: [i for i, _ in tunes] for name, tunes in splits.items()},
        "split_statistics": {name: {"tunes": len(tunes),
                                    "groups": len({i.split(":")[0] for i, _ in tunes}),
                                    "characters": sum(len(t) for _, t in tunes),
                                    "eligible_targets": len(positions[name])}
                             for name, tunes in splits.items()},
        "oov_fraction": {name: sum(t.count(0) for t in tunes) / sum(map(len, tunes))
                         for name, tunes in encoded.items()},
        "training_positions": schedule, "evaluation_positions": evaluation,
        "supervised_targets_per_model": len(examples),
        "input_tokens_presented_per_model": len(examples) * length,
        "results": [],
    }
    # Identical, fully specified held-out prefix for every model/temperature.
    prompt = splits["test"][evaluation["test"][0][0]][1][:length]
    for kind in ("ngram", "gru", "transformer"):
        torch.manual_seed(args.seed)
        model = Ngram(len(chars) + 1) if kind == "ngram" else SequenceModel(kind, len(chars) + 1, length).to(device)
        if device.type == "cuda":
            torch.cuda.reset_peak_memory_stats(device)
        synchronize(device)
        start = time.perf_counter()
        losses = []
        if isinstance(model, Ngram):
            model.fit(examples)
            parameters = None
        else:
            parameters = sum(p.numel() for p in model.parameters())
            optimizer = torch.optim.AdamW(model.parameters(), lr=1e-3, weight_decay=0.01)
            model.train()
            for step in range(args.steps):
                batch = examples[step * args.batch:(step + 1) * args.batch]
                x = torch.tensor([x for x, _ in batch], device=device)
                y = torch.tensor([y for _, y in batch], device=device)
                loss = F.cross_entropy(model(x), y)
                optimizer.zero_grad(set_to_none=True)
                loss.backward()
                nn.utils.clip_grad_norm_(model.parameters(), 1.0)
                optimizer.step()
                losses.append(float(loss.detach()))
            model.eval()
        synchronize(device)
        train_seconds = time.perf_counter() - start
        train_cuda = torch.cuda.max_memory_allocated(device) if device.type == "cuda" else None
        if not isinstance(model, Ngram):
            torch.save({"state_dict": model.state_dict(), "kind": kind, "vocabulary": report["vocabulary"],
                        "context": length}, args.out / f"{kind}.pt")
            del optimizer, x, y, loss
        if isinstance(model, Ngram):
            state = [{"context": list(k), "counts": dict(v)} for k, v in model.counts.items()]
            (args.out / "ngram.json").write_text(json.dumps(state), encoding="utf-8")

        def log_probabilities(context: list[int]) -> torch.Tensor:
            if isinstance(model, Ngram):
                return model.probabilities(context).log()
            with torch.no_grad():
                return model(torch.tensor([context], device=device)).log_softmax(-1)[0].cpu()

        synchronize(device)
        start = time.perf_counter()
        metrics = []
        with torch.no_grad():
            for name, targets in evaluation.items():
                for context in sorted(set(args.contexts)):
                    per_tune: dict[int, list[float]] = defaultdict(list)
                    for i, t in targets:
                        loss = -float(log_probabilities(encoded[name][i][t-context:t])[encoded[name][i][t]])
                        per_tune[i].append(loss)
                    total = sum(sum(v) for v in per_tune.values()) / len(targets)
                    metrics.append({"split": name, "context": context, "targets": len(targets),
                                    "nll": total, "ppl": math.exp(total),
                                    "per_tune": {i: {"targets": len(v), "nll": sum(v) / len(v)}
                                                 for i, v in per_tune.items()}})
        synchronize(device)
        evaluation_seconds = time.perf_counter() - start
        samples = []
        for temperature in (0.5, 1.0, 1.5):
            generator = torch.Generator().manual_seed(args.seed + 2)
            ids = [stoi.get(c, 0) for c in prompt]
            for _ in range(args.generate):
                logits = log_probabilities(ids[-length:]) / temperature
                logits[0] = -torch.inf  # Explicit generation-only UNK restriction.
                ids.append(int(torch.multinomial(logits.softmax(-1), 1, generator=generator)))
            text = prompt + "".join(chars[i-1] for i in ids[len(prompt):])
            continuation = text[len(prompt):]
            grams = [continuation[i:i+8] for i in range(max(0, len(continuation)-7))]
            sample = {"temperature": temperature, "text": text,
                      "repeated_8gram_fraction": 1 - len(set(grams)) / len(grams) if grams else None,
                      "has_X_and_K": bool(re.search(r"(?m)^X:", text) and re.search(r"(?m)^K:", text))}
            if args.abc_check:
                from music21 import converter
                try:
                    score = converter.parse(text, format="abc")
                    sample["parser_accepts_with_notes"] = bool(list(score.recurse().notes))
                    sample["parser_error"] = None
                except Exception as error:  # Record malformed generated ABC, not a training failure.
                    sample["parser_accepts_with_notes"] = False
                    sample["parser_error"] = str(error)
            samples.append(sample)
        report["results"].append({"model": kind, "parameters": parameters, "losses": losses,
                                  "train_seconds": train_seconds,
                                  "evaluation_seconds": evaluation_seconds,
                                  "train_cuda_peak_allocated_bytes": train_cuda,
                                  "process_peak_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                                  "ngram_contexts": len(model.counts) if isinstance(model, Ngram) else None,
                                  "metrics": metrics, "samples": samples})
        del model
    (args.out / "report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    print(args.out / "report.json")


if __name__ == "__main__":
    main()
