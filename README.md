# iStoreOS Firmware — GitHub Actions Auto-Build

通过 GitHub Actions 自动编译 **iStoreOS** 固件，支持 **x86_64** 和 **arm64** 两个平台，编译完成后自动发布到 GitHub Releases。

---

## 固件版本说明

本仓库提供两个版本的固件，对应两个独立的 Actions workflow：

| 版本 | Workflow 名称 | 说明 |
|------|--------------|------|
| **官方原版** | `Build iStoreOS Firmware` | 与官方完全一致，不添加任何额外功能 |
| **插件版** | `Build iStoreOS Firmware (with Plugins)` | 在官方基础上加入 OpenClash + PassWall 及所有依赖 |

---

## 固件来源 / Source

| 项目 | 仓库地址 | 说明 |
|------|---------|------|
| iStoreOS | [istoreos/istoreos](https://github.com/istoreos/istoreos) 分支 `istoreos-24.10` | 官方源码 |
| OpenClash | [vernesong/OpenClash](https://github.com/vernesong/OpenClash) | OpenClash 插件 |
| Clash Meta (mihomo) | [MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo) | OpenClash 内核，自动取最新版 |
| PassWall | [Openwrt-Passwall/openwrt-passwall](https://github.com/Openwrt-Passwall/openwrt-passwall) | PassWall LuCI 应用 |
| PassWall 依赖包 | [Openwrt-Passwall/openwrt-passwall-packages](https://github.com/Openwrt-Passwall/openwrt-passwall-packages) | xray-core、sing-box 等代理核心 |

---

## 支持的目标平台

| Target | 说明 |
|--------|------|
| `x86_64` | PC / 虚拟机（BIOS + EFI） |
| `arm64`  | 通用 AArch64 / armvirt 64-bit |

---

## 如何触发编译

> 编译仅支持手动触发，避免不必要的资源消耗。

1. 进入仓库 → **Actions**
2. 左侧选择需要的 workflow：
   - **Build iStoreOS Firmware** — 官方原版
   - **Build iStoreOS Firmware (with Plugins)** — 含 OpenClash + PassWall
3. 点击 **Run workflow**
4. 选择目标平台：`all`（默认）、`x86_64` 或 `arm64`
5. 点击 **Run workflow** 按钮

编译完成后固件会自动发布到 **[Releases](../../releases)** 页面。

---

## 仓库结构

```
.
├── .github/
│   └── workflows/
│       ├── build.yml              # 官方原版 workflow
│       └── build-plugins.yml      # 插件版 workflow
├── configs/
│   ├── x86_64.config              # 官方原版 x86_64 配置
│   ├── arm64.config               # 官方原版 arm64 配置
│   ├── x86_64-plugins.config      # 插件版 x86_64 配置
│   └── arm64-plugins.config       # 插件版 arm64 配置
├── scripts/
│   ├── install-deps.sh            # 安装编译依赖
│   ├── setup-feeds.sh             # 更新并安装 feeds
│   └── inject-plugins.sh          # 注入 OpenClash / PassWall / mihomo 内核
└── README.md
```

---

## 插件版包含的组件

| 组件 | 来源 | 说明 |
|------|------|------|
| luci-app-openclash | vernesong/OpenClash | OpenClash 界面 |
| clash_meta (mihomo) | MetaCubeX/mihomo | 预置于 `/etc/openclash/core/clash_meta` |
| luci-app-passwall | Openwrt-Passwall/openwrt-passwall | PassWall 界面 |
| xray-core | Openwrt-Passwall/openwrt-passwall-packages | VMess / VLESS / Trojan 等协议核心 |
| sing-box | 同上 | 现代多协议代理核心 |
| hysteria | 同上 | QUIC 高性能代理 |
| naiveproxy | 同上 | 基于 Chrome 网络栈的抗检测代理 |
| shadowsocks-rust | 同上 | Shadowsocks Rust 实现 |
| shadowsocks-libev | 同上 | Shadowsocks C 实现 |
| shadowsocksr-libev | 同上 | ShadowsocksR 客户端 |
| tuic-client | 同上 | QUIC 协议代理 |
| trojan-plus | 同上 | Trojan 增强版 |
| chinadns-ng | 同上 | 国内/海外分流 DNS |
| geoview | 同上 | Sing-box 路由分流必需（1.12+ 版本要求） |
| v2ray-geoip / v2ray-geosite | 同上 | Xray/PassWall 路由规则数据库 |
| v2ray-plugin / xray-plugin / shadow-tls / simple-obfs | 同上 | 混淆传输插件 |
| dnsmasq-full | OpenWrt 官方 | PassWall DNS 过滤必需 |

---

## 许可证

本仓库构建脚本及 workflow 以 [MIT License](LICENSE) 发布。

各第三方组件遵循其各自的开源协议。
