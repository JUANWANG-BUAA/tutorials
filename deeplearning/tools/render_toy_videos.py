#!/usr/bin/env python3
"""Render two offline, narrated numerical lessons (no model training).

Dependencies: Python 3.10+, Pillow, ffmpeg with libx264/AAC, ffprobe;
macOS `say` and an installed zh_CN voice for the default synthetic narration.
Install dependencies separately; this program never downloads fonts or voices.
Run: python3 tools/render_toy_videos.py
Use --silent explicitly on machines without speech synthesis; the resulting
video, captions and manifest all identify that mode. Font discovery checks
local macOS/Linux CJK paths; --font PATH overrides it. --voice NAME overrides
the first installed zh_CN voice. Output: MP4, UTF-8 SRT and manifest JSON.
Existing outputs with these names are replaced only after encoding succeeds.
"""
from __future__ import annotations

import argparse
import json
import math
import sys
import shutil
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError as exc:
    raise SystemExit("缺少 Pillow：请先在本地 Python 环境安装 Pillow，再离线运行。") from exc

ROOT = Path(__file__).resolve().parents[1]
WIDTH, HEIGHT, FPS = 1280, 720, 12


@dataclass(frozen=True)
class Slide:
    title: str
    lines: tuple[str, ...]
    caption: str


def run(args: list[str]) -> str:
    result = subprocess.run(args, text=True, capture_output=True)
    if result.returncode:
        raise RuntimeError(f"命令失败：{args[0]}\n{result.stderr.strip()}")
    return result.stdout


def duration(path: Path) -> float:
    return float(run(["ffprobe", "-v", "error", "-show_entries", "format=duration",
                      "-of", "default=noprint_wrappers=1:nokey=1", str(path)]))


def find_font(explicit: str | None) -> Path:
    candidates = [Path(explicit)] if explicit else [
        Path("/System/Library/Fonts/STHeiti Medium.ttc"),
        Path("/System/Library/Fonts/Supplemental/Arial Unicode.ttf"),
        Path("/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"),
        Path("/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc"),
    ]
    for path in candidates:
        if path.is_file():
            return path
    raise RuntimeError("找不到本地中文字体；请用 --font 指定含中文字形的 TTF/TTC/OTF 文件。")


def find_voice(explicit: str | None) -> str:
    if not shutil.which("say"):
        raise RuntimeError("缺少 macOS say；请安装本地合成语音工具，或明确指定 --silent 生成无声版。")
    listing = run(["say", "-v", "?"])
    voices = [line.split("zh_CN", 1)[0].strip() for line in listing.splitlines() if "zh_CN" in line]
    if explicit:
        if explicit not in voices:
            raise RuntimeError(f"未列出指定的本地 zh_CN 声音：{explicit}。用 say -v '?' 查看；不会联网安装。")
        return explicit
    if not voices:
        raise RuntimeError("没有可用的本地 zh_CN 声音；请明确指定 --silent 生成有字幕无声版。")
    return voices[0]


