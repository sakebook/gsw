#!/bin/zsh

# gsw: Google Switch
# Easily switch between gcloud configurations
GSW_VERSION="v0.2.0"

function gsw() {
  if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "gsw version $GSW_VERSION"
    return 0
  fi

  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: gsw <config_name>"
    echo "       gsw --help"
    echo "       gsw --version"
    echo ""
    echo "  Switches the GLOBAL active gcloud configuration."
    echo ""
    echo "Options:"
    echo "  <config_name>   Name of the gcloud configuration to activate"
    echo "  --help, -h      Show this help message"
    echo "  --version, -v   Show version information"
    echo ""
    echo "💡 Tip: Run 'gsw' without arguments to see available configurations."
    return 0
  fi

  if [ -z "$1" ]; then
    echo "Available gcloud configurations:"
    gcloud config configurations list
    echo ""
    echo "Usage: gsw <config_name>"
    echo "       gsw --help"
    echo "       gsw --version"
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
  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: gsw-local <config_name>"
    echo "       gsw-local --help"
    echo ""
    echo "  Switches configuration ONLY for this terminal session."
    echo "  This sets the CLOUDSDK_ACTIVE_CONFIG_NAME environment variable."
    echo ""
    echo "Options:"
    echo "  <config_name>   Name of the gcloud configuration to activate locally"
    echo "  --help, -h      Show this help message"
    echo ""
    echo "💡 Tip: Run 'gsw-local' without arguments to see available configurations."
    return 0
  fi

  if [ -z "$1" ]; then
    echo "Available gcloud configurations:"
    gcloud config configurations list
    echo ""
    echo "Usage: gsw-local <config_name>"
    echo "       gsw-local --help"
    echo "  Switches configuration ONLY for this terminal tab."
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

# Completion Logic
if [ -n "$BASH_VERSION" ]; then
  # Bash Completion
  _gsw_bash_autocomplete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    
    # Fetch configurations
    opts=$(gcloud config configurations list --format="value(name)" 2>/dev/null)
    
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  }
  complete -F _gsw_bash_autocomplete gsw
  complete -F _gsw_bash_autocomplete gsw-local

elif [ -n "$ZSH_VERSION" ]; then
  # Zsh Completion
  _gsw() {
    local -a configs
    configs=("${(@f)$(gcloud config configurations list --format="value(name)" 2>/dev/null)}")
    compadd -a configs
  }
  compdef _gsw gsw
  compdef _gsw gsw-local
fi
