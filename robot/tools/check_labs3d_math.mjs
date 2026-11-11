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

/* --- 8. 边界与退化情形（这一组专门盯 NaN / 发散） --- */
{
  /* 全移动关节链 */
  const prismatic = [
    { alpha: 0, a: 0, d: 0, type: "P" },
    { alpha: 0, a: 0, d: 0, type: "P" }
  ];
  const fr = K.fkChain(prismatic, [0.3, 0.2]);
  check("全 P 关节：位置有限", fr[2].o.every(Number.isFinite));

  /* 零长连杆（a=0）不应产生 NaN */
  const zero = K.fkChain([{ alpha: 0, a: 0, d: 0, type: "R" }], [0.4]);
  check("零长连杆无 NaN", zero[1].o.every(Number.isFinite) && Number.isFinite(zero[1].T.R[0][0]));

  /* 奇异边界：c₃ = ±1（肘伸直/折回） */
  const a2 = 0.62, a3 = 0.52;
  const straight = a2 + a3;                       // ‖p_w‖ = a₂+a₃ ⇒ 肘伸直
  const edge = K.anthroIK([straight, 0, 0], a2, a3);
  check("肘伸直边界：可达且 s₃=0", edge.reachable && Math.abs(edge.c3 - 1) < 1e-12);
  if (edge.reachable) {
    check("肘伸直边界：FK 回代成立",
      edge.solutions.every(sol => {
        const f = K.fkChain([
          { alpha: Math.PI / 2, a: 0, d: 0, type: "R" },
          { alpha: 0, a: a2, d: 0, type: "R" },
          { alpha: 0, a: a3, d: 0, type: "R" }
        ], [sol.th1, sol.th2, sol.th3]);
        const p = f[3].o;
        return Math.abs(p[0] - straight) < 1e-9 && Math.abs(p[1]) < 1e-9 && Math.abs(p[2]) < 1e-9;
      }));
  }
  /* 刚超出容许性条件 */
  const over = K.anthroIK([straight + 0.01, 0, 0], a2, a3);
  check("刚超出容许性条件 → 不可达", !over.reachable);

  /* 肩轴上（p_x=p_y=0）：θ₁ 任意 */
  const onAxis = K.anthroIK([0, 0, 0.5], a2, a3);
  check("肩轴上 → 肩奇异标记", onAxis.reachable && onAxis.shoulderSingular === true);

  /* 欧拉角奇点：s_ϑ=0 / c_ϑ=0 */
  const zyzSing = K.extractZYZ([[1, 0, 0], [0, 1, 0], [0, 0, 1]]);
  check("ZYZ 奇异被识别", zyzSing.ok === false);
  const rpySing = K.extractRPY([[0, 0, 1], [0, 1, 0], [-1, 0, 0]]);   // Ry(90°)：c_ϑ=0 万向节锁定
  check("RPY 奇异被识别（ϑ=±90°）", rpySing.ok === false);
  const rpyNormal = K.extractRPY([[1, 0, 0], [0, 1, 0], [0, 0, 1]]);
  check("RPY 非奇异（单位阵）不误报", rpyNormal.ok === true);

  /* 特征分解：重复特征值（单位阵）、零阵、对角阵 */
  const id = K.symEig3([[1, 0, 0], [0, 1, 0], [0, 0, 1]]);
  check("对称分解（单位阵）无 NaN", id.values.every(Number.isFinite));
  const zeroM = K.symEig3([[0, 0, 0], [0, 0, 0], [0, 0, 0]]);
  check("对称分解（零阵）无 NaN", zeroM.values.every(Number.isFinite));
  const diag = K.symEig3([[3, 0, 0], [0, 1, 0], [0, 0, 2]]);
  const sorted = diag.values.slice().sort((x, y) => x - y);
  check("对称分解（对角阵）特征值正确",
    near(sorted[0], 1, 1e-8) && near(sorted[1], 2, 1e-8) && near(sorted[2], 3, 1e-8));

  /* 单关节雅可比 */
  const one = K.geoJacPos(K.fkChain([{ alpha: 0, a: 0.3, d: 0, type: "R" }], [0.5]));
  check("单关节几何雅可比为 3×1", one.length === 3 && one[0].length === 1 && Number.isFinite(one[0][0]));
  const dlr = K.zooKinds().find(kind => kind.id === "dlr");
  const seven = K.fkChain(dlr.rows, dlr.rows.map(row => row.def * DEG));
  const J7 = K.geoJacPos(seven);
  check("七自由度雅可比为 3×7 且无 undefined",
    J7.length === 3 && J7.every(row => row.length === 7) &&
    J7.every(row => row.every(v => typeof v === "number" && Number.isFinite(v))));

  /* 奇异矩阵行列式 */
  check("det3（奇异阵）为 0", near(K.det3([[1, 2, 3], [2, 4, 6], [1, 1, 1]]), 0, 1e-12));
}

