#!/bin/bash
set -e

REPO_URL="https://github.com/sakebook/gsw.git"
INSTALL_DIR="$HOME/.gsw"

echo "✨ Installing gsw..."

# 1. Clone or Pull
if [ -d "$INSTALL_DIR" ]; then
  echo "   Updating existing installation in $INSTALL_DIR..."
  cd "$INSTALL_DIR" && git pull --quiet
else
  echo "   Cloning into $INSTALL_DIR..."
  git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# 2. Detect shell configuration files
SHELL_FILES=()
[ -f "$HOME/.zshrc" ] && SHELL_FILES+=("$HOME/.zshrc")
[ -f "$HOME/.bashrc" ] && SHELL_FILES+=("$HOME/.bashrc")
[ -f "$HOME/.bash_profile" ] && SHELL_FILES+=("$HOME/.bash_profile")

if [ ${#SHELL_FILES[@]} -eq 0 ]; then
  echo "⚠️  No shell configuration files (~/.zshrc, ~/.bashrc, or ~/.bash_profile) found."
  echo "   Please add 'source $INSTALL_DIR/gsw.sh' to your shell config manually."
else
  SOURCE_CMD="source $INSTALL_DIR/gsw.sh"
  for RC_FILE in "${SHELL_FILES[@]}"; do
    if grep -Fxq "$SOURCE_CMD" "$RC_FILE"; then
      echo "   Already configured in $(basename "$RC_FILE")"
    else
      echo "   Adding source command to $(basename "$RC_FILE")..."
      {
        echo ""
        echo "# gsw: Google Switch"
        echo "$SOURCE_CMD"
      } >> "$RC_FILE"
    fi
  done
fi

echo ""
echo "✅ Installation complete!"
echo "   Please restart your terminal or source your config file."
echo ""
echo "   Try it: gsw"
echo ""
