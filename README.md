# gsw (Google Switch)

> Switch Google Cloud configurations as easily as valid 

`gsw` is a lightweight Bash/Zsh plugin that makes switching between Google Cloud SDK configurations effortless. It supports both **Global** switching (changing the default for all shells) and **Local** switching (changing only for the current shell session).

## Features

- ⚡ **Fast Switching**: `gsw <config>` to switch globally.
- 🛡️ **Local Isolation**: `gsw-local <config>` to switch *only* in the current terminal tab (perfect for multi-project workflows).
- 🧠 **Auto-Completion**: Tab completion for your existing gcloud configurations (Bash & Zsh).
- 📦 **Zero Dependencies**: Pure Shell functions.

## Installation

### Method 1: One-Line Install (Recommended)

Run this command to install `gsw` to `~/.gsw` and update your `.zshrc` automatically:

```bash
curl -sL https://raw.githubusercontent.com/sakebook/gsw/main/install.sh | bash
```

### Method 2: Plugin Managers

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

**antigen:**
```zsh
antigen bundle sakebook/gsw
```

**Oh My Zsh (Custom)**:
Clone into custom plugins:
```bash
git clone https://github.com/sakebook/gsw.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/gsw
```
Then add `gsw` to your plugins list in `~/.zshrc`.

### Method 3: Manual

1.  Clone the repo:
    ```bash
    git clone https://github.com/sakebook/gsw.git ~/.gsw
    ```
2.  Add this to your `~/.zshrc` (or `~/.bashrc`):
    ```bash
    source ~/.gsw/gsw.sh
    ```

## Usage

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