def lessons() -> dict[str, tuple[str, list[Slide]]]:
    a = math.exp(1) / (math.exp(1) + 1)
    b = 1 - a
    kl = 0.5 * (1 + 0.25 - 1 - math.log(0.25))
    nll = 0.5 * math.log(2 * math.pi)
    return {
        "multihead-attention-handcalc": ("多头注意力：两个词、两个头", [
            Slide("01  固定输入与维度", (
                "X = [[1, 0], [0, 1]]   （每行是一个词）",
                "词数 n = 2；模型维度 d_model = 2",
                "头数 h = 2；每头 d_k = d_v = 1",
                "双向自注意力：无 mask，无偏置，无 dropout",
            ), "用两个二维词向量手算两个注意力头。这里固定参数，只演示前向计算，不涉及真实训练。"),
            Slide("02  每个头有自己的投影", (
                "头 1：W_Q = W_K = W_V = [[1], [0]]",
                "头 2：W_Q = W_K = W_V = [[0], [1]]",
                "Q_i = X W_Qi；K_i = X W_Ki；V_i = X W_Vi",
                "头 1 的 Q、K、V 均为 [[1], [0]]",
                "头 2 的 Q、K、V 均为 [[0], [1]]",
            ), "第一头读取第一坐标，第二头读取第二坐标。每个投影矩阵都是二行一列，投影后每个词只剩一个数。"),
            Slide("03  点积打分与缩放", (
                "S_i = Q_i K_i^T / sqrt(d_k)",
                "sqrt(d_k) = sqrt(1) = 1",
                "S_1 = [[1, 0], [0, 0]]",
                "S_2 = [[0, 0], [0, 1]]",
                "第 r 行：词 r 对两个 key 的分数",
            ), "把查询乘以键的转置得到二乘二的分数矩阵。每头的键维度为一，所以缩放因子恰好是一。"),
            Slide("04  每一行单独做 softmax", (
                f"softmax([1, 0]) = [{a:.6f}, {b:.6f}]",
                "softmax([0, 0]) = [0.500000, 0.500000]",
                f"A_1 = [[{a:.6f}, {b:.6f}], [0.5, 0.5]]",
                f"A_2 = [[0.5, 0.5], [{b:.6f}, {a:.6f}]]",
                "检查：每行权重和为 1；不是逐列归一化",
            ), "一和零的指数分别是自然常数和一，归一化后约为零点七三一和零点二六九。零和零则各占一半。"),
            Slide("05  用权重加权 value", (
                "H_1 = A_1 V_1；H_2 = A_2 V_2",
                f"词 1，头 1：{a:.6f} x 1 + {b:.6f} x 0",
                f"H_1 = [[{a:.6f}], [0.500000]]",
                f"H_2 = [[0.500000], [{a:.6f}]]",
                "同一个词，在两个头中汇聚的内容不同",
            ), "注意力权重不是输出。还要乘以值向量。第一头的值是第一坐标，第二头的值是第二坐标。"),
            Slide("06  拼接后再做输出投影", (
                f"C = concat(H_1,H_2) = [[{a:.6f}, 0.5],",
                f"                                      [0.5, {a:.6f}]]",
                "W_O = [[1, 1], [1, -1]]；Y = C W_O",
                f"Y = [[{a + 0.5:.6f}, {a - 0.5:.6f}],",
                f"        [{a + 0.5:.6f}, {0.5 - a:.6f}]]",
            ), "拼接保留每个头的结果，再乘输出矩阵。第一列求和，第二列作差，所以两个词的第二个输出互为相反数。"),
            Slide("07  暂停复算：检查三个位置", (
                f"A_1[1,1] = e / (e + 1) = {a:.6f}",
                "H_2[1,1] = 0.5 x 0 + 0.5 x 1 = 0.5",
                f"Y[2,2] = 0.5 - {a:.6f} = {0.5 - a:.6f}",
                "索引从 1 起；屏幕小数四舍五入到 6 位",
                "边界：这里没有残差、LayerNorm 或前馈网络",
            ), "暂停后可独立复算这三处。这只是多头注意力子层的数值例子，不是完整的 Transformer，也不证明头必然学到不同语义。"),
        ]),
        "vae-handcalc": ("VAE：一次采样与损失手算", [
            Slide("01  先声明概率模型", (
                "观测 x = 2；先验 p(z) = N(0, 1)",
                "编码器给出 q(z|x) = N(mu, sigma^2)",
                "固定 mu = 1；sigma = 0.5；sigma^2 = 0.25",
                "解码器：p(x|z) = N(2z + 1, 1)",
                "一维、固定参数；不声称运行过训练",
            ), "这个一维例子把概率模型完全写明。编码器方差是零点二五，解码器观测方差则是一，两者不要混淆。"),
            Slide("02  重参数化：固定一次噪声", (
                "通常 epsilon ~ N(0, 1)",
                "本次为便于复算，指定 epsilon = -1",
                "z = mu + sigma x epsilon",
                "  = 1 + 0.5 x (-1) = 0.5",
                "固定噪声只是教学选择，不代表平均样本",
            ), "重参数化把随机性放进标准正态噪声。这次指定噪声为负一，因此潜变量等于零点五。这个样本不是期望。"),
            Slide("03  解码得到的是观测分布", (
                "解码均值 x_hat = 2z + 1",
                "                   = 2 x 0.5 + 1 = 2",
                "p(x|z=0.5) = N(2, 1)",
                "残差 x - x_hat = 2 - 2 = 0",
                "均值重建正确，不表示概率损失等于零",
            ), "解码器输出观测分布的均值二。它正好等于观测，但高斯负对数似然仍有归一化常数，不能直接当作零。"),
            Slide("04  单样本重建负对数似然", (
                "NLL = -log p(x|z)",
                "      = 0.5 log(2 pi) + 0.5 (x - x_hat)^2",
                f"      = {nll:.6f} + 0 = {nll:.6f}",
                "这里观测方差为 1；log 均为自然对数",
                "若只用平方误差，必须说明省略的系数和常数",
            ), "代入单位观测方差，高斯负对数似然等于二分之一乘自然对数二派，加上二分之一残差平方，结果约零点九一九。"),
            Slide("05  KL 项可解析计算", (
                "KL(q || p) = 0.5 (mu^2 + sigma^2 - 1 - log sigma^2)",
                "              = 0.5 (1 + 0.25 - 1 - log 0.25)",
                f"              = {kl:.6f}",
                "KL 使用整个后验分布，不使用本次 epsilon",
                "方向是 q 到 p，不能随意交换",
            ), "标准正态先验下，KL 项有解析式。代入均值一、方差零点二五，结果约零点八一八。它不依赖这次抽到的噪声。"),
            Slide("06  一次蒙特卡洛损失估计", (
                "负 ELBO = E_q[-log p(x|z)] + KL(q || p)",
                "单样本估计 L_hat = NLL(z=0.5) + KL",
                f"                            = {nll:.6f} + {kl:.6f}",
                f"                            = {nll + kl:.6f}  nats",
                "本例 beta = 1；这不是负 ELBO 的精确期望",
            ), "把一次采样的重建损失加上解析 KL，得到约一点七三七。它是负证据下界的一次蒙特卡洛估计，不是精确期望。"),
            Slide("07  这个例子还能算精确期望", (
                "z ~ N(1, 0.25)，所以 2z + 1 的均值为 3、方差为 1",
                "E[(x - (2z+1))^2] = (2 - 3)^2 + 1 = 2",
                f"E[NLL] = {nll:.6f} + 0.5 x 2 = {nll + 1:.6f}",
                f"精确负 ELBO = {nll + 1 + kl:.6f}  nats",
                "单次重建碰巧很好，不能代替分布上的平均",
            ), "线性解码器允许精确求期望。均方残差等于均值偏差平方加方差，也就是二，因此精确负证据下界约二点七三七。"),
            Slide("08  暂停复算与适用边界", (
                "把 epsilon 改为 0：z = 1，x_hat = 3",
                f"NLL = {nll:.6f} + 0.5 = {nll + 0.5:.6f}",
                f"此时 L_hat = {nll + 0.5 + kl:.6f}，KL 仍不变",
                "重参数化使 dz/dmu = 1，dz/dsigma = epsilon",
                "只演示概率和损失；没有真实数据或训练曲线",
            ), "再把噪声改成零，复算损失约二点二三七，KL 不变。重参数化让梯度能经过均值和标准差传播，但本片没有执行训练。"),
        ]),
    }


