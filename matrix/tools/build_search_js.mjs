#!/usr/bin/env node
/*
 * build_search_js — 为中文内容重建全文搜索索引。
 *
 * 为什么需要它：mdBook 的分词器只按「空白 / 连字符」切词
 * （见 crates/mdbook-html/src/html_handlebars/search.rs 的 tokenize()），
 * 且 elasticlunr 默认的 trimmer 会把不含拉丁字母的 token 整个丢掉。
 * 因此「数域」「过渡矩阵」这类中文词根本进不了索引，中文全文搜索形同虚设。
 *
 * 做法：构建之后读取 mdBook 产出的 searchindex-*.js，用自写的中文分词
 * （一元 + 二元字符 n-gram）重建 elasticlunr 倒排索引，并写回同一文件。
 * 不修改 mdBook 源码，也不引入外部依赖——分词与建索引全在这里完成。
 *
 *   用法：node tools/build_search_js.mjs [bookDir]
 *   默认 bookDir = book
 *
 * 查询侧无需改动：searcher.js 用同一个 elasticlunr 对输入做分词，
 * 「数域」会被切成「数」「域」「数域」，从而命中我们写入的 n-gram。
 * 纯英文查询（如 Hermite）仍走原逻辑，正常工作。
 */

import fs from "node:fs";
import path from "node:path";
import vm from "node:vm";

const BOOK_DIR = process.argv[2] || "book";

/* ------------------------------------------------------------------ *
 * 中文分词：一元 + 二元字符 n-gram
 * ------------------------------------------------------------------ */
const CJK = /[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\u3040-\u30ff]/;

