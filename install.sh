#!/bin/bash
set -e

REPO_URL="https://github.com/sakebook/gsw.git"
INSTALL_DIR="$HOME/.gsw"
ZSHRC="$HOME/.zshrc"

echo "✨ Installing gsw..."

# 1. Clone or Pull
if [ -d "$INSTALL_DIR" ]; then
  echo "   Updating existing installation in $INSTALL_DIR..."
  cd "$INSTALL_DIR" && git pull --quiet
else
  echo "   Cloning into $INSTALL_DIR..."
  git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# 2. Add to .zshrc
SOURCE_CMD="source $INSTALL_DIR/gsw.plugin.zsh"

if grep -Fxq "$SOURCE_CMD" "$ZSHRC"; then
  echo "   Already configured in $ZSHRC"
else
  echo "   Adding source command to $ZSHRC..."
  echo "" >> "$ZSHRC"
  echo "# gsw: Google Switch" >> "$ZSHRC"
  echo "$SOURCE_CMD" >> "$ZSHRC"
fi

echo ""
echo "✅ Installation complete!"
echo "   Please restart your terminal or run: source ~/.zshrc"
echo ""
echo "   Try it: gsw"
echo ""
