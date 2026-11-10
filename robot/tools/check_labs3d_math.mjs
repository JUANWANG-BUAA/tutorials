#!/usr/bin/env node
/* 3D 实验数学内核自检（node tools/check_labs3d_math.mjs）
 *
 * 把 theme/js/robot-labs-3d.js 的数学内核与书中已被 verify_*.py 核过的闭式解
 * 对拍：正运动学、雅可比、逆解、球形腕的 ZYZ 等价、特征分解。
 * 退出码 0 = 全过；1 = 有失败项。
 */
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const here = dirname(fileURLToPath(import.meta.url));
const require = createRequire(import.meta.url);
const K = require(join(here, "..", "theme", "js", "robot-labs-3d.js"));

const PI = Math.PI;
const DEG = PI / 180;
let passed = 0;
const failures = [];

function check(name, ok, detail) {
  if (ok) { passed++; return; }
  failures.push(detail ? `${name}：${detail}` : name);
}
function near(a, b, eps = 1e-10) { return Math.abs(a - b) <= eps; }
function close3(A, B, eps = 1e-10) {
  for (let i = 0; i < 3; i++) for (let j = 0; j < 3; j++) {
    if (!near(A[i][j], B[i][j], eps)) return false;
  }
  return true;
}
function frameT(f) {
  return { R: [[f.x[0], f.y[0], f.z[0]], [f.x[1], f.y[1], f.z[1]], [f.x[2], f.y[2], f.z[2]]], p: f.o };
}
const ANTHRO_ROWS = [
  { alpha: PI / 2, a: 0, d: 0, type: "R" },
  { alpha: 0, a: 0.62, d: 0, type: "R" },
  { alpha: 0, a: 0.52, d: 0, type: "R" }
];
const PLANAR_ROWS = [
  { alpha: 0, a: 0.45, d: 0, type: "R" },
  { alpha: 0, a: 0.36, d: 0, type: "R" },
  { alpha: 0, a: 0.26, d: 0, type: "R" }
];
const SPH_ROWS = [
  { alpha: -PI / 2, a: 0, d: 0, type: "R" },
  { alpha: PI / 2, a: 0, d: 0.18, type: "R" },
  { alpha: 0, a: 0, d: 0, type: "P" }
];

/* --- 1. 正运动学：DH 链 vs 书中闭式解 --- */
for (const [t1, t2, t3] of [[0.3, -0.4, 0.9], [0, 0, 0], [-1.2, 0.8, -2.0], [2.5, 1.0, 0.2]]) {
  const fr = K.fkChain(ANTHRO_ROWS, [t1, t2, t3]);
  const ref = K.anthroT3(t1, t2, t3, 0.62, 0.52);
  check("拟人臂 T₃⁰（原书式 2.66）", close3(frameT(fr[3]).R, ref.R) && fr[3].o.every((v, i) => near(v, ref.p[i])));
}
for (const [t1, t2, t3] of [[0.5, 0.3, -0.8], [0, 0, 0], [1.7, -2.2, 0.4]]) {
  const fr = K.fkChain(PLANAR_ROWS, [t1, t2, t3]);
  const ref = K.planarT3(t1, t2, t3, 0.45, 0.36, 0.26);
  check("三连杆 T₃⁰（原书式 2.63）", close3(frameT(fr[3]).R, ref.R) && fr[3].o.every((v, i) => near(v, ref.p[i])));
}
for (const [t1, t2, d3] of [[0.4, 0.7, 0.8], [0, -0.5, 0.6]]) {
  const fr = K.fkChain(SPH_ROWS, [t1, t2, d3]);
  const ref = K.sphericalT3(t1, t2, d3, 0.18);
  check("球形臂 T₃⁰（原书式 2.65）", close3(frameT(fr[3]).R, ref.R) && fr[3].o.every((v, i) => near(v, ref.p[i])));
}

