# 实验环境

本书的实验分三层：**用户态**（命令行、Shell、系统编程）、**内核态**（编译/调试内核）、**网络与容器**（namespace、veth、eBPF）。三层对环境的权限要求不同，下面给出四种可选方案。

## 1. 四种环境

| 方案 | 适合 | 优点 | 限制 |
|:--|:--|:--|:--|
| **A. Ubuntu 24.04 虚拟机** | 全部实验 | 可快照、可改内核、可跑 QEMU | 需要 8 GB+ 内存、20 GB 磁盘 |
| **B. 云主机** | 全部实验 | 不占本机资源、可多机组网 | 需要网络与费用；嵌套虚拟化可能受限 |
| **C. Docker 容器** | 用户态 + 网络 | 启动快、可复现 | 内核实验受限；部分 syscall 需 `--privileged` |
| **D. WSL2** | 用户态 + 部分内核 | Windows 上最方便 | 内核由微软提供，不能随意替换 |

> **推荐**：A 为主，C 为辅。日常练习用容器，内核/网络实验用虚拟机快照。macOS 用户不要试图在宿主机上跑 Linux 系统调用实验；本书的 `epoll`、`namespace`、`cgroup` 示例在 macOS 上不可用。

## 2. 方案 A：Ubuntu 虚拟机

### 2.1 创建

- 虚拟化软件：UTM（Apple Silicon）、VMware Fusion、VirtualBox、KVM/libvirt 均可；
- 镜像：Ubuntu Server 24.04 LTS（不要选最小化安装，保留 `build-essential`）；
- 规格：4 vCPU、8 GB 内存、40 GB 磁盘（内核实验建议 60 GB）；
- 网络：NAT 即可；做 veth/bridge 实验时再加一块 host-only 网卡。

### 2.2 首次配置

```bash
sudo apt update && sudo apt -y upgrade
sudo apt -y install build-essential gcc g++ make cmake pkg-config \
  linux-headers-$(uname -r) linux-tools-common linux-tools-$(uname -r) \
  git curl wget vim tmux htop strace ltrace gdb lsof \
  man-db manpages-dev manpages-posix-dev \
  iproute2 iputils-ping net-tools tcpdump socat ncdu tree \
  python3 python3-pip python3-venv \
  fio sysstat iotop stress-ng \
  qemu-system-x86 qemu-utils \
  docker.io docker-compose-v2
sudo usermod -aG docker "$USER"   # 重新登录生效
```

### 2.3 验证

```bash
uname -r                 # 6.8.x
gcc --version | head -1  # gcc 13.x
ldd --version | head -1  # glibc 2.39
docker run --rm hello-world
sudo bpftool version 2>/dev/null || echo "bpftool 未装（第 3 篇再装）"
```

预期：

```text
6.8.0-xx-generic
gcc (Ubuntu 13.2.0-23ubuntu4) 13.2.0
ldd (Ubuntu GLIBC 2.39-0ubuntu8) 2.39
Hello from Docker!
```

### 2.4 快照

每篇开始前打一个快照：

```bash
# libvirt
sudo virsh snapshot-create-as ubuntu clean-before-part3 "before kernel labs"
# UTM / VMware：用图形界面「快照」
```

内核实验会把系统搞崩，**没有快照不要开始**。

## 3. 方案 B：云主机

- 规格：2 vCPU / 4 GB 起；内核实验选支持嵌套虚拟化的实例；
- 安全组：只开 22；需要访问服务时用 SSH 隧道，不要把 8080 暴露到公网；
- 多机网络实验：同一 VPC 内开 2–3 台，记下内网 IP；
- 成本控制：不用时关机；用 `terraform` 或厂商 CLI 固化环境。

## 4. 方案 C：Docker 容器

### 4.1 用户态实验

```bash
docker run -it --rm -v "$PWD":/work -w /work ubuntu:24.04 bash
```

容器内装工具：

