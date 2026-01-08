# gsw (Google Switch)

[![Tests](https://github.com/sakebook/gsw/actions/workflows/test.yml/badge.svg)](https://github.com/sakebook/gsw/actions/workflows/test.yml)

> Switch Google Cloud configurations instantly.

`gsw` is a lightweight Bash/Zsh plugin that makes switching between Google Cloud SDK configurations effortless. It defaults to **Session** switching (changing only for the current terminal tab), with an option for **Global** switching.

## Why gsw?

Managing multiple Google Cloud projects usually involves `gcloud config configurations activate ...`, which changes the global state. This becomes dangerous when you have multiple terminals open—running a command in one terminal might target the wrong project because you switched configs in another tab.

### Comparison

| Feature | `gsw` | `gcloud activate` | `direnv` |
| :--- | :--- | :--- | :--- |
| **Scope** | Session (Current tab) | Global (All tabs) | Directory-based |
| **Switching** | Ad-hoc (Anywhere) | Ad-hoc (Anywhere) | Automatic (On `cd`) |
| **Safety** | High (Isolated) | Low (Side effects) | High (Context-aware) |
| **Setup** | Zero | Zero | Needs `.envrc` files |

### How it works

`gsw` is a clean wrapper around the `CLOUDSDK_ACTIVE_CONFIG_NAME` environment variable. When you run `gsw <config>`, it exports this variable to your current shell session. Since the Google Cloud SDK honors this variable over the global configuration, you get instant, safe isolation without any complex magic.

## Features

- 🛡️ **Session Isolation**: `gsw <config>` switches *only* in the current terminal tab (perfect for multi-project workflows).
- ⚡ **Global Switch**: `gsw -g <config>` to switch globally when needed.
- 🧠 **Auto-Completion**: Tab completion for your existing gcloud configurations (Bash & Zsh).
- 📦 **Zero Dependencies**: Pure Shell functions.

## Demo

<!-- Check out how easy it is to switch contexts! -->
![gsw demo](demo.gif)

## Installation

`gsw` is just a shell script. Choose the method that fits your workflow.

### Method 1: Zsh Plugin Managers

If you use a plugin manager, this is the cleanest way to keep `gsw` updated.

**zplug:**
```zsh
zplug "sakebook/gsw", use:gsw.sh
```

**sheldon:**
```toml
[plugins.gsw]
github = "sakebook/gsw"
use = ["gsw.sh"]
```

### Method 2: Manual Install

1.  Clone the repo:
    ```bash
    git clone https://github.com/sakebook/gsw.git ~/.gsw
    ```
2.  Add this to your `~/.zshrc` (or `~/.bashrc`):
    ```bash
    source ~/.gsw/gsw.sh
    ```

### Method 3: One-Line Install (Fastest)

Run this command to install `gsw` to `~/.gsw` and update your `.zshrc` automatically:

```bash
curl -sL https://raw.githubusercontent.com/sakebook/gsw/main/install.sh | bash
```

## Usage

### Session Switch (Default)
Changes the active configuration **only for the current shell session**. This sets the `CLOUDSDK_ACTIVE_CONFIG_NAME` environment variable.

```bash
gsw my-work-profile
```

### Global Switch (`-g`)
Changes the active configuration for **all** open terminals.

```bash
gsw -g my-personal-profile
```

### List Configurations
Just run `gsw` without arguments to see available configurations and usage help.

```bash
gsw
```

## license

MIT
