# terminal-workflow 👌👌
A great starting point with the power of Portability and Windows &lt;3


# 🚀 A Portable Windows Dev Toolchain  
A fully self‑contained, zero‑install development environment for Windows.  
Drop it into any folder. Run one installer. Get a complete toolchain:

- **Neovim (nightly)**
- **Python (embed) + pip + pynvim**
- **Node.js + npm + neovim provider**
- **Git (portable)**
- **ripgrep**
- **fd**
- **Auto‑generated launchers**
- **Portable PATH activation**
- **Persistent JSON state**
- **No registry writes**
- **No system PATH pollution**
- **Fully reproducible clean installs**

This project is designed for developers who want a **portable, relocatable, zero‑conf environment** that works anywhere — USB drives, cloud folders, offline machines, restricted systems, or clean Windows installs.
This project was also designed by me! Also it was debugged and fined tuned with the help of the awesome Copilot ;-)

---

## ✨ Features

### 🔧 Fully Portable  
Everything lives inside a single root folder:

```
& Your desired directory & /
  tools/
  scripts/
  links/
  state.json
```

Move it anywhere. Put it on a USB stick. Sync it with OneDrive.  
It just works.

### ⚡ Zero System Modifications  
- No registry edits  
- No PATH changes  
- No installers  
- No admin rights required  

### 🧠 Smart State System  
A persistent `state.json` tracks tool paths and is read by all launchers.

### 🛠 Auto‑Generated Launchers  
Every tool gets a PowerShell launcher that:

- Activates the portable PATH  
- Sets XDG directories for Neovim  
- Sets Python environment variables  
- Sets Node environment variables  
- Runs the tool cleanly and consistently  

### 🧹 Clean, Reproducible Installs  
Delete the `tools/` folder and run the installer again — you get the exact same environment every time.

---

## 📦 Tools Included

| Tool      | Description |
|-----------|-------------|
| **Neovim** | Portable build with full runtime, XDG directories, and plugin support |
| **Python (embed)** | Self‑contained Python environment with pip + pynvim preinstalled |
| **Node.js** | Portable Node + npm with the Neovim Node provider installed |
| **Git (PortableGit)** | Fully portable Git distribution (no installer, no system changes) |
| **ripgrep** | High‑performance search tool used by many Neovim plugins |
| **fd** | Fast, user‑friendly alternative to `find`, used by Telescope and others |

---

## 🚀 Installation