{
  const kinds = K.zooKinds();
  const cartesian = kinds.find(kind => kind.id === "cartesian");
  const initial = cartesian.rows.map(row => row.def);
  const baseFrames = K.fkChain(cartesian.rows, initial);
  for (let joint = 0; joint < 3; joint++) {
    const axis = baseFrames[joint].z;
    check(`笛卡儿实际模型第 ${joint + 1} 轴为单位向量`, near(K.len(axis), 1));
    for (let other = joint + 1; other < 3; other++) {
      check(`笛卡儿实际模型轴 ${joint + 1}/${other + 1} 正交`, near(K.dot(axis, baseFrames[other].z), 0));
    }
    const changed = initial.slice();
    changed[joint] += 0.1;
    const displacement = K.subv(K.fkChain(cartesian.rows, changed).at(-1).o, baseFrames.at(-1).o);
    const expected = [0, 0, 0];
    expected[2 - joint] = 0.1;
    check(`笛卡儿练习第 ${joint + 1} 滑杆只改变对应坐标`, K.len(K.subv(displacement, expected)) < 1e-10);
  }
  const dlr = kinds.find(kind => kind.id === "dlr");
  check("DLR 实际模型为七个转动关节", dlr.rows.length === 7 && dlr.rows.every(row => row.type === "R"));
  for (const joint of [2, 4, 6]) {
    for (const angle of [-1.1, 0, 0.8]) {
      const angles = dlr.rows.map(row => row.def * DEG);
      angles[joint] = angle;
      const frames = K.fkChain(dlr.rows, angles);
      check(`DLR 第 ${joint + 1} 轴转动 ${angle} 不伸缩连杆`,
        near(K.len(K.subv(frames[joint + 1].o, frames[joint].o)), dlr.rows[joint].d));
    }
  }
  for (const id of ["anthroWrist", "stanford"]) {
    const kind = kinds.find(candidate => candidate.id === id);
    const angles = kind.rows.map(row => row.type === "P" ? row.def : row.def * DEG);
    const frames = K.fkChain(kind.rows, angles);
    for (let joint = 3; joint < 6; joint++) {
      for (const value of [-1.2, 0, 1.3]) {
        const changed = angles.slice();
        changed[joint] = value;
        const result = K.fkChain(kind.rows, changed);
        check(`${id} 第 ${joint + 1} 轴 ${value} 腕心不动且偏置固定`,
          K.len(K.subv(result[4].o, frames[4].o)) < 1e-10 &&
          near(K.len(K.subv(result.at(-1).o, result[4].o)), kind.rows[5].d));
      }
    }
    const changed = angles.slice();
    changed[3] += 0.5;
    check(`${id} 腕转动可改变工具点 P`, K.len(K.subv(K.fkChain(kind.rows, changed).at(-1).o, frames.at(-1).o)) > 1e-3);
    changed[3] = angles[3];
    changed[5] += 0.5;
    const spin = K.fkChain(kind.rows, changed).at(-1);
    check(`${id} 工具自转时 P 不动但朝向改变`,
      K.len(K.subv(spin.o, frames.at(-1).o)) < 1e-10 && K.len(K.subv(spin.x, frames.at(-1).x)) > 0.1);
  }
  for (const height of [0.25, 0.45, 0.7]) {
    const legs = K.zooParallelGeometry(height);
    check(`并联升降 ${height} m 四腿固定接在平台内`, legs.length === 4 && legs.every(leg =>
      near(leg.platform[2], height) && Math.abs(leg.platform[0]) < 0.18 && Math.abs(leg.platform[1]) < 0.18 &&
      near(Math.hypot(leg.platform[0], leg.platform[1]), 0.2) && near(leg.length, Math.hypot(0.2, height))));
  }
  const target = [0.6, 0.2, 0.4];
  check("腕心数值例：工具向上", K.len(K.subv(K.subv(target, [0, 0, 0.1]), [0.6, 0.2, 0.3])) < 1e-10);
  check("腕心数值例：工具向 x", K.len(K.subv(K.subv(target, [0.1, 0, 0]), [0.5, 0.2, 0.4])) < 1e-10);
}

