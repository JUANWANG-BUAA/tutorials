/*
 * search-cjk.js — 让 mdBook 的全文搜索支持中文
 * ---------------------------------------------------------------------------
 * 背景：mdBook 的分词器只按空白/连字符切词，且 elasticlunr 默认的 trimmer 会
 * 丢掉不含拉丁字母的 token，因此中文内容根本进不了索引、也搜不到。
 *
 * 配套两步修复：
 *   1) 构建后由 tools/build_search_js.mjs 用「一元 + 二元字符 n-gram」重建索引；
 *   2) 本脚本在浏览器侧把 elasticlunr 的分词器换成同一套 n-gram 规则，
 *      使「查询」与「索引」使用完全相同的切分，召回才稳定可靠。
 *
 * 例：「数域」→ 数 / 数域 / 域；「过渡矩阵」→ 过/过渡/渡/渡矩/矩/矩阵/阵。
 * 由于两者一致，任意长度（≤ 词长上限）的中文短语都能命中。
 *
 * elasticlunr 是搜索打开时才懒加载的，所以这里轮询等待它出现再改写。
 */
(function () {
  "use strict";

  var CJK = /[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\u3040-\u30ff]/;
  var SPLIT = /[\s\-·，。、；：？！“”‘’（）()《》〈〉【】\[\]{}<>／/\\|,.;:!?"']+/;
  var MAX = 80;

  function tokenizeCJK(text) {
    var out = [];
    var parts = String(text == null ? "" : text).split(SPLIT);
    for (var i = 0; i < parts.length; i++) {
      var part = parts[i];
      if (!part) continue;
      if (!CJK.test(part)) {
        out.push(part.toLowerCase());          // 纯拉丁/数字：整体保留
        continue;
      }
      var chars = Array.from(part);
      for (var k = 0; k < chars.length; k++) {
        out.push(chars[k].toLowerCase());      // 一元
        if (k + 1 < chars.length) out.push((chars[k] + chars[k + 1]).toLowerCase()); // 二元
      }
    }
    return out.filter(function (t) { return t.length > 0 && t.length <= MAX; });
  }

  var tries = 0;
  var timer = setInterval(function () {
    var el = window.elasticlunr;
    if (el) {
      el.tokenizer = tokenizeCJK;
      // 索引侧没有用默认 trimmer/stemmer；查询侧也必须一致。
      if (el.Pipeline && el.Pipeline.getRegisteredFunction) {
        try { el.Pipeline.registerFunction(function (t) { return t; }, "cjk_identity"); } catch (e) {}
      }
      if (el.Index) {
        // 保证 load 出来的索引沿用空 pipeline（索引里已写明 pipeline: []）
      }

      // 对齐构建时探针的权重（build_search_js.mjs 里 title:4, breadcrumbs:2），
      // mdBook 默认 searcher.js 给的是 title:1, breadcrumbs:0，标题优势被抹平。
      // 在原型层拦截 search()，把缺省的 boost 提升到与构建验证一致。
      var origSearch = el.Index.prototype.search;
      el.Index.prototype.search = function (query, userOpts) {
        // mdBook searcher.js 总是传入 title:1, body:1, breadcrumbs:0，
        // 标题优势被完全抹平。检测到默认权重时替换为构建探针的权重。
        if (userOpts && userOpts.fields && userOpts.fields.title && userOpts.fields.title.boost === 1) {
          userOpts = Object.assign({}, userOpts, {
            fields: { title: { boost: 4 }, body: { boost: 1 }, breadcrumbs: { boost: 2 } }
          });
        }
        return origSearch.call(this, query, userOpts);
      };

      clearInterval(timer);
      return;
    }
    if (++tries > 150) clearInterval(timer);   // ~30s 后放弃
  }, 200);
})();