1. Clone or download this repository.
2. Place it anywhere (e.g., `D:\ac6\`).
3. Make sure the `.\links` directory is in the same directory as the `.\install.cmd` file!

---
ac6/
│
├── install.cmd                # Main installer script (downloads + extracts + configures tools)
│
└── links/                     # Version profiles for all tools
    │
    ├── links-latest.conf      # The newest versions of every tool (time of production)
    ├── links-lts.conf         # Stable, long-term support versions
    └── links-custom.conf      # User-editable profile for custom versions
---

4. Run:

```
install.cmd
```

4. Choose a link profile (latest, LTS, or custom).
5. Wait for the installer to download and configure all tools.

That’s it.

---

### 🔧 Version Flexibility  

All tool versions are **fully customizable** through the link profiles:

```
links/
  links-latest.conf
  links-lts.conf
  links-custom.conf
```

Each profile maps tools to download URLs, allowing you to:

- Pin exact versions  
- Track nightly builds  
- Use LTS releases  
- Mix and match versions  
- Create your own custom profile  

Your installer simply reads the profile and builds the environment accordingly.

---

## 🔧 How to Customize Tool Versions

Your toolchain is fully version‑agnostic.  
Every tool — Neovim, Python, Node.js, Git, ripgrep, fd — is downloaded from URLs defined in a **link profile**.

These profiles live in:

```
links/
  links-latest.conf
  links-lts.conf
  links-custom.conf
```

Each profile is a simple `key=value` file where:

- **key** = tool name  
- **value** = download URL for that tool  

The installer reads the selected profile and builds the environment accordingly.

### ✔ Want nightly Neovim?  
Use a nightly URL.

### ✔ Want Python 3.12 instead of 3.14?  
Swap the URL.

### ✔ Want Node LTS instead of latest?  
Point to the LTS ZIP.

### ✔ Want to freeze versions for reproducibility?  
Create a custom profile.

---

## 🛠 Customizing Tool Versions

Edit the link profile:

```
links/links-latest.conf
```

Each line maps a tool to a download URL:

```
GIT=https://...
RIPGREP=https://...
FD=https://...
NODE=https://...
PYTHON=https://...
NVIM=https://...
```

You can create your own profile:

```
links/links-custom.conf
```

Then select it during installation.

## 🚀 Using a Custom Profile

When running the installer:

```
install.cmd
```

You’ll be prompted:

```
Available link profiles:
  1. links-latest.conf
  2. links-lts.conf
  3. links-custom.conf

Choose profile (1/2/3):
```

Choose **3** to use your custom versions.

## 🧪 Example: `links-custom.conf`

Here’s a clean, realistic example you can include in your repo:

```
# Custom tool versions for the portable toolchain
# You can pin exact versions or mix-and-match as needed.

GIT=https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/PortableGit-2.43.0-64-bit.7z.exe

NODE=https://nodejs.org/dist/v20.11.1/node-v20.11.1-win-x64.zip

PYTHON=https://www.python.org/ftp/python/3.12.2/python-3.12.2-embed-amd64.zip

NEOVIM=https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-win64.zip

RIPGREP=https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-pc-windows-msvc.zip

FD=https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-v9.0.0-x86_64-pc-windows-msvc.zip
```

This file is:

- Easy to read  
- Easy to edit  
- Easy to version‑control  
- Fully deterministic  

---

## 🧠 Why This System Is Powerful

- You can pin exact versions for reproducibility  
- You can track nightly builds for bleeding‑edge setups  
- You can maintain multiple profiles for different projects  
- You can share profiles with teammates  
- You can freeze your environment for years  

---

## 🧭 Usage

Launch Neovim:

```
tools\nvim.cmd
```

Launch Python:

```
tools\python.cmd
```

Launch Node:

```
tools\node.cmd
```

All tools automatically activate the portable PATH and environment.

---

## 📁 Folder Structure

Your portable toolchain is intentionally simple, predictable, and self‑contained.  
Everything lives inside a single root directory, and every component has a clear purpose.

```
ac6/
│
├── install.cmd                # One-shot installer (downloads + extracts + configures everything)
├── state.json                 # Persistent state (paths for all tools)
│
├── tools/                     # All portable tools live here
│   │
│   ├── git/
│   │   └── current/           # PortableGit extracted here
│   │
│   ├── node/
│   │   └── current/           # Node.js + npm + neovim provider
│   │
│   ├── python/
│   │   └── current/           # Python embed + pip + pynvim
│   │
│   ├── nvim/
│   │   └── current/           # Neovim portable build
│   │       ├── bin/           # nvim.exe + runtime binaries
│   │       ├── config/        # Your Neovim config (init.lua lives here)
│   │       │   └── nvim/
│   │       ├── data/          # XDG_DATA_HOME (plugins, packer, lazy.nvim, etc.)
│   │       ├── state/         # XDG_STATE_HOME (LSP logs, sessions)
│   │       └── cache/         # XDG_CACHE_HOME (treesitter, swap, undo, etc.)
│   │
│   ├── ripgrep/
│   │   └── current/           # rg.exe
│   │
│   ├── fd/
│   │   └── current/           # fd.exe
│   │
│   └── curl/ (optional)       # If you add a portable curl later
│
├── scripts/                   # Auto-generated PowerShell launchers
│   │
│   ├── state.ps1              # Reads/writes state.json
│   │
│   ├── launch-nvim.ps1        # Activates PATH + XDG + runs Neovim
│   ├── launch-python.ps1      # Activates PATH + PYTHONHOME + runs Python
│   ├── launch-node.ps1        # Activates PATH + NODE_PATH + runs Node
│   ├── launch-npm.ps1         # Activates PATH + runs npm
│   ├── launch-npx.ps1         # Activates PATH + runs npx
│   ├── launch-rg.ps1          # Activates PATH + runs ripgrep
│   └── launch-fd.ps1          # Activates PATH + runs fd
│
├── *.cmd                      # CMD wrappers for each tool (nvim.cmd, python.cmd, node.cmd, etc.)
│
└── links/                     # Version profiles for tools
    │
    ├── links-latest.conf      # Latest versions of all tools
    ├── links-lts.conf         # Long-term stable versions
    └── links-custom.conf      # User-defined versions (editable)
```

---

## 🧠 Why This Structure Works So Well

### ✔ Predictable  
Every tool has a `current/` folder.  
Every launcher knows exactly where to look.

### ✔ Portable  
Move the entire folder → everything still works.  
State.json updates paths automatically.

### ✔ Clean  
No global installs.  
No registry keys.  
No PATH pollution.

### ✔ Reproducible  
Delete `tools/` → run installer → get the exact same environment.

---

## 🧩 Configuration

Your Neovim config lives here:

```
../tools/nvim/current/config/nvim/init.lua
```

## 🧪 Health Check

Inside Neovim:

```
:checkhealth
```

You should see:

- ripgrep ✔  
- node provider ✔  
- python provider ✔  
- curl ✔  
- treesitter ✔  

Perl/Ruby warnings are normal unless you install those providers.

---

## 🛠 Customizing Tool Versions

Edit the link profile:

```
links/links-latest.conf
```

Each line maps a tool to a download URL:

```
GIT=https://...
RIPGREP=https://...
FD=https://...
NODE=https://...
PYTHON=https://...
NVIM=https://...
```

You can create your own profile:

```
links/links-custom.conf
```

Then select it during installation.

---

## 🧱 Architecture Overview

### Installer  
- Downloads tools using `curl`
- Extracts archives using `tar`
- Flattens directory structures
- Writes `state.json`
- Generates PowerShell launchers
- Creates CMD wrappers

### Launchers  
- Load `state.ps1`
- Build PATH using array‑join (preserves system PATH)
- Set environment variables
- Run the tool

### State System  
`state.json` stores:

```json
{
  "nodePath": "D:\\ac6\\tools\\node\\current",
  "pythonPath": "D:\\ac6\\tools\\python\\current",
  "nvimPath": "D:\\ac6\\tools\\nvim\\current",
  "rgPath": "D:\\ac6\\tools\\ripgrep\\current",
  "fdPath": "D:\\ac6\\tools\\fd\\current",
  "gitPath": "D:\\ac6\\tools\\git\\current\\cmd"
}
```

---

## 🧹 Uninstall

Just delete the folder.

No registry keys.  
No PATH pollution.  
No system changes.

---

## 🏁 Roadmap

- Portable LSP servers  
- Portable Treesitter parser installer  
- Portable plugin manager  
- Auto‑update script  
- GUI launcher  
- Optional curl bundle  

---

## 🌍 Why Portable?

Modern development environments are powerful — but they’re also fragile. They depend on system PATH, registry entries, installers, admin rights, and a dozen assumptions about the machine they’re running on. One broken dependency or one conflicting version can ruin everything.

A **portable toolchain** solves all of that.

### 🔒 1. Zero System Impact  
This toolchain never touches:

- system PATH  
- registry keys  
- Program Files  
- AppData  
- global Python/Node installations  

Everything stays inside one folder.  
Delete the folder → everything is gone.  
No leftovers. No pollution. No surprises.

### 🚀 2. Works Anywhere  
Because it’s self‑contained, you can run it on:

- clean Windows installs  
- locked‑down corporate machines  
- university lab PCs  
- cloud VMs  
- USB drives  
- offline environments  
- machines without admin rights  

If the folder exists, the toolchain works.

### 🔁 3. Fully Reproducible  
A clean install always produces the exact same environment:

- same versions  
- same folder structure  
- same launchers  
- same PATH  
- same behavior  

No “it works on my machine.”  
Your environment becomes deterministic.

### 🧳 4. Move It, Sync It, Back It Up  
You can:

- move the folder  
- rename it  
- zip it  
- sync it with OneDrive/Dropbox  
- clone it to another machine  

Everything still works because paths are stored in `state.json` and launchers activate the environment dynamically.

### 🛠 5. No Conflicts, No Collisions  
Portable tools never conflict with:

- system Python  
- system Node  
- system Git  
- system Neovim  
- system PATH  

Your environment is isolated and predictable.

### 🧩 6. Perfect for Plugin‑Heavy Neovim  
Neovim plugins depend on:

- ripgrep  
- fd  
- Python + pynvim  
- Node.js + neovim provider  

A portable toolchain guarantees all of these exist and work together, no matter what the host machine has installed.

### 🧘 7. Peace of Mind  
You always know:

- where your tools live  
- what versions you’re using  
- what PATH is active  
- what Neovim sees  
- what Python sees  
- what Node sees  

No hidden state. No global conflicts. No mystery errors.

---

## ❤️ Credits

Built by Ali — a developer obsessed with clean, portable, reproducible workflows.  
Designed with care, iteration, and a relentless pursuit of reliability. (Thanks Copilot (●'◡'●)❤️)

---