{
  const input = {vl:0.2, vr:0.6, speed:0.5, delta:20, side:0, yaw:0};
  const diff = K.chassisMotion("diff", input);
  check("差动数字例：平均速度与轮距公式", near(diff.vx, 0.4) && near(diff.vy, 0) && near(diff.omega, 0.4 / 0.56));
  check("差动左右轮读数与输入一致", near(diff.wheels[0].speed, 0.2) && near(diff.wheels[1].speed, 0.6));
  const spin = K.chassisMotion("diff", {...input,vl:-0.5,vr:0.5});
  check("差动等速反向原地左转", near(spin.vx, 0) && near(spin.omega, 1 / 0.56));
  const reverse = K.chassisMotion("diff", {...input,vl:-0.5,vr:-0.5});
  check("差动倒车保留负速度", near(reverse.vx, -0.5) && near(reverse.omega, 0));
  const synchro = K.chassisMotion("synchro", {...input,delta:30});
  check("同步共同轮向改变平移方向但不转车身", near(synchro.vx, Math.sqrt(3) / 4) && near(synchro.vy, 0.25) && near(synchro.omega, 0));
  check("同步三个轮向与速度相同", synchro.wheels.every(wheel => near(wheel.heading, PI/6) && near(wheel.speed, 0.5)));
  const left = K.chassisMotion("car", input);
  const right = K.chassisMotion("car", {...input,delta:-20});
  check("阿克曼左转左轮角更大", left.wheels[2].heading > left.wheels[3].heading && left.wheels[3].heading > 0);
  check("阿克曼左右转角镜像且内外轮角色互换", near(left.wheels[2].heading, -right.wheels[3].heading) && near(left.wheels[3].heading, -right.wheels[2].heading));
  check("阿克曼转弯半径由舵角导出", near(left.radius, 0.68/Math.tan(20*DEG)) && near(left.omega, 0.5/left.radius));
  check("阿克曼角数字例", near(left.wheels[2].heading / DEG, 23.4413021175, 1e-8) && near(left.wheels[3].heading / DEG, 17.4120487203, 1e-8));
  const straight = K.chassisMotion("car", {...input,delta:0});
  check("汽车零舵角两轮回正，不产生假转弯", straight.radius === null && near(straight.omega, 0) && straight.wheels.every(wheel=>near(wheel.heading,0)));
  const sideways = K.chassisMotion("omni3", {...input,speed:0,side:0.5});
  check("自位轮横移示意使用独立左向速度", near(sideways.vx,0) && near(sideways.vy,0.5) && near(sideways.omega,0));
  check("自位轮横移滚动速度与偏置转向速率", sideways.wheels.every((wheel,index)=>
    near(wheel.speed,[0,Math.sqrt(3)/4,-Math.sqrt(3)/4][index]) && near(wheel.swivel,[0.5/0.06,-0.25/0.06,-0.25/0.06][index])));
  for(const layout of K.chassisLayouts()) {
    for(const delta of [-35,0,35]) {
      for(const speed of [-1,0,1]) {
        const motion = K.chassisMotion(layout.id,{...input,delta,speed,side:0.3,yaw:-0.2});
        check(`${layout.id} ${delta}° ${speed} m/s 每轮满足无侧滑`,motion.wheels.every(wheel=>
          Number.isFinite(wheel.speed) && Number.isFinite(wheel.swivel) &&
          near(K.dot([-Math.sin(wheel.heading),Math.cos(wheel.heading),0],wheel.velocity),0)));
      }
    }
  }
}

{
  const basis = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
  const rotate = (vector, axis, angle) => {
    const cosine = Math.cos(angle * DEG);
    const sine = Math.sin(angle * DEG);
    const projection = axis.reduce((sum, value, index) => sum + value * vector[index], 0);
    const cross = [axis[1] * vector[2] - axis[2] * vector[1],
      axis[2] * vector[0] - axis[0] * vector[2], axis[0] * vector[1] - axis[1] * vector[0]];
    return vector.map((value, index) => cosine * value + sine * cross[index] + (1 - cosine) * projection * axis[index]);
  };
  const columns = matrix => basis.map((unused, column) => matrix.map(row => row[column]));
  for (const tilt of [0, 45]) {
    const initialColumns = basis.map(vector => rotate(vector, basis[0], tilt));
    const initial = basis.map((unused, row) => initialColumns.map(column => column[row]));
    for (const angleY of [-180, -90, -35, 0, 30, 90, 180]) {
      for (const angleZ of [-180, -90, -35, 0, 30, 90, 180]) {
        for (const mode of ["fixed", "current"]) {
          for (const order of ["yz", "zy"]) {
            const result = K.compositionSteps(angleY, angleZ, mode, order, initial);
            const label = `合成 tilt=${tilt} y=${angleY} z=${angleZ} ${mode} ${order}`;
            check(label + " 初态保留", close3(result[0].R, initial) && result[0].axis === null);
            let expected = initialColumns;
            for (let step = 1; step <= 2; step++) {
              const axisIndex = order[step - 1] === "y" ? 1 : 2;
              const axis = mode === "fixed" ? basis[axisIndex] : expected[axisIndex];
              const angle = axisIndex === 1 ? angleY : angleZ;
              expected = expected.map(vector => rotate(vector, axis, angle));
              check(label + ` 第 ${step} 步世界转轴`, result[step].axis.every((value, index) => near(value, axis[index])));
              check(label + ` 第 ${step} 步三轴几何`, columns(result[step].R).every((column, index) =>
                column.every((value, component) => near(value, expected[index][component]))));
            }
          }
        }
        const fixed = K.compositionSteps(angleY, angleZ, "fixed", "yz", initial)[2].R;
        const reversedCurrent = K.compositionSteps(angleY, angleZ, "current", "zy", initial)[2].R;
        if (tilt === 0) check("单位初态成对倒序等价", close3(fixed, reversedCurrent));
        if (tilt === 45 && angleY === 90 && angleZ === 90) check("非单位初态不能无条件倒序", !close3(fixed, reversedCurrent));
      }
    }
  }
  for (const mode of ["fixed", "current"]) {
    for (const angles of [[0, 90], [90, 0], [180, 180], [-180, 180]]) {
      check(`${mode} 特殊可交换 ${angles}`, close3(
        K.compositionSteps(...angles, mode, "yz", K.Tid().R)[2].R,
        K.compositionSteps(...angles, mode, "zy", K.Tid().R)[2].R));
    }
  }
  const fixed = K.compositionSteps(90, 90, "fixed", "yz", K.Tid().R);
  const current = K.compositionSteps(90, 90, "current", "yz", K.Tid().R);
  check("演示默认固定两步与正文 RA", close3(fixed[2].R, [[0, -1, 0], [0, 0, 1], [-1, 0, 0]]));
  check("演示当前两步与正文 RB", close3(current[2].R, [[0, 0, 1], [1, 0, 0], [0, 1, 0]]));
  check("第二步固定 z 与当前 z 的世界方向不同", fixed[2].axis.every((value, index) => near(value, basis[2][index])) &&
    current[2].axis.every((value, index) => near(value, basis[0][index])));
}

