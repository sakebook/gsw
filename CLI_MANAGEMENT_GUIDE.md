# CLI Environment Management Walkthrough

This guide explains how to use the new tools for managing Google Cloud accounts and environment variables.

## 1. Install the `gsw` Helper

Since the script was created in a temporary workspace, you should move it to a permanent location in your home directory.

### Recommended: `~/.zsh/functions`

1.  Create a directory for your custom functions:
    ```bash
    mkdir -p ~/.zsh/functions
    ```
2.  Move the script there:
    ```bash
    cp /Users/sakemoto/.gemini/antigravity/playground/outer-feynman/gcloud_switch.zsh ~/.zsh/functions/
    ```
3.  Load it in your `~/.zshrc`:
    Open `~/.zshrc` and add:
    ```bash
    source ~/.zsh/functions/gcloud_switch.zsh
    ```
4.  Apply changes:
    ```bash
    source ~/.zshrc
    ```

## 2. Using `gsw` (Google Switch)

The `gsw` command wraps `gcloud config configurations` to make switching contexts easy.

### List Configurations
```bash
gsw
```

### Switch Configuration (Global)
```bash
gsw [config-name]
# Example: gsw work
```
*   **Effect**: Changes the active configuration for **ALL** terminal tabs (global).

### Switch Configuration (Local Only)
```bash
gsw-local [config-name]
# Example: gsw-local personal
```
*   **Effect**: Changes the active configuration for **THIS terminal tab only**.
*   **How it works**: Sets the `CLOUDSDK_ACTIVE_CONFIG_NAME` environment variable.

### Create New Configurations
You still use standard gcloud commands to create them initially:
```bash
gcloud config configurations create work
gcloud config set account user@work.com
gcloud config set project work-project-id
```

## 3. Using `direnv` for Project Variables

Use `direnv` to automatically set environment variables when you `cd` into a project directory.

1.  **Create `.envrc`**: In your project root, create a file named `.envrc`.
2.  **Add Variables**:
    ```bash
    export GOOGLE_CLOUD_PROJECT="my-project-id"
    # export OTHER_VAR="value"
    ```
3.  **Allow**: Run `direnv allow` to trust the file.

Now, whenever you enter that directory, `GOOGLE_CLOUD_PROJECT` will be set automatically.

## Summary of Workflow

1.  **Global Context**: Use `gsw` to switch your base identity (e.g., Personal vs. Work).
2.  **Local Context**: Use `direnv` to set specific project IDs or API keys for the folder you are working in.

## 4. Portability (Dotfiles)

To easily migrate this setup to a new PC, it is recommended to manage your shell configuration with **Git**. This is commonly called "dotfiles".

1.  **Create a Repository**: Create a folder (e.g., `~/dotfiles`) and initialize git.
2.  **Move the Script**: Move `gcloud_switch.zsh` into this folder.
3.  **Symlink**: Instead of copying, create a symbolic link from `~/.zsh/functions/` to the file in your repo.
    ```bash
    ln -sf ~/dotfiles/gcloud_switch.zsh ~/.zsh/functions/gcloud_switch.zsh
    ```
4.  **Push to GitHub**: Push your `dotfiles` repo to GitHub.

**On a New PC:**
1.  Clone your dotfiles repo.
2.  Run the `ln -sf ...` command to link the script.
3.  Add the `source` line to `.zshrc`.
