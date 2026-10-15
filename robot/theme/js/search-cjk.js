/*
 * search-cjk.js — 让 mdBook 的全文搜索支持中文（三本书共用，内容逐字相同）
 * ---------------------------------------------------------------------------
 * 背景：mdBook 的分词器只按空白/连字符切词，且 elasticlunr 默认的 trimmer 会
 * 丢掉不含拉丁字母的 token，因此中文内容根本进不了索引、也搜不到。
 *
 * 配套两步修复：
 *   1) 构建后由 tools/build_search_js.mjs 用「一元 + 二元字符 n-gram」重建索引；
 *   2) 本脚本在浏览器侧把 elasticlunr 的分词器换成同一套 n-gram 规则，
 *      使「查询」与「索引」使用完全相同的切分，召回才稳定可靠。
 *   两者必须逐字一致——只改一边就会出现「索引里有、查询切不出来」的静默漏检。
 *
 * 例：「数域」→ 数 / 数域 / 域；「过渡矩阵」→ 过/过渡/渡/渡矩/矩/矩阵/阵。
 * mdBook 在 HTML 元素边界会插入空格，源文件里的「DH参数」进索引前变成「DH 参数」，
 * 所以切词前先去掉 ASCII ↔ 中文之间的空格（preprocess），两侧才能切出同一批 token。
 *
 * 改写时机：mdBook 0.5 把 elasticlunr 与本脚本同页加载（本脚本在后），所以这里
 * **同步**改写；`?search=` 深链在 DOMContentLoaded 就会发一次查询，晚一步改写
 * 会让深链中文查询误报「没有命中」。更早的 mdBook 版本才在搜索打开时懒加载
 * elasticlunr，故保留轮询兜底。
 */
(function () {
  "use strict";

  var CJK = /[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\u3040-\u30ff]/;
  var SPLIT = /[\s\-·，。、；：？！“”‘’"'（）()《》〈〉【】\[\]{}<>／/\\|,.;:!?]+/;
  var ASCII_CJK_GAP = /([A-Za-z0-9])\s+([\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\u3040-\u30ff])|([\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\u3040-\u30ff])\s+([A-Za-z0-9])/g;
  var MAX = 80;

  function preprocess(text) {
    var prev;
    do { prev = text; text = text.replace(ASCII_CJK_GAP, "$1$2$3$4"); } while (text !== prev);
    return text;
  }

  function tokenizeMixedPart(part, out) {
    var runs = part.match(/[A-Za-z]+|[0-9]+|[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\u3040-\u30ff]+/g);
    if (!runs) return;
    for (var r = 0; r < runs.length; r++) {
      var run = runs[r];
      if (/^[A-Za-z]+$/.test(run)) {
        var lo = run.toLowerCase();
        out.push(lo);
        for (var i = 0; i < run.length; i++) out.push(run[i].toLowerCase());
        for (var j = 0; j + 1 < run.length; j++) out.push((run[j] + run[j + 1]).toLowerCase());
      } else if (/^[0-9]+$/.test(run)) {
        out.push(run);
      } else {
        var chars = Array.from(run);
        for (var k = 0; k < chars.length; k++) {
          out.push(chars[k].toLowerCase());
          if (k + 1 < chars.length) out.push((chars[k] + chars[k + 1]).toLowerCase());
        }
      }
      if (r + 1 < runs.length && !/^[0-9]+$/.test(run) && !/^[0-9]+$/.test(runs[r + 1])) {
        out.push((run[run.length - 1] + runs[r + 1][0]).toLowerCase());
      }
    }
  }

  function tokenizeCJK(text) {
    var out = [];
    var parts = preprocess(String(text == null ? "" : text)).split(SPLIT);
    for (var i = 0; i < parts.length; i++) {
      var part = parts[i];
      if (!part) continue;
      if (!CJK.test(part)) {
        out.push(part.toLowerCase());          // 纯拉丁/数字：整体保留
        continue;
      }
      tokenizeMixedPart(part, out);
    }
    return out.filter(function (t) { return t.length > 0 && t.length <= MAX; });
  }

  var applied = false;
  function apply(el) {
    if (!el || applied) return Boolean(el);
    applied = true;
    el.tokenizer = tokenizeCJK;
    // 索引侧没有用默认 trimmer/stemmer；查询侧也必须一致。
    if (el.Pipeline && el.Pipeline.getRegisteredFunction) {
      try { el.Pipeline.registerFunction(function (t) { return t; }, "cjk_identity"); } catch (e) {}
    }
    return true;
  }

  if (apply(window.elasticlunr)) return;

  // 兜底：老版本 mdBook 在搜索打开时才注入 elasticlunr。
  var tries = 0;
  var timer = setInterval(function () {
    if (apply(window.elasticlunr)) { clearInterval(timer); return; }
    if (++tries > 500) clearInterval(timer);   // ~30s 后放弃
  }, 60);
})();