{
  const basis = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
  const rotate = (vector, axis, angle) => {
    const cosine = Math.cos(angle * DEG);
    const sine = Math.sin(angle * DEG);
    const projection = axis.reduce((sum, value, index) => sum + value * vector[index], 0);
    const cross = [axis[1] * vector[2] - axis[2] * vector[1],
      axis[2] * vector[0] - axis[0] * vector[2], axis[0] * vector[1] - axis[1] * vector[0]];
    return vector.map((value, index) => cosine * value + sine * cross[index] + (1 - cosine) * projection * axis[index]);
  };
  for (const mode of ["zyz", "rpy"]) {
    const forward = mode === "zyz" ? K.zyzMatrix : K.rpyMatrix;
    const inverse = mode === "zyz" ? K.extractZYZ : K.extractRPY;
    for (const phi of [-180, -130, 0, 30, 90, 180]) {
      for (const theta of [-180, -150, -90, -89.999999, -35, -0.000001, 0, 0.000001, 1, 55, 89.999999, 90, 150, 180]) {
        for (const psi of [-180, -40, 0, 20, 180]) {
          const label = mode + " " + [phi, theta, psi];
          const steps = K.eulerSteps(mode, phi, theta, psi);
          const names = mode === "zyz" ? [2, 1, 2] : [0, 1, 2];
          const angles = mode === "zyz" ? [phi, theta, psi] : [psi, theta, phi];
          let expected = basis;
          check(label + " 初始 I", close3(steps[0].R, K.Tid().R) && steps[0].axis === null);
          for (let index = 0; index < 3; index++) {
            const axis = mode === "zyz" ? expected[names[index]] : basis[names[index]];
            expected = expected.map(vector => rotate(vector, axis, angles[index]));
            check(label + " 转轴 " + index, steps[index + 1].axis.every((value, component) => near(value, axis[component])));
            check(label + " 几何三轴 " + index, expected.every((vector, column) =>
              vector.every((value, row) => near(value, steps[index + 1].R[row][column]))));
          }
          const rotation = forward(phi, theta, psi);
          check(label + " 正解与几何一致", close3(rotation, steps[3].R));
          const result = inverse(rotation);
          check(label + " 主支或奇点代表重建", close3(rotation, forward(result.phi, result.theta, result.psi), 1e-9));
          const singular = mode === "zyz" ? Math.abs(Math.sin(theta * DEG)) < 1e-12 : Math.abs(Math.cos(theta * DEG)) < 1e-12;
          check(label + " 精确与近奇点区分", result.ok === !singular);
          if (singular) {
            const expectedCombination = mode === "zyz"
              ? (Math.cos(theta * DEG) > 0 ? "φ+ψ" : "φ−ψ")
              : (Math.sin(theta * DEG) > 0 ? "φ−ψ" : "φ+ψ");
            check(label + " 奇点有效组合", result.combination === expectedCombination && result.psi === 0);
          } else {
            const secondTheta = mode === "zyz" ? -result.theta : 180 - result.theta;
            check(label + " 第二支重建", close3(rotation, forward(result.phi + 180, secondTheta, result.psi + 180)));
          }
          const otherForward = mode === "zyz" ? K.rpyMatrix : K.zyzMatrix;
          const otherInverse = mode === "zyz" ? K.extractRPY : K.extractZYZ;
          for (const entry of steps) {
            const other = otherInverse(entry.R);
            check(label + " 每一步跨约定保姿态", close3(entry.R, otherForward(other.phi, other.theta, other.psi), 1e-9));
          }
        }
      }
    }
  }
  const example = [[0, -1, 0], [0, 0, 1], [-1, 0, 0]];
  check("2.4 手算矩阵", close3(K.zyzMatrix(90, 90, 0), example));
  check("2.4 RPY 奇点例题", close3(K.rpyMatrix(120, 90, 30), example));
  check("2.4 RPY 练习第二支", close3(K.rpyMatrix(30, 30, -30), K.rpyMatrix(-150, 150, 150)));
  check("2.4 Atan2 近奇点半径", near(1 / Math.sin(0.01 * DEG), 5729.577980397053, 1e-8));
}

