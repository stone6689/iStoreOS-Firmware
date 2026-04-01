# iStoreOS Firmware — GitHub Actions Auto-Build

This repository automatically compiles **iStoreOS** firmware for **x86_64** and **arm64**
using GitHub Actions, then publishes the binaries as GitHub Releases.

> **重要说明 / Important**
> 本仓库不对官方固件做任何修改，编译结果与官方保持完全一致。
> No modifications are made to the official iStoreOS source code.

---

## 固件来源 / Source

| Item | Detail |
|------|--------|
| 官方仓库 / Official repo | [istoreos/istoreos](https://github.com/istoreos/istoreos) |
| 活跃分支 / Active branch | `istoreos-24.10` |

---

## 支持的目标平台 / Supported Targets

| Target | 说明 |
|--------|------|
| `x86_64` | PC 及虚拟机（BIOS / EFI） |
| `arm64`  | 通用 AArch64 / armvirt 64-bit |

---

## 如何触发编译 / How to Trigger a Build

### 手动触发 / Manual trigger
1. 进入仓库 → **Actions** → **Build iStoreOS Firmware**
2. 点击 **Run workflow**
3. 选择目标平台：`all`（默认）、`x86_64` 或 `arm64`
4. 点击 **Run workflow** 按钮

> 编译仅通过手动触发，避免不必要的资源消耗。

---

## 仓库结构 / Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── build.yml          # 主 Actions workflow
├── configs/
│   ├── x86_64.config          # x86_64 目标配置（seed config）
│   └── arm64.config           # arm64 目标配置（seed config）
├── scripts/
│   ├── install-deps.sh        # 安装编译依赖
│   └── setup-feeds.sh         # 更新并安装 feeds
└── README.md
```

---

## 编译步骤说明 / Build Steps

以下步骤严格按照 [iStoreOS 官方编译文档](https://github.com/istoreos/istoreos/blob/istoreos-24.10/README.md) 执行：

1. 安装编译依赖（`binutils`, `gcc`, `make`, `python3`, `rsync` 等）
2. 克隆官方源码仓库（`istoreos-24.10` 分支，shallow clone）
3. `./scripts/feeds update -a`
4. `./scripts/feeds install -a`
5. 复制 seed config → `make defconfig` 展开完整配置
6. `make download` 预下载所有源码包
7. `make -j$(nproc) V=s` 编译固件
8. 收集 `bin/targets/` 下的 `.img.gz` / `.img` / `.bin` 文件
9. 上传至 GitHub Release

---

## 获取固件 / Download Firmware

前往 **[Releases](../../releases)** 页面下载最新编译好的固件。

---

## 许可证 / License

本仓库的构建脚本及 workflow 文件以 [MIT License](LICENSE) 发布。

iStoreOS 本身遵循其官方开源协议，详见 [iStoreOS 仓库](https://github.com/istoreos/istoreos)。
