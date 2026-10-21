/* Register after the reading UI is ready. No precache or whole-book download. */
(function () {
  "use strict";
  var script = document.currentScript;
  if (!script || !script.dataset.worker || !window.isSecureContext || !("serviceWorker" in navigator)) return;
  var worker = new URL(script.dataset.worker, location.href);
  function register() {
    navigator.serviceWorker.register(worker.href, { updateViaCache: "none" }).catch(function () {
      // Private browsing / storage denial must not affect reading.
    });
  }
  function schedule() {
    if (window.requestIdleCallback) window.requestIdleCallback(register, { timeout: 3000 });
    else window.setTimeout(register, 1000);
  }
  if (document.readyState === "complete") schedule();
  else window.addEventListener("load", schedule, { once: true });
})();
