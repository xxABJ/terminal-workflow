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

| Tool | Version | Notes |
|------|---------|-------|
| Neovim | Nightly | Portable build |
| Python | 3.14 embed | pip + pynvim installed |
| Node.js | Latest | npm + neovim provider |
| Git | PortableGit | No installer needed |
| ripgrep | Latest | Required for Telescope |
| fd | Latest | Fast file search |

---

## 🚀 Installation

1. Clone or download this repository.
2. Place it anywhere (e.g., `D:\ac6\`).
3. Run:

```
install.cmd
```

4. Choose a link profile (latest, LTS, or custom).
5. Wait for the installer to download and configure all tools.

That’s it.

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

```
&Your desired Directory&/
  install.cmd
  state.json
  tools/
    git/
    node/
    python/
    nvim/
    ripgrep/
    fd/
  scripts/
    launch-nvim.ps1
    launch-python.ps1
    launch-node.ps1
    ...
  links/
    links-latest.conf
    links-lts.conf
    links-custom.conf
```

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