{
  const basis = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
  const quaternionMatrix = (axis, angle) => {
    const scalar = Math.cos(angle / 2);
    const [horizontal, vertical, depth] = axis.map(value => value * Math.sin(angle / 2));
    return [
      [1 - 2 * (vertical ** 2 + depth ** 2), 2 * (horizontal * vertical - scalar * depth), 2 * (horizontal * depth + scalar * vertical)],
      [2 * (horizontal * vertical + scalar * depth), 1 - 2 * (horizontal ** 2 + depth ** 2), 2 * (vertical * depth - scalar * horizontal)],
      [2 * (horizontal * depth - scalar * vertical), 2 * (vertical * depth + scalar * horizontal), 1 - 2 * (horizontal ** 2 + vertical ** 2)]
    ];
  };
  const apply = (matrix, vector) => matrix.map(row => row.reduce((sum, value, index) => sum + value * vector[index], 0));
  const angles = [-2 * PI, -PI - 1e-7, -PI, -PI + 1e-7, -1.2, -1e-8, -1e-14, 0, 1e-14, 1e-8, 0.7, PI - 1e-7, PI, PI + 1e-7, 2 * PI];
  const directions = [...basis, ...basis.map(axis => axis.map(value => -value)), [1, 1, 1], [1, -1, 0], [1, -2, 3], [1e-9, 0, -1], [1e-300, 2e-300, -1e-300]];
  for (let index = 0; index < 120; index++) directions.push([Math.sin(index + 0.2), Math.cos(index * 1.7), Math.sin(index * 0.71)]);
  for (const direction of directions) for (const angle of angles) {
    const axis = direction.map(value => value / Math.hypot(...direction));
    const expected = quaternionMatrix(axis, angle);
    const rotation = K.axisAngleMatrix(direction, angle);
    const construction = K.axisAngleSteps(direction, angle);
    const label = "角轴 " + direction + " " + angle;
    check(label + " 独立四元数正解", close3(rotation, expected, 1e-12));
    check(label + " 五步等于净旋转", construction.steps.length === 6 && close3(construction.steps[5].R, expected, 1e-12));
    let columns = basis;
    const sequence = [[2, -construction.alpha], [1, -construction.beta], [2, angle], [1, construction.beta], [2, construction.alpha]];
    for (let step = 1; step <= 5; step++) {
      const [axisIndex, turn] = sequence[step - 1];
      const elementary = quaternionMatrix(basis[axisIndex], turn);
      columns = columns.map(vector => apply(elementary, vector));
      const matrix = basis.map((unused, row) => columns.map(column => column[row]));
      check(label + " 第 " + step + " 步独立几何", close3(construction.steps[step].R, matrix, 1e-12));
      check(label + " 第 " + step + " 步固定轴", construction.steps[step].axis.every((value, index) => near(value, basis[axisIndex][index])));
    }
    check(label + " 对齐轴", apply(construction.steps[2].R, axis).every((value, index) => near(value, basis[2][index], 1e-12)));
    check(label + " 不变轴", apply(rotation, axis).every((value, index) => near(value, axis[index], 1e-12)));
    const inverse = K.extractAxisAngle(rotation);
    const rebuilt = inverse.axis ? K.axisAngleMatrix(inverse.axis, inverse.angle) : K.Tid().R;
    check(label + " 反解重建", close3(rebuilt, expected, 3e-12));
    check(label + " 主角范围", inverse.angle >= 0 && inverse.angle <= PI);
    check(label + " 主向量", near(Math.hypot(...inverse.vector), inverse.angle, 1e-12));
  }
  check("角轴例题 C", close3(K.axisAngleMatrix([1, 1, 1], 2 * PI / 3), [[0, 0, 1], [1, 0, 0], [0, 1, 0]]));
  check("角轴混合符号半圈", close3(K.axisAngleMatrix([1, -1, 0], PI), [[0, -1, 0], [-1, 0, 0], [0, 0, -1]]));
  for (const direction of [[0, 0, 0], [NaN, 1, 2], [Infinity, 0, 0], [1, 2], null]) {
    let rejected = false;
    try { K.axisAngleMatrix(direction, 0); } catch (error) { rejected = true; }
    check("拒绝非法轴 " + direction, rejected);
  }
  for (const invalid of [[[1, 0, 0], [0, 1, 0], [0, 0, -1]], [[2, 0, 0], [0, 1, 0], [0, 0, 1]], [[1, 0, 0], [0, 1, 0], [0, 0, NaN]], [], null]) {
    let rejected = false;
    try { K.extractAxisAngle(invalid); } catch (error) { rejected = true; }
    check("拒绝坏旋转矩阵 " + invalid, rejected);
  }
  for (const angle of [NaN, Infinity]) {
    for (const forward of [K.axisAngleMatrix, K.axisAngleSteps]) {
      let rejected = false;
      try { forward([1, 0, 0], angle); } catch (error) { rejected = true; }
      check("拒绝非有限角", rejected);
    }
  }
}