```bash
apt update && apt -y install build-essential strace gdb man-db iproute2 tcpdump
```

### 4.2 需要特权的实验

namespace、mount、部分 `sysctl` 需要：

```bash
docker run -it --rm --privileged --pid=host --network=host \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw ubuntu:24.04 bash
```

> `--privileged` 等于把宿主机的大部分能力交给容器，**只在你自己的机器上用**。生产环境用最小 cap 集合。

### 4.3 不建议用容器做的实验

- 编译/替换内核；
- 修改宿主 `net.core.*` 并观察全局影响；
- 需要真实网卡 DMA/中断的实验（容器里看到的是虚拟设备）；
- `perf` 的部分硬件事件（受 `perf_event_paranoid` 限制）。

## 5. 方案 D：WSL2

```powershell
wsl --install -d Ubuntu-24.04
```

WSL2 的内核由微软提供，不能替换；但用户态系统编程、网络、容器（Docker Desktop）都能做。内核源码阅读可以，编译运行不建议。

## 6. 内核实验环境

第 3 篇需要一个能编译、启动、调试内核的环境。推荐 **QEMU + BusyBox**，不污染宿主。

### 6.1 依赖

```bash
sudo apt -y install build-essential libncurses-dev bison flex libssl-dev \
  libelf-dev bc qemu-system-x86 qemu-utils cpio
```

### 6.2 下载与编译

```bash
mkdir -p ~/lab/linux && cd ~/lab/linux
curl -LO https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.8.tar.xz
tar xf linux-6.8.tar.xz && cd linux-6.8
make defconfig
# 打开调试信息与 QEMU 常用驱动
scripts/config --enable DEBUG_INFO --enable GDB_SCRIPTS \
  --enable DEBUG_KERNEL --enable KASAN --enable VIRTIO_PCI \
  --enable VIRTIO_BLK --enable VIRTIO_NET --enable EXT4_FS
make -j"$(nproc)"
```

产物：`arch/x86/boot/bzImage`。

### 6.3 根文件系统

```bash
mkdir -p ~/lab/rootfs/{bin,sbin,etc,proc,sys,dev,tmp}
cd ~/lab
curl -LO https://busybox.net/downloads/busybox-1.36.1.tar.bz2
tar xf busybox-1.36.1.tar.bz2 && cd busybox-1.36.1
make defconfig && sed -i 's/^# CONFIG_STATIC.*/CONFIG_STATIC=y/' .config
make -j"$(nproc)" && make CONFIG_PREFIX=~/lab/rootfs install
cd ~/lab/rootfs
ln -s bin/busybox init
cat > etc/inittab <<'EOF'
::sysinit:/bin/mount -t proc proc /proc
::sysinit:/bin/mount -t sysfs sysfs /sys
::sysinit:/bin/sh
EOF
find . | cpio -o -H newc | gzip > ../rootfs.cpio.gz
```

### 6.4 启动

```bash
qemu-system-x86_64 -kernel ~/lab/linux/linux-6.8/arch/x86/boot/bzImage \
  -initrd ~/lab/rootfs.cpio.gz -append "console=ttyS0 nokaslr" \
  -nographic -m 2G -smp 2
```

退出：`Ctrl-A` 然后 `X`。

### 6.5 调试

终端 1：

```bash
qemu-system-x86_64 ... -s -S
```

终端 2：

```bash
gdb ~/lab/linux/linux-6.8/vmlinux
(gdb) target remote :1234
(gdb) hbreak start_kernel
(gdb) c
```

### 6.6 内核模块

```bash
make -C /lib/modules/$(uname -r)/build M=$PWD modules
sudo insmod hello.ko
sudo dmesg | tail
sudo rmmod hello
```

在 QEMU 里做模块实验需要把 `.ko` 放进 initramfs，或使用 9p/virtio 共享目录；第 3 篇会给出完整脚本。

## 7. 网络与容器实验

### 7.1 网络命名空间

