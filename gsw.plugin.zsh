#!/bin/zsh

# gsw: Google Switch
# Easily switch between gcloud configurations
function gsw() {
  if [ -z "$1" ]; then
    echo "Available gcloud configurations:"
    gcloud config configurations list
    echo ""
    echo "Usage: gsw <config_name>"
    echo "  Switches the GLOBAL active configuration."
    echo ""
    echo "💡 Tip: To switch automatically when entering a directory,"
    echo "       add this to your .envrc file:"
    echo "       export CLOUDSDK_ACTIVE_CONFIG_NAME=\"<config_name>\""
    return
  fi

  # Check if the configuration exists
  if ! gcloud config configurations describe "$1" > /dev/null 2>&1; then
    echo "Error: Configuration '$1' does not exist."
    echo "Available configurations:"
    gcloud config configurations list
    return 1
  fi
  
  gcloud config configurations activate "$1"
  echo "✅ Switched to configuration: $1"
  
  # Optional: Show current active account and project for confirmation
  echo "Current Identity:"
  gcloud config list --format="value(core.account,core.project)" | tr '\t' '\n' | sed 's/^/- /'
}

# gsw-local: Switch ONLY in the current shell
# Uses environment variable CLOUDSDK_ACTIVE_CONFIG_NAME
function gsw-local() {
  if [ -z "$1" ]; then
    echo "Usage: gsw-local <config_name>"
    echo "  Switches configuration ONLY for this terminal tab."
    echo ""
    echo "Available gcloud configurations:"
    gcloud config configurations list
    echo ""
    echo "💡 Tip: This sets the environment variable:"
    echo "       export CLOUDSDK_ACTIVE_CONFIG_NAME=\"<config_name>\""
    return
  fi
  
  export CLOUDSDK_ACTIVE_CONFIG_NAME="$1"
  echo "✅ Switched LOCALLY to configuration: $1"
  echo "(This change only affects this terminal tab)"
  
  echo "Current Identity:"
  gcloud config list --format="value(core.account,core.project)" | tr '\t' '\n' | sed 's/^/- /'
}

# Completion for gsw and gsw-local
_gsw() {
  local -a configs
  configs=("${(@f)$(gcloud config configurations list --format="value(name)")}")
  compadd -a configs
}
compdef _gsw gsw
compdef _gsw gsw-local
