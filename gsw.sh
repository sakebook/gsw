#!/bin/zsh

# gsw: Google Switch
# Easily switch between gcloud configurations
GSW_VERSION="v0.3.0"

function gsw() {
  local is_global=false
  local config_name=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --version|-v)
        echo "gsw version $GSW_VERSION"
        return 0
        ;;
      --help|-h)
        echo "Usage: gsw [options] <config_name>"
        echo ""
        echo "  Switches the gcloud configuration for the current session by default."
        echo ""
        echo "Options:"
        echo "  <config_name>    Name of the gcloud configuration to activate"
        echo "  -g, --global     Switch the GLOBAL active configuration"
        echo "  -h, --help       Show this help message"
        echo "  -v, --version    Show version information"
        echo ""
        echo "💡 Tip: Run 'gsw' without arguments to see available configurations."
        return 0
        ;;
      -g|--global)
        is_global=true
        shift
        ;;
      -*)
        echo "Error: Unknown option $1"
        return 1
        ;;
      *)
        config_name="$1"
        shift
        ;;
    esac
  done

  if [ -z "$config_name" ]; then
    echo "Available gcloud configurations:"
    gcloud config configurations list
    echo ""
    echo "Usage: gsw [options] <config_name>"
    echo "  (Default switches only for this terminal session)"
    echo ""
    echo "Options:"
    echo "  -g, --global    Switch the GLOBAL active configuration"
    return
  fi

  # Check if the configuration exists
  if ! gcloud config configurations describe "$config_name" > /dev/null 2>&1; then
    echo "Error: Configuration '$config_name' does not exist."
    echo "Available configurations:"
    gcloud config configurations list
    return 1
  fi

  if [ "$is_global" = true ]; then
    gcloud config configurations activate "$config_name"
    echo "✅ Switched GLOBALLY to configuration: $config_name"
  else
    export CLOUDSDK_ACTIVE_CONFIG_NAME="$config_name"
    echo "✅ Switched SESSION to configuration: $config_name"
    echo "(This change only affects this terminal tab)"
  fi
  
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

elif [ -n "$ZSH_VERSION" ]; then
  # Zsh Completion
  _gsw() {
    local -a configs
    configs=("${(@f)$(gcloud config configurations list --format="value(name)" 2>/dev/null)}")
    compadd -a configs
  }
  compdef _gsw gsw
fi