/* --- 2. 欧拉角往返 --- */
{
  const R = K.zyzMatrix(30, 55, 20);
  const e = K.extractZYZ(R);
  check("ZYZ 往返", near(e.phi, 30, 1e-9) && near(e.theta, 55, 1e-9) && near(e.psi, 20, 1e-9));
  const R2 = K.rpyMatrix(-40, 25, 70);
  const e2 = K.extractRPY(R2);
  check("RPY 往返", near(e2.phi, -40, 1e-9) && near(e2.theta, 25, 1e-9) && near(e2.psi, 70, 1e-9));
}

/* --- 3. 球形腕：R₆³ 与 ZYZ 逐元素相等（2.9.5 的核心发现） --- */
{
  const WRIST_ROWS = [
    { alpha: -PI / 2, a: 0, d: 0, type: "R" },
    { alpha: PI / 2, a: 0, d: 0, type: "R" },
    { alpha: 0, a: 0, d: 0.16, type: "R" }
  ];
  for (const [t4, t5, t6] of [[0.4, -0.7, 0.5], [0, 0, 0], [1.1, 0.3, -2.0]]) {
    const fr = K.fkChain(WRIST_ROWS, [t4, t5, t6]);
    const R63 = fr[3].T.R;
    const zyz = K.zyzMatrix(t4 / DEG, t5 / DEG, t6 / DEG);
    check("球形腕 R₆³ ≡ ZYZ", close3(R63, zyz, 1e-12));
    /* 腕心固定：系 4、5 原点都在腕心 */
    check("腕心固定（o₄=o₅=o₃）",
      near(fr[1].o[0], 0) && near(fr[1].o[1], 0) && near(fr[1].o[2], 0) &&
      near(fr[2].o[0], 0) && near(fr[2].o[1], 0) && near(fr[2].o[2], 0));
  }
}

/* --- 4. 雅可比：几何雅可比 vs 书中闭式 J̄（3.2.1 / 3.2.2） --- */
{
  for (const [t1, t2, t3] of [[0.35, -0.7, 0.52], [0, 0, 0], [1.4, 0.9, -1.1]]) {
    const fr = K.fkChain(ANTHRO_ROWS, [t1, t2, t3]);
    const Jgeo = K.geoJacPos(fr);
    const Jref = K.anthroJbar(t1, t2, t3, 0.62, 0.52);
    check("拟人臂 J̄（3.2.2 式 3.37）", close3(Jgeo, Jref, 1e-12));
    /* 行列式：-a₂a₃ s₃ (a₂c₂ + a₃c₂₃) */
    const det = K.det3(Jref);
    const s3 = Math.sin(t3);
    const f2 = 0.62 * Math.cos(t2) + 0.52 * Math.cos(t2 + t3);
    check("拟人臂 det J̄ = -a₂a₃s₃(a₂c₂+a₃c₂₃)", near(det, -0.62 * 0.52 * s3 * f2, 1e-12),
      `det=${det} 期望=${-0.62 * 0.52 * s3 * f2}`);
  }
  /* 平面三连杆：J̄ 的前两行 = 几何雅可比，第 3 行 = [1,1,1] */
  const fr = K.fkChain(PLANAR_ROWS, [0.6, -0.8, 0.35]);
  const Jgeo = K.geoJacPos(fr);
  const ref = K.planarT3(0.6, -0.8, 0.35, 0.45, 0.36, 0.26);
  const s12 = Math.sin(0.6 - 0.8), s123 = Math.sin(0.6 - 0.8 + 0.35);
  const c12 = Math.cos(0.6 - 0.8), c123 = Math.cos(0.6 - 0.8 + 0.35);
  check("三连杆 J̄ 第 1 行（3.2.1）",
    near(Jgeo[0][0], -0.45 * Math.sin(0.6) - 0.36 * s12 - 0.26 * s123, 1e-12) &&
    near(Jgeo[0][1], -0.36 * s12 - 0.26 * s123, 1e-12) &&
    near(Jgeo[0][2], -0.26 * s123, 1e-12));
  check("三连杆 J̄ 第 2 行（3.2.1）",
    near(Jgeo[1][0], 0.45 * Math.cos(0.6) + 0.36 * c12 + 0.26 * c123, 1e-12) &&
    near(Jgeo[1][1], 0.36 * c12 + 0.26 * c123, 1e-12) &&
    near(Jgeo[1][2], 0.26 * c123, 1e-12));
}