function tokenizeCJK(text) {
  const out = [];
  // 先按「空白 / 连字符 / 常见标点」切成片段，保留拉丁词与数字
  const parts = String(text || "").split(/[\s\-·，。、；：？！“”‘’（）()《》〈〉【】\[\]{}<>／/\\|,.;:!?"']+/);
  for (const part of parts) {
    if (!part) continue;
    if (!CJK.test(part)) {
      // 纯拉丁 / 数字片段：整体作为 token（与 mdBook 行为一致）
      out.push(part.toLowerCase());
      continue;
    }
    // 含中文的片段：按字符走一遍，输出一元与二元
    const chars = [...part];
    for (let i = 0; i < chars.length; i++) {
      const c = chars[i];
      out.push(c.toLowerCase());
      if (i + 1 < chars.length) out.push((c + chars[i + 1]).toLowerCase());
    }
  }
  // mdBook 会丢弃超长 token；这里也设一个上限，避免里氏替换式的噪声
  return out.filter((t) => t.length > 0 && t.length <= 80);
}

/* ------------------------------------------------------------------ *
 * 载入随 mdBook 一起产出的 elasticlunr（0.9.5）
 * ------------------------------------------------------------------ */
function loadElasticlunr(bundlePath) {
  const src = fs.readFileSync(bundlePath, "utf8");
  const sandbox = { window: {}, self: {}, console };
  sandbox.globalThis = sandbox;
  vm.createContext(sandbox);
  vm.runInContext(src, sandbox);
  const el = sandbox.window.elasticlunr || sandbox.elasticlunr;
  if (!el) throw new Error("无法从 " + bundlePath + " 载入 elasticlunr");
  return el;
}

/* ------------------------------------------------------------------ *
 * 主流程
 * ------------------------------------------------------------------ */
function main() {
  const files = fs.readdirSync(BOOK_DIR);
  const indexFile = files.find((f) => /^searchindex-.*\.js$/.test(f));
  const lunrFile = files.find((f) => /^elasticlunr-.*\.js$/.test(f));
  if (!indexFile) throw new Error(BOOK_DIR + " 下找不到 searchindex-*.js（请先 mdbook build）");
  if (!lunrFile) throw new Error(BOOK_DIR + " 下找不到 elasticlunr-*.js");

  const indexPath = path.join(BOOK_DIR, indexFile);
  const raw = fs.readFileSync(indexPath, "utf8");
  // 形式为 window.search = Object.assign(window.search, JSON.parse('<json-escaped>'));
  // mdBook 会把内容转义成 JS 字符串字面量（内容里的撇号变成 \'），所以**不能**
  // 手工切片后直接 JSON.parse。这里直接在沙箱里执行该文件，读回 window.search，
  // 与浏览器行为一致，且对转义完全免疫。
  const sandbox = { window: { search: {} }, Object, console };
  sandbox.globalThis = sandbox;
  vm.createContext(sandbox);
  vm.runInContext(raw, sandbox);
  const payload = sandbox.window.search;
  if (!payload || !payload.index || !payload.index.documentStore) {
    throw new Error("无法解析 " + indexFile + "（未取得 search 索引对象）");
  }

  const elasticlunr = loadElasticlunr(path.join(BOOK_DIR, lunrFile));
  const { fields, ref } = payload.index;
  const docs = payload.index.documentStore.docs;

  // 用 CJK 分词器 + 空 pipeline 重建索引。
  // 注意：elasticlunr 在 addDoc 与 search 内部都调用**模块级**的
  // elasticlunr.tokenizer（而不是实例上的 .tokenizer），所以必须改写模块级函数，
  // 设置 builder.tokenizer 是不生效的。
  elasticlunr.tokenizer = tokenizeCJK;

  const builder = new elasticlunr.Index();
  builder.setRef(ref);
  builder.pipeline = new elasticlunr.Pipeline();   // 不做 trimmer / stemmer（它们会丢掉中文）
  builder.saveDocument(true);
  for (const f of fields) builder.addField(f);

  const refs = Array.isArray(docs) ? docs.map((d) => d[ref]) : Object.keys(docs);
  for (const id of refs) {
    const doc = docs[id];
    if (!doc) continue;
    const rec = { [ref]: doc[ref] };
    for (const f of fields) rec[f] = doc[f] == null ? "" : String(doc[f]);
    builder.addDoc(rec);
  }

  // 写回：保持 mdBook 的 window.search = Object.assign(...) 形式
  payload.index = JSON.parse(JSON.stringify(builder.toJSON()));
  payload.index.lang = "CJK";
  const json = JSON.stringify(payload).replace(/\\/g, "\\\\").replace(/'/g, "\\'");
  const out = "window.search = Object.assign(window.search, JSON.parse('" + json + "'));\n";
  fs.writeFileSync(indexPath, out, "utf8");
  console.log(
    `[search] 重建完成：${refs.length} 篇文档，字段 ${fields.join("/")}，` +
    `输出 ${(out.length / 1024).toFixed(0)} KB → ${indexFile}`
  );

  // 自检：对重建后的索引跑几个探针查询，异常会在构建日志里直接暴露。
  // 查询侧也用同一套 CJK 分词器（浏览器里由 theme/js/search-cjk.js 完成同样的事）。
  const probe = JSON.parse(JSON.stringify(builder.toJSON()));
  const check = elasticlunr.Index.load(probe);
  const opts = {
    fields: { title: { boost: 4 }, body: { boost: 1 }, breadcrumbs: { boost: 2 } },
    bool: "AND",
    expand: true,
  };
  let failed = 0;
  const probes = ["数域", "过渡矩阵", "维数公式", "内积", "Hermite", "Casorati", "标准正交基", "直和", "投影", "正交补", "正交投影", "Gram", "相抵分解", "满秩分解", "右逆"];
  for (const q of probes) {
    const hits = check.search(q, opts);
    if (hits.length === 0) failed++;
    console.log(`[search]   探针 ${q.padEnd(10)} → ${hits.length} 命中`);
  }
  if (failed === probes.length) {
    throw new Error("检索自检全部落空，索引可能未生效");
  }
}

main();
