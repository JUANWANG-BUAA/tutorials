/* Numerical textbook: complete body text and a compact chapter tree. */
(function () {
  "use strict";

  // A prior reading preference must not hide proofs in the rewritten textbook.
  document.documentElement.classList.remove("core-only");
  window.TUTORIALS_NAV = { defaultCollapsed: true };

  window.TUTORIALS_EXTRAS.boot({
    slug: "numerical",
    pageTocLevels: ["h2"],
    toolbarPlacement: "inline",
    formulaHint: false
  });
})();