/* --- 5. 逆运动学：四支解代回正运动学应回到目标（原书式 2.98–2.110） --- */
{
  const targets = [
    [0.55, 0.30, 0.35], [0.40, -0.25, 0.50], [-0.60, 0.20, -0.30],
    [0.20, 0.60, 0.10], [0.70, 0.10, -0.10]
  ];
  for (const p of targets) {
    const ik = K.anthroIK(p, 0.62, 0.52);
    check("逆解可达性（式 2.98）", ik.reachable, `p=${p}`);
    if (!ik.reachable) continue;
    check("逆解支数 = 4", ik.solutions.length === 4);
    for (const sol of ik.solutions) {
      const fr = K.fkChain(ANTHRO_ROWS, [sol.th1, sol.th2, sol.th3]);
      const err = Math.hypot(fr[3].o[0] - p[0], fr[3].o[1] - p[1], fr[3].o[2] - p[2]);
      check("逆解 FK 回代误差", err < 1e-9, `p=${p} err=${err}`);
    }
    /* 肩双支相差 π */
    const right = ik.solutions.find((s) => s.shoulder === "right");
    const left = ik.solutions.find((s) => s.shoulder === "left");
    const d = Math.abs(Math.abs(right.th1 - left.th1) - PI);
    check("肩双支 θ₁ 相差 π", d < 1e-9, `Δ=${Math.abs(right.th1 - left.th1)}`);
  }
  /* 超出可达范围 → 不可达 */
  const far = K.anthroIK([2.0, 0, 0], 0.62, 0.52);
  check("超出容许性条件 → 无解", !far.reachable);
  /* 肩轴上 → θ₁ 任意（肩奇异） */
  const onAxis = K.anthroIK([0, 0, 0.5], 0.62, 0.52);
  check("肩轴上 → 肩奇异标记", onAxis.reachable && onAxis.shoulderSingular);
}

/* --- 6. 特征分解：对称 3×3 的特征值/特征向量 --- */
{
  const A = [[4, 1, 0.5], [1, 3, 0.2], [0.5, 0.2, 2]];
  const eig = K.symEig3(A);
  const sum = eig.values.reduce((s, v) => s + v, 0);
  const tr = A[0][0] + A[1][1] + A[2][2];
  check("特征值之和 = 迹", near(sum, tr, 1e-9), `${sum} vs ${tr}`);
  /* A v = λ v */
  let worst = 0;
  for (let j = 0; j < 3; j++) {
    const v = [eig.vectors[0][j], eig.vectors[1][j], eig.vectors[2][j]];
    const Av = [0, 1, 2].map((i) => A[i][0] * v[0] + A[i][1] * v[1] + A[i][2] * v[2]);
    const lam = eig.values[j];
    for (let i = 0; i < 3; i++) worst = Math.max(worst, Math.abs(Av[i] - lam * v[i]));
  }
  check("特征方程 A v = λ v", worst < 1e-8, `残差 ${worst}`);
}

/* --- 7. 椭球半轴：λ(JJᵀ) 的平方根 --- */
{
  const J = K.anthroJbar(0.35, -0.7, 0.52, 0.62, 0.52);
  const E = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
  for (let i = 0; i < 3; i++) for (let j = 0; j < 3; j++) {
    let s = 0;
    for (let k = 0; k < 3; k++) s += J[k][i] * J[k][j];
    E[i][j] = s;
  }
  const eig = K.symEig3(E);
  const prod = eig.values.reduce((s, v) => s * Math.max(0, v), 1);
  const detJ = K.det3(J);
  check("det(JJᵀ) = det(J)²", near(prod, detJ * detJ, 1e-9), `${prod} vs ${detJ * detJ}`);
}

/* --- 报告 --- */
if (failures.length === 0) {
  console.log(`check_labs3d_math: OK（${passed} 项）`);
  process.exit(0);
}
console.log(`check_labs3d_math: ${failures.length} 项失败（通过 ${passed} 项）`);
failures.forEach((f) => console.log("  - " + f));
process.exit(1);