def wrap(draw: ImageDraw.ImageDraw, text: str, font: ImageFont.FreeTypeFont, width: int) -> list[str]:
    rows, row = [], ""
    for char in text:
        if draw.textlength(row + char, font=font) > width:
            rows.append(row)
            row = char
        else:
            row += char
    if row:
        rows.append(row)
    return rows


def image(slide: Slide, title: str, index: int, total: int, font: Path, silent: bool, path: Path) -> None:
    canvas = Image.new("RGB", (WIDTH, HEIGHT), "#101b2a")
    draw = ImageDraw.Draw(canvas)
    heading = ImageFont.truetype(str(font), 39)
    body = ImageFont.truetype(str(font), 29)
    subtitle = ImageFont.truetype(str(font), 26)
    small = ImageFont.truetype(str(font), 21)
    draw.text((48, 24), title, font=small, fill="#a0bed7")
    draw.text((48, 75), slide.title, font=heading, fill="#ffffff")
    draw.rounded_rectangle((40, 143, 1240, 522), radius=18, fill="#1e3045")
    y = 166
    for line in slide.lines:
        for row in wrap(draw, line, body, 1138):
            draw.text((62, y), row, font=body, fill="#e3f2ff")
            y += 43
        y += 8
    if y > 525:
        raise RuntimeError(f"画面正文超出边界：{slide.title}")
    rows = wrap(draw, slide.caption, subtitle, 1156)
    if len(rows) > 3:
        raise RuntimeError(f"字幕超过三行：{slide.title}")
    for row_index, row in enumerate(rows):
        draw.text((62, 548 + 35 * row_index), row, font=subtitle, fill="#ffe5aa")
    mode = "中文字幕 / 无声版（无旁白）" if silent else "中文字幕 / 合成旁白（macOS say）"
    draw.text((48, 676), mode, font=small, fill="#a0bed7")
    draw.text((1120, 676), f"{index}/{total}", font=small, fill="#a0bed7")
    draw.rectangle((0, 713, round(WIDTH * index / total), 719), fill="#58cbb9")
    canvas.save(path)


