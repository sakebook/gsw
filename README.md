# gsw (Google Switch)

[![test](https://github.com/sakebook/gsw/actions/workflows/test.yml/badge.svg)](https://github.com/sakebook/gsw/actions/workflows/test.yml)

> Switch Google Cloud configurations instantly.

`gsw` is a lightweight Bash/Zsh plugin that makes switching between Google Cloud SDK configurations effortless. It defaults to **Session** switching (changing only for the current terminal tab), with an option for **Global** switching.

## Why gsw?

Managing multiple Google Cloud projects usually involves `gcloud config configurations activate ...`, which changes the global state. This becomes dangerous when you have multiple terminals open—running a command in one terminal might target the wrong project because you switched configs in another tab.

`gsw` solves this by offering:
1.  **Safety by Default**: `gsw <config>` limits configuration changes to only the *current shell session* (using `CLOUDSDK_ACTIVE_CONFIG_NAME`).
2.  **Global Control**: Use `gsw -g <config>` when you actually want to change the default for all terminals.
3.  **Speed**: Shorter command with tab completion saves you keystrokes.
4.  **Simplicity**: No complex setup or dependencies. Just shell functions.

## Features

- 🛡️ **Session Isolation**: `gsw <config>` switches *only* in the current terminal tab (perfect for multi-project workflows).
- ⚡ **Global Switch**: `gsw -g <config>` to switch globally when needed.
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
