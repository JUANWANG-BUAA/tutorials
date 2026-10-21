// Lossless wire format for elasticlunr's very repetitive trie. The in-memory
// index and scoring remain unchanged; only the downloaded representation differs.
export function compactSearchIndex(payload) {
  const scores = [];
  const scoreIds = new Map();
  function scoreId(tf) {
    if (!scoreIds.has(tf)) { scoreIds.set(tf, scores.length); scores.push(tf); }
    return scoreIds.get(tf);
  }
  function pack(node) {
    const out = {};
    for (const [key, value] of Object.entries(node)) {
      if (key === 'df') continue; // always the number of document references
      if (key === 'docs') {
        if (Object.keys(value).length) out.docs = Object.entries(value).flatMap(([id, doc]) => [
          String(Number(id)) === id && Number.isSafeInteger(Number(id)) ? Number(id) : id,
          scoreId(doc.tf)
        ]);
      } else out[key] = pack(value);
    }
    return out;
  }
  for (const field of Object.values(payload.index.index)) field.root = pack(field.root);
  payload._scores = scores;
  return payload;
}

// This function is also serialized into searchindex.js. Keep it self-contained.
export function expandSearchIndex(payload) {
  const scores = payload._scores;
  function unpack(node) {
    const refs = node.docs || [];
    const docs = {};
    for (let i = 0; i < refs.length; i += 2) docs[refs[i]] = { tf: scores[refs[i + 1]] };
    for (const key of Object.keys(node)) if (key !== 'docs') unpack(node[key]);
    node.docs = docs;
    node.df = refs.length / 2;
  }
  for (const field of Object.values(payload.index.index)) unpack(field.root);
  delete payload._scores;
  return payload;
}