def timestamp(seconds: float) -> str:
    millis = round(seconds * 1000)
    hours, millis = divmod(millis, 3600000)
    minutes, millis = divmod(millis, 60000)
    secs, millis = divmod(millis, 1000)
    return f"{hours:02}:{minutes:02}:{secs:02},{millis:03}"


def render(name: str, title: str, slides: list[Slide], output: Path, font: Path, voice: str | None) -> dict:
    with tempfile.TemporaryDirectory(prefix="toy-video-") as temporary:
        work = Path(temporary)
        segments, captions = [], []
        elapsed = 0.0
        for index, slide in enumerate(slides, 1):
            png, audio, segment = (work / f"{index}.{suffix}" for suffix in ("png", "aiff", "mp4"))
            image(slide, title, index, len(slides), font, voice is None, png)
            if voice is not None:
                # `say` only uses the selected installed voice; no web/API calls.
                run(["say", "-v", voice, "-r", "185", "-o", str(audio), slide.caption])
                seconds = max(12.0, duration(audio) + 1.5)
            else:
                seconds = max(14.0, len(slide.caption) / 4)
            seconds = math.ceil(seconds * FPS) / FPS
            command = ["ffmpeg", "-v", "error", "-y", "-loop", "1", "-framerate", str(FPS), "-i", str(png)]
            if voice is not None:
                command += ["-i", str(audio), "-af", "apad", "-c:a", "aac", "-b:a", "64k", "-ar", "44100", "-ac", "1"]
            else:
                command += ["-an"]
            command += ["-t", str(seconds), "-c:v", "libx264", "-preset", "medium", "-tune", "stillimage",
                        "-crf", "25", "-pix_fmt", "yuv420p", "-r", str(FPS), str(segment)]
            run(command)
            actual = duration(segment)
            status = "无旁白" if voice is None else "合成旁白"
            captions.append(f"{index}\n{timestamp(elapsed)} --> {timestamp(elapsed + actual)}\n[{status}] {slide.caption}\n")
            elapsed += actual
            segments.append(segment)
        playlist = work / "concat.txt"
        playlist.write_text("".join(f"file '{segment.name}'\n" for segment in segments), encoding="utf-8")
        final = work / "final.mp4"
        run(["ffmpeg", "-v", "error", "-y", "-f", "concat", "-safe", "0", "-i", str(playlist),
             "-c", "copy", "-movflags", "+faststart", "-metadata", f"title={title}",
             "-metadata", f"comment={'Silent; Chinese burned-in captions' if voice is None else 'Synthetic narration: macOS say; Chinese burned-in captions'}", str(final)])
        result = {"file": f"{name}.mp4", "title": title, "duration_seconds": duration(final),
                  "steps": len(slides), "bytes": final.stat().st_size,
                  "narration": "none" if voice is None else "synthetic macOS say", "voice": voice,
                  "captions": "Chinese burned-in and companion SRT"}
        shutil.move(str(final), output / f"{name}.mp4")
        (output / f"{name}.srt").write_text("\n".join(captions), encoding="utf-8")
        return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--font", help="本地中文字体路径")
    parser.add_argument("--voice", help="say -v '?' 列出的本地 zh_CN 声音名称")
    parser.add_argument("--silent", action="store_true", help="明确生成无声版；画面和清单将标注无旁白")
    parser.add_argument("--output", type=Path, default=ROOT / "src/assets/videos")
    args = parser.parse_args()
    if args.silent and args.voice:
        parser.error("--silent 和 --voice 不能同时指定")
    for executable in ("ffmpeg", "ffprobe"):
        if not shutil.which(executable):
            parser.error(f"缺少 {executable}：请先在本机安装，再离线运行。")
    font = find_font(args.font)
    voice = None if args.silent else find_voice(args.voice)
    args.output.mkdir(parents=True, exist_ok=True)
    results = [render(name, title, slides, args.output, font, voice)
               for name, (title, slides) in lessons().items()]
    manifest = {"generator": "tools/render_toy_videos.py", "font": str(font),
                "resolution": [WIDTH, HEIGHT], "fps": FPS, "videos": results,
                "scope": "Fixed hand-calculation examples only; no model training or external data."}
    (args.output / "toy-videos.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, ValueError) as error:
        print(f"生成失败：{error}", file=sys.stderr)
        sys.exit(1)
