# gsw (Google Switch)

[![test](https://github.com/sakebook/gsw/actions/workflows/test.yml/badge.svg)](https://github.com/sakebook/gsw/actions/workflows/test.yml)

> Switch Google Cloud configurations instantly.

`gsw` is a lightweight Bash/Zsh plugin that makes switching between Google Cloud SDK configurations effortless. It supports both **Global** switching (changing the default for all shells) and **Local** switching (changing only for the current shell session).

## Why gsw?

Managing multiple Google Cloud projects usually involves `gcloud config configurations activate ...`, which changes the global state. This becomes dangerous when you have multiple terminals open—running a command in one terminal might target the wrong project because you switched configs in another tab.

`gsw` solves this by offering:
1.  **Safety**: `gsw-local` limits configuration changes to only the *current shell session* (using `CLOUDSDK_ACTIVE_CONFIG_NAME`).
2.  **Speed**: Shorter aliases (`gsw`, `gsw-local`) with tab completion save you keystrokes.
3.  **Simplicity**: No complex setup or dependencies. Just shell functions.

## Features

- ⚡ **Fast Switching**: `gsw <config>` to switch globally.
- 🛡️ **Local Isolation**: `gsw-local <config>` to switch *only* in the current terminal tab (perfect for multi-project workflows).
- 🧠 **Auto-Completion**: Tab completion for your existing gcloud configurations (Bash & Zsh).
- 📦 **Zero Dependencies**: Pure Shell functions.

## Demo

<!-- Check out how easy it is to switch contexts! -->
![gsw demo](demo.gif)

## Installation

### Method 1: One-Line Install (Recommended)

Run this command to install `gsw` to `~/.gsw` and update your `.zshrc` automatically:

```bash
curl -sL https://raw.githubusercontent.com/sakebook/gsw/main/install.sh | bash
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

### Plugin Managers (Zsh)

<details>
<summary>Click to expand configuration examples</summary>

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

</details>

## Usage

### Show Help
```bash
gsw --help
gsw-local --help
```

### Global Switch (`gsw`)
Changes the active configuration for **all** open terminals (that rely on the global config).

```bash
gsw my-work-profile
```

### Local Switch (`gsw-local`)
Changes the active configuration **only for the current shell session**. This sets the `CLOUDSDK_ACTIVE_CONFIG_NAME` environment variable.

```bash
gsw-local my-personal-profile
```

### List Configurations
Just run `gsw` without arguments to see available configurations and usage help.

```bash
gsw
```

## license

MIT