{
  const axes = [[1, 0, 0], [0, 1, 0], [0, 0, 1], [1, -1, 0], [-2, 3, -4], [1, 1, 1]];
  const pivots = new Set();
  const distance = (first, second) => Math.hypot(...first.map((value, index) => value - second[index]));
  const multiply = (first, second) => {
    const [scalar, horizontal, vertical, depth] = first;
    const [otherScalar, otherHorizontal, otherVertical, otherDepth] = second;
    return [scalar * otherScalar - horizontal * otherHorizontal - vertical * otherVertical - depth * otherDepth,
      scalar * otherHorizontal + horizontal * otherScalar + vertical * otherDepth - depth * otherVertical,
      scalar * otherVertical - horizontal * otherDepth + vertical * otherScalar + depth * otherHorizontal,
      scalar * otherDepth + horizontal * otherVertical - vertical * otherHorizontal + depth * otherScalar];
  };
  for (const axis of axes) for (const degrees of [-720, -360, -181, -180, -0.000001, 0, 0.000001, 90, 179.999999, 180, 180.000001, 270, 360, 720]) {
    const quaternion = K.quaternionFromAxis(axis, degrees * DEG);
    const matrix = K.quaternionMatrix(quaternion);
    check("四元数正解对照 Rodrigues", close3(matrix, K.axisAngleMatrix(axis, degrees * DEG)));
    check("四元数整体反号同矩阵", close3(matrix, K.quaternionMatrix(quaternion.map(value => -value))));
    const extracted = K.quaternionExtract(matrix);
    pivots.add(extracted.pivot);
    check("四元数提取重建", close3(matrix, K.quaternionMatrix(extracted.quaternion)));
    check("四元数提取只差整体符号", Math.min(distance(quaternion, extracted.quaternion), distance(quaternion.map(value => -value), extracted.quaternion)) < 1e-10);
    check("最大分量为正且不小于一半", extracted.quaternion[extracted.pivot] >= 0.5 - 1e-12);
    const inverse = K.quaternionInverse(quaternion);
    check("四元数共轭逆", distance(K.quaternionProduct(quaternion, inverse), [1, 0, 0, 0]) < 1e-12);
    const point = [1, 2, 3];
    check("独立夹乘对照点像", distance(multiply(multiply(quaternion, [0, ...point]), inverse).slice(1), K.Trot({ R: matrix }, point)) < 1e-10);
    for (const secondAxis of axes) {
      const second = K.quaternionFromAxis(secondAxis, 0.7);
      const product = K.quaternionProduct(quaternion, second);
      check("Hamilton独立展开", distance(product, multiply(quaternion, second)) < 1e-12);
      check("Hamilton乘积矩阵顺序", close3(K.quaternionMatrix(product), K.mul3(matrix, K.quaternionMatrix(second))));
    }
  }
  check("四元数四个提取主元均覆盖", pivots.size === 4);
  const exact = [[0, -1, 0], [-1, 0, 0], [0, 0, -1]];
  const stable = K.quaternionExtract(exact).quaternion;
  const candidate = K.quaternionSignCandidate(exact);
  check("精确半圈恢复混合符号", distance(stable, [0, Math.SQRT1_2, -Math.SQRT1_2, 0]) < 1e-12);
  check("精确半圈原符号法确实失败", near(Math.abs(K.quaternionMatrix(candidate)[0][1] - exact[0][1]), 2));
  for (const invalid of [null, [], [0, 0, 0, 0], [1, 0, 0], [NaN, 0, 0, 1], [Infinity, 0, 0, 0], [2, 0, 0, 0]]) {
    for (const operation of [K.quaternionMatrix, K.quaternionInverse, value => K.quaternionProduct(value, [1, 0, 0, 0])]) {
      let rejected = false;
      try { operation(invalid); } catch (error) { rejected = true; }
      check("拒绝非法单位四元数", rejected);
    }
  }
  for (const invalid of [null, [], [[1, 0, 0], [0, 1, 0], [0, 0, -1]], [[2, 0, 0], [0, 1, 0], [0, 0, 1]], [[1, 0, 0], [0, 1, 0], [0, 0, NaN]]]) {
    let rejected = false;
    try { K.quaternionExtract(invalid); } catch (error) { rejected = true; }
    check("四元数提取拒绝非法矩阵", rejected);
  }
}

