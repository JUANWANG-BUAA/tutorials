/* 本地教学计算器：不依赖外部库，不发送网络请求。 */
(function () {
  "use strict";

  const decimal = new Intl.NumberFormat("zh-CN", { maximumFractionDigits: 3 });
  const integer = new Intl.NumberFormat("zh-CN", { maximumFractionDigits: 0 });
  const percent = new Intl.NumberFormat("zh-CN", { maximumSignificantDigits: 6 });
  const stages = ["DP / ZeRO-0", "ZeRO-1", "ZeRO-2", "ZeRO-3"];

  function element(tag, text) {
    const node = document.createElement(tag);
    node.textContent = text;
    return node;
  }

  function field(form, name) {
    return form.elements.namedItem(name);
  }

  function number(form, name, label, optional) {
    const input = field(form, name);
    if (optional && input.value.trim() === "") return null;
    const value = input.valueAsNumber;
    if (input.value.trim() === "" || !Number.isFinite(value) || !input.validity.valid) {
      input.setAttribute("aria-invalid", "true");
      throw new Error(label + "：请输入字段范围内的" + (input.step === "1" ? "整数。" : "有限数字。"));
    }
    return value;
  }

  function memory(bytes) {
    return decimal.format(bytes / 1e9) + " GB（" + decimal.format(bytes / 2 ** 30) + " GiB）";
  }

  function table(caption, headings, rows) {
    const wrapper = document.createElement("div");
    wrapper.className = "calc-scroll";
    const result = document.createElement("table");
    result.append(element("caption", caption));
    const head = result.createTHead().insertRow();
    headings.forEach(function (heading) {
      const cell = element("th", heading);
      cell.scope = "col";
      head.append(cell);
    });
    const body = result.createTBody();
    rows.forEach(function (row) {
      const tr = body.insertRow();
      row.forEach(function (value, index) {
        const cell = element(index === 0 ? "th" : "td", value);
        if (index === 0) cell.scope = "row";
        tr.append(cell);
      });
    });
    wrapper.append(result);
    return wrapper;
  }

  function adam(form, result) {
    const extras = field(form, "extras").checked;
    ["activation", "buffer", "unit"].forEach(function (name) {
      field(form, name).disabled = !extras;
    });
    const n = number(form, "parameters", "模型参数总数 N");
    const k = number(form, "gpus", "GPU 数 k");
    const stage = Number(field(form, "stage").value);
    const activation = extras ? number(form, "activation", "每卡激活估计") : 0;
    const buffer = extras ? number(form, "buffer", "每卡缓冲估计") : 0;
    const unit = field(form, "unit").value === "GiB" ? 2 ** 30 : 1e9;
    const extraBytes = (activation + buffer) * unit;
    // 参数、梯度、主权重、m、v。ZeRO-1 将后三项分片。
    const values = stages.map(function (_, index) {
      return [2 * n / (index >= 3 ? k : 1), 2 * n / (index >= 2 ? k : 1),
        4 * n / (index >= 1 ? k : 1), 4 * n / (index >= 1 ? k : 1),
        4 * n / (index >= 1 ? k : 1)];
    });
    const totals = values.map(function (parts) {
      return parts.reduce(function (sum, part) { return sum + part; }, 0);
    });
    result.append(element("p", "当前选择：" + stages[stage] + "；每卡静态状态 " + memory(totals[stage]) + "。"));
    const names = ["低精度参数（2 字节）", "低精度梯度（2 字节）", "FP32 主权重（4 字节）", "Adam 一阶矩 m（4 字节）", "Adam 二阶矩 v（4 字节）"];
    result.append(table("所选策略的每卡状态分解", ["状态", "GB", "GiB"], values[stage].map(function (bytes, index) {
      return [names[index], decimal.format(bytes / 1e9), decimal.format(bytes / 2 ** 30)];
    })));
    result.append(table("相同 N、k 下的静态状态比较（每卡）", ["策略", "GB", "GiB"], totals.map(function (bytes, index) {
      return [stages[index] + (index === stage ? "（当前）" : ""), decimal.format(bytes / 1e9), decimal.format(bytes / 2 ** 30)];
    })));
    if (extras) {
      result.append(element("p", "每卡额外输入：激活 " + memory(activation * unit) + "，缓冲 / 工作区 " + memory(buffer * unit) + "。静态 + 额外预算合计：" + memory(totals[stage] + extraBytes) + " / 卡；不是实测峰值。"));
    } else {
      result.append(element("p", "尚未计入激活和额外缓冲；这里的静态状态不是实测峰值。"));
    }
  }

  function lora(form, result) {
    const rank = number(form, "rank", "LoRA rank");
    const input = number(form, "input", "输入维度");
    const output = number(form, "output", "输出维度");
    const count = number(form, "count", "矩阵个数");
    const base = number(form, "base", "基座参数总数", true);
    const total = rank * (input + output) * count;
    if (!Number.isSafeInteger(total)) {
      throw new Error("新增参数总数超出 JavaScript 可精确表示的整数范围（最大 9,007,199,254,740,991）；请减小输入或按形状拆组计算。");
    }
    result.append(element("p", "新增参数：" + integer.format(rank) + " × (" + integer.format(input) + " + " + integer.format(output) + ") × " + integer.format(count) + " = " + integer.format(total) + " 个。"));
    result.append(element("p", "A 矩阵合计 " + integer.format(rank * input * count) + " 个，B 矩阵合计 " + integer.format(rank * output * count) + " 个；仅计算这一组同形状矩阵。"));
    if (base !== null) {
      result.append(element("p", "新增 / 基座：" + integer.format(total) + " / " + integer.format(base) + " × 100% = " + percent.format(total / base * 100) + "%（分母不含新增参数）。"));
    } else {
      result.append(element("p", "未填写基座参数总数，未计算百分比。"));
    }
  }

  function bind(id, calculate) {
    const form = document.getElementById(id + "-calculator");
    if (!form) return;
    const result = document.getElementById(id + "-result");
    const error = document.getElementById(id + "-error");
    function update() {
      form.querySelectorAll('[aria-invalid="true"]').forEach(function (input) {
        input.removeAttribute("aria-invalid");
      });
      error.textContent = "";
      result.replaceChildren();
      try {
        calculate(form, result);
      } catch (failure) {
        error.textContent = failure instanceof Error ? failure.message : "无法计算，请检查输入。";
      }
    }
    form.addEventListener("input", update);
    form.addEventListener("change", update);
    form.addEventListener("submit", function (event) {
      event.preventDefault();
      update();
      const invalid = form.querySelector('[aria-invalid="true"]');
      if (invalid) invalid.focus();
    });
    update();
  }

  function boot() {
    bind("adam", adam);
    bind("lora", lora);
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot, { once: true });
  } else {
    boot();
  }
})();
