
# 🛠️ELP.md – Dot-Files Environment Setup Guide

> A quick-reference guide for understanding and restoring your full development environment using this repository.

---

## 📁 What Is This Repo?

This repository stores **modular dotfiles** and automation scripts that configure your personalized Linux (WSL) development environment.

It includes:
- Bash, Git, WSL, and editor configuration
- A Git template system for automatic notebook handling
- Python tooling setup (`pyenv`, `venv`, `nbstripout`, `pre-commit`)

---

Each folder is managed using [`stow`](https://www.gnu.org/software/stow/), which creates symlinks in `~` to keep your home directory clean and modular.

---

## 🚀 How to Restore This Environment (One Command)

### 1. Clone the repo:

```bash
git clone git@github.com:Drew5040/Dot-Files.git ~/Repositories/Dot-Files
cd ~/Repositories/Dot-Files
```
### 2. Run the `bootstrap.sh` script

```bash
./bootstrap.sh

```
---

This will:
- install system packages `(git, stow, build tools)`

- symlink your dotfiles to ~ using `stow`

- install and configure `pyenv + venv`

- set `Git global settings`

- set up `nbstripout` and `pre-commit` automation

After this, your environment is fully restored and ready to use.

---

### Note:

If you want pre-commit to be set up automatically, make sure a `.pre-commit-config.yaml` file exists **in the directory 
where you run `bootstrap.sh`** (usually your project repo root). If no config is found, pre-commit will be skipped 
silently.