{
  const identity = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
  const multiply = (first, second) => first.map(row => second[0].map((unused, column) => row.reduce((sum, value, index) => sum + value * second[index][column], 0)));
  const apply = (matrix, vector) => matrix.map(row => row.reduce((sum, value, index) => sum + value * vector[index], 0));
  const close = (first, second) => first.flat().every((value, index) => near(value, second.flat()[index], 1e-10));
  const reference = (firstAngle, secondAngle, origin, offset) => {
    const firstCosine = Math.cos(firstAngle * DEG), firstSine = Math.sin(firstAngle * DEG);
    const secondCosine = Math.cos(secondAngle * DEG), secondSine = Math.sin(secondAngle * DEG);
    return [
      [[firstCosine, -firstSine, 0, origin[0]], [firstSine, firstCosine, 0, origin[1]], [0, 0, 1, origin[2]], [0, 0, 0, 1]],
      [[1, 0, 0, offset], [0, secondCosine, -secondSine, 0], [0, secondSine, secondCosine, 0], [0, 0, 0, 1]]
    ];
  };
  for (const firstAngle of [-180, -90, 0, 45, 90, 180]) for (const secondAngle of [-180, -90, 0, 30, 90, 180]) {
    for (const origin of [[0, 0, 0], [2, 1, 0], [-3, 2, -1], [0.2, -0.5, 0.8]]) for (const offset of [-2, 0, 1]) {
      const scene = K.homogeneousSteps(firstAngle, secondAngle, origin, offset);
      const [first, second] = reference(firstAngle, secondAngle, origin, offset);
      const combined = multiply(first, second), inverse = K.Tmatrix(scene.inverse);
      check("齐次第一段独立4×4", close(K.Tmatrix(scene.first), first));
      check("齐次第二段独立4×4", close(K.Tmatrix(scene.second), second));
      check("齐次合成独立4×4", close(K.Tmatrix(scene.combined), combined));
      check("齐次逆左乘", close(multiply(inverse, combined), identity));
      check("齐次逆右乘", close(multiply(combined, inverse), identity));
      check("齐次错误顺序独立对照", close(K.Tmatrix(scene.wrong), multiply(second, first)));
      for (const [vectors, weight] of [[scene.points, 1], [scene.directions, 0]]) {
        const input = [0, 1, 0, weight];
        check("齐次第一步独立列乘", close([vectors[1].concat(weight)], [apply(second, input)]));
        check("齐次逐级与合成独立列乘", close([vectors[2].concat(weight)], [apply(combined, input)]));
        check("齐次往返保持末分量", close([apply(inverse, vectors[2].concat(weight))], [input]));
      }
      const transpose = combined[0].map((unused, column) => combined.map(row => row[column]));
      const gram = multiply(transpose, combined), translation = scene.combined.p;
      check("齐次整体正交边界", close(gram, identity) === (Math.hypot(...translation) < 1e-10));
      check("齐次Gram右下项", near(gram[3][3], 1 + translation.reduce((sum, value) => sum + value ** 2, 0)));
      const other = apply(combined, [1, 1, 0, 1]);
      check("齐次两点距离保持", near(Math.hypot(...other.slice(0, 3).map((value, index) => value - scene.points[2][index])), 1));
    }
  }
  const example = K.homogeneousSteps(90, 90, [2, 1, 0], 1);
  check("齐次两段例题点像", close([example.points[2]], [[2, 2, 1]]));
  check("齐次两段例题交换结果", close([K.Tvec(example.wrong, [0, 1, 0])], [[2, 0, 1]]));
  for (const invalid of [null, {}, { R: K.Tid().R, p: [NaN, 0, 0] }, { R: K.Tid().R, p: [1, 2] }, { R: [[1, 0, 0], [0, 1, 0], [0, 0, -1]], p: [0, 0, 0] }]) {
    for (const operation of [K.Tmatrix, K.Tinverse]) {
      let rejected = false;
      try { operation(invalid); } catch (error) { rejected = true; }
      check("拒绝非法刚体位姿", rejected);
    }
  }
  for (const input of [[NaN, 0, [0, 0, 0], 0], [0, Infinity, [0, 0, 0], 0], [0, 0, [0, 0, 0], NaN], [0, 0, [0, 0, Infinity], 0]]) {
    let rejected = false;
    try { K.homogeneousSteps(...input); } catch (error) { rejected = true; }
    check("拒绝非法齐次实验输入", rejected);
  }
}

