# Reverse Engineering Suite for AI Coding Agents 🔍⚡
# مجموعه جامع مهندسی معکوس برای ایجنت‌های هوش مصنوعی

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![Platform: Windows | macOS | Linux](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-brightgreen.svg?style=for-the-badge)](#)
[![Support: Antigravity | Claude Code | Cursor | Codex](https://img.shields.io/badge/Agents-Antigravity%20%7C%20Claude%20Code%20%7C%20Cursor%20%7C%20Codex-purple.svg?style=for-the-badge)](#)

[English](#english) • [فارسی](#persian)

</div>

---

<a name="english"></a>
## 🌐 English

The **Reverse Engineering Suite** unites four complementary, best-in-class reverse engineering frameworks and tools into a single, cohesive ecosystem for AI coding agents (Antigravity, Claude Code, Cursor, Codex, OpenCode).

Whether you need to reverse engineer undocumented web APIs, clone application UX/architecture (Clean-Room style), dissect native binary files, or inspect Electron bundles, this suite delivers full-spectrum capabilities with a one-command setup.

### 🧩 Included Frameworks & Tools

| Component | Target Layer | Primary Role |
| :--- | :--- | :--- |
| **`reverse-api-engineer`** | Web & Network | Autonomous HAR traffic capture, endpoint extraction, and typed API client code generation. |
| **`replica-skill`** | Product & Architecture | An 11-stage autonomous agent pipeline to map flows, recreate design systems, build backends, and clone apps clean-room style. |
| **`craft-anything`** | Native Binary & Games | High-speed Rust-based inspection engine with visual parity verification (Diff) for sites, desktop software, APKs, and games. |
| **`rea` (Reverse Engineer Anything)** | Deep Decompilation | 200+ MCP tools for inspecting native Windows binaries (`.exe`/`.dll`), Electron apps, .NET assemblies, and Ghidra integration. |
| **NSA Ghidra + OpenJDK 21** | Machine Code | NSA's industry-standard open-source decompiler & disassembler suite pre-configured for automated agent calls. |

---

### 🚀 One-Command Installation

#### Windows (PowerShell)
Run PowerShell as Administrator or standard user and execute:
```powershell
irm https://raw.githubusercontent.com/javadhamed/reverse-engineering-suite/main/install.ps1 | iex
```
*Or clone the repo and run `install.cmd` / `install.ps1`.*

#### Linux / macOS (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/javadhamed/reverse-engineering-suite/main/install.sh | bash
```

---

<a name="persian"></a>
## 🇮🇷 فارسی

**مجموعه مهندسی معکوس (Reverse Engineering Suite)** ترکیبی یکپارچه، قدرتمند و هماهنگ از ۴ فریم‌ورک مطرح مهندسی معکوس برای ایجنت‌های هوش مصنوعی (مانند Antigravity، Claude Code، Cursor و Codex) است.

با استفاده از این مجموعه، تمام ابزارهای مورد نیاز برای استخراج API از وب‌سایت‌ها، کالبدشکافی رابط کاربری و معماری، دیکامپایل باینری‌ها و برنامه‌های دسکتاپ تنها با یک دستور نصب و فعال می‌شوند.

### 🧩 ابزارهای موجود در این پکیج

| ابزار | لایه هدف | کاربرد اصلی |
| :--- | :--- | :--- |
| **`reverse-api-engineer`** | ترافیک وب و شبکه | ضبط خودکار ترافیک، شناسایی اندپوینت‌ها و ساخت خودکار کلاینت API تایپ‌شده (Python, TS, Go...). |
| **`replica-skill`** | محصول و معماری | پایپ‌لاین ۱۱ مرحله‌ای برای بازآفرینی تمیز (Clean-Room) اپلیکیشن‌ها، استخراج سیستم طراحی و پایگاه داده. |
| **`craft-anything`** | باینری نیتیو و بازی | موتور بازرسی سریع با Rust، تحلیل فایل‌های فشرده و مقایسه بصری شباهت محصول (Diff Engine). |
| **`rea` + NSA Ghidra** | دیکامپایل باینری و دسکتاپ | بیش از ۲۰۰ ابزار MCP جهت مهندسی معکوس فایل‌های اجرایی (`.exe`), الکترون، دات‌نت و تبدیل به سودوکد. |

---

### ⭐ Support the Project / حمایت از پروژه

If you find this suite useful for your AI agent workflows, please consider giving it a **Star (⭐)** on GitHub to support its development!

اگر این مجموعه برای پروژه‌ها و ایجنت‌های شما مفید بود، لطفاً با ثبت یک **ستاره (⭐)** در گیت‌هاب از توسعه این ابزار حمایت کنید!