```bash
sudo ip netns add ns1
sudo ip netns add ns2
sudo ip link add veth1 type veth peer name veth2
sudo ip link set veth1 netns ns1
sudo ip link set veth2 netns ns2
sudo ip netns exec ns1 ip addr add 10.0.0.1/24 dev veth1
sudo ip netns exec ns2 ip addr add 10.0.0.2/24 dev veth2
sudo ip netns exec ns1 ip link set veth1 up
sudo ip netns exec ns2 ip link set veth2 up
sudo ip netns exec ns1 ping -c1 10.0.0.2
```

清理：

```bash
sudo ip netns del ns1; sudo ip netns del ns2
```

### 7.2 eBPF

```bash
sudo apt -y install bpftrace bpftool linux-tools-common
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s %s\n", comm, str(args->filename)); }'
```

若报 `Operation not permitted`，检查：

```bash
sysctl kernel.unprivileged_bpf_disabled
sudo sysctl -w kernel.perf_event_paranoid=1
```

### 7.3 容器

```bash
docker run --rm -it --name lab ubuntu:24.04 bash
docker stats
docker inspect lab | jq '.[0].State'
```

## 8. 工具清单

| 类别 | 工具 | 用途 |
|:--|:--|:--|
| 编译 | gcc, clang, make, cmake, pkg-config | 构建与依赖 |
| 调试 | gdb, lldb, valgrind, strace, ltrace | 用户态排错 |
| 观测 | perf, bpftrace, bpftool, ftrace, sar, iostat, vmstat | 性能与内核 |
| 网络 | ip, ss, tcpdump, tshark, socat, nc, curl | 协议与连接 |
| 文件 | lsof, stat, file, du, ncdu, tree | 文件与磁盘 |
| 容器 | docker, ctr, runc, nsenter, unshare | 隔离与运行时 |
| 版本 | git, diff, patch | 源码与实验记录 |

## 9. 环境自检脚本

把下面存成 `check-env.sh`，每次换环境跑一遍：

```bash
#!/usr/bin/env bash
set -u
ok=0; bad=0
chk() { if eval "$2" >/dev/null 2>&1; then echo "  OK   $1"; ok=$((ok+1)); else echo "  MISS $1"; bad=$((bad+1)); fi; }
echo "== 基础 =="
chk "gcc"        "command -v gcc"
chk "make"       "command -v make"
chk "gdb"        "command -v gdb"
chk "strace"     "command -v strace"
chk "perf"       "command -v perf"
chk "bpftrace"   "command -v bpftrace"
chk "docker"     "command -v docker"
chk "ip"         "command -v ip"
chk "ss"         "command -v ss"
chk "tcpdump"    "command -v tcpdump"
echo "== 版本 =="
uname -r; gcc --version | head -1; ldd --version | head -1
echo "== 权限 =="
[ "$(id -u)" -eq 0 ] && echo "  root" || echo "  普通用户（推荐）"
echo "通过 $ok 项，缺失 $bad 项"
```

## 10. 常见问题

| 现象 | 原因 | 处理 |
|:--|:--|:--|
| `perf` 报 `perf_event_paranoid` | 内核限制 | `sudo sysctl -w kernel.perf_event_paranoid=1` |
| `bpftrace` 报 `Unable to find kernel headers` | 未装 headers | 装 `linux-headers-$(uname -r)` |
| Docker 权限拒绝 | 用户不在 docker 组 | `sudo usermod -aG docker $USER` 后重新登录 |
| QEMU 启动无输出 | 控制台不是 ttyS0 | 加 `console=ttyS0` |
| 内核编译 OOM | `-j` 太大 | 降为 `-j$(nproc/2)` 或加 swap |
| `mount --bind` 在容器里失败 | 缺 `CAP_SYS_ADMIN` | 用 `--privileged` 或换虚拟机 |

> **下一站**：[入学诊断](entry-test.md)用 24 道题判断你该从哪条路线开始。