{
  const multiply = (first, second) => first.map(row => second[0].map((unused, column) => row.reduce((sum, value, index) => sum + value * second[index][column], 0)));
  const identity = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
  const closeMatrix = (first, second) => first.every((row, rowIndex) => row.every((value, column) => near(value, second[rowIndex][column], 1e-11)));
  const reference = (alpha, length, distance, angle) => {
    const rotationZ = [[Math.cos(angle), -Math.sin(angle), 0, 0], [Math.sin(angle), Math.cos(angle), 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
    const translationZ = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, distance], [0, 0, 0, 1]];
    const translationX = [[1, 0, 0, length], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
    const rotationX = [[1, 0, 0, 0], [0, Math.cos(alpha), -Math.sin(alpha), 0], [0, Math.sin(alpha), Math.cos(alpha), 0], [0, 0, 0, 1]];
    return [rotationZ, translationZ, translationX, rotationX].reduce(multiply, identity);
  };
  const samples = [[0, 0, 0, 0], [PI, 0.3, -0.2, PI], [PI / 2, 2, 1, PI / 2], [-PI / 2, 0, 0, -PI / 2]];
  for (let index = 0; index < 180; index++) samples.push([Math.sin(index * 1.37) * PI, (index % 7) / 3, Math.cos(index * 0.67), Math.sin(index * 2.13) * PI]);
  for (const [alpha, length, distance, angle] of samples) {
    check("DH 单行与独立四因子逐项对拍", closeMatrix(K.Tmatrix(K.dhA(alpha, length, distance, angle)), reference(alpha, length, distance, angle)));
  }
  const rows = [
    { type: "R", alpha: PI / 2, a: 0.3, d: -0.2 },
    { type: "P", alpha: -PI / 2, a: 0.5, th: -PI / 2 },
    { type: "R", alpha: PI, a: 0.2, d: 0.1 }
  ];
  for (let sample = 0; sample < 60; sample++) {
    const angles = [Math.sin(sample) * PI, Math.cos(sample * 0.7), Math.sin(sample * 1.7) * PI];
    const frames = K.fkChain(rows, angles);
    let expected = identity;
    for (const [index, row] of rows.entries()) {
      expected = multiply(expected, reference(row.alpha, row.a, row.type === "P" ? angles[index] : row.d, row.type === "P" ? row.th : angles[index]));
      check("R/P 混合链每个中间系与独立四因子一致", closeMatrix(K.Tmatrix(frames[index + 1].T), expected));
    }
    for (let joint = 0; joint < rows.length; joint++) {
      const changed = angles.map((value, index) => value + (index === joint ? 0.1 : 0));
      const newFrames = K.fkChain(rows, changed);
      check("改变关节保留上游坐标系", frames.slice(0, joint + 1).every((frame, index) => closeMatrix(K.Tmatrix(frame.T), K.Tmatrix(newFrames[index].T))));
      if (rows[joint].type === "P") {
        check("移动关节保持下游朝向且沿自身轴平移", newFrames.slice(joint + 1).every((frame, index) => close3(frame.T.R, frames[joint + 1 + index].T.R) && frame.o.every((value, component) => near(value - frames[joint + 1 + index].o[component], 0.1 * frames[joint].z[component]))));
      }
    }
  }
  const mixed = K.fkChain([{ type: "R", alpha: 0, a: 1, d: 0.2 }, { type: "P", alpha: 0, a: 0.5, th: -PI / 2 }], [PI / 2, 0.3]);
  check("发布练习 R/P 混合链 T₂⁰", closeMatrix(K.Tmatrix(mixed[2].T), [[1, 0, 0, 0.5], [0, 1, 0, 1], [0, 0, 1, 0.5], [0, 0, 0, 1]]));
}

/* --- §3.3: output-space ellipsoid, area and degenerate dimensions --- */
for (const angles of [[0.2,0.4,-0.8], [1.1,0.4,-0.8], [0,0,0], [0,PI/2,0], [0,PI/2,PI]]) {
  const J = K.anthroJbar(...angles, 0.62, 0.52);
  const e = K.velocityEllipsoid(J);
  const E = J.map(row => J.map(other => row.reduce((sum,v,k) => sum+v*other[k],0)));
  e.axes.forEach((u,i) => {
    const Eu = E.map(row=>row.reduce((sum,v,k)=>sum+v*u[k],0));
    check("速度椭球主轴位于输出空间", Eu.every((v,k)=>near(v,e.sigma[i]**2*u[k],1e-9)));
  });
  check("可操作度等于奇异值乘积及行列式绝对值", near(e.w,Math.abs(K.det3(J)),1e-10) && near(e.sigma.reduce((a,b)=>a*b,1),e.w,1e-7));
}
const elbow = K.velocityEllipsoid(K.anthroJbar(0,0,0,0.62,0.52));
check("单肘奇点速度集退化为面", elbow.sigma.filter(v=>v>1e-7).length===2);
const both = K.velocityEllipsoid(K.anthroJbar(0,PI/2,0,0.62,0.52));
check("肩肘同时奇异速度集退化为线", both.sigma.filter(v=>v>1e-7).length===1);

/* --- 报告 --- */
if (failures.length === 0) {
  console.log(`check_labs3d_math: OK（${passed} 项）`);
  process.exit(0);
}
console.log(`check_labs3d_math: ${failures.length} 项失败（通过 ${passed} 项）`);
failures.forEach((f) => console.log("  - " + f));
process.exit(1);
