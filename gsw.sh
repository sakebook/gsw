#!/bin/bash

# gsw: Google Switch
# Easily switch between gcloud configurations
GSW_VERSION="v0.3.0"

function gsw() {
  # Check if gcloud is installed
  if ! command -v gcloud >/dev/null 2>&1; then
    echo "Error: 'gcloud' command not found."
    echo "Please install the Google Cloud SDK first: https://cloud.google.com/sdk/docs/install"
    return 1
  fi

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
    local session_config="$CLOUDSDK_ACTIVE_CONFIG_NAME"
    local list_output
    list_output=$(gcloud config configurations list 2>/dev/null)
    
    if [ -n "$session_config" ]; then
      # If session config is active, highlight it in the list
      echo "$list_output" | while IFS= read -r line; do
        # Extract the first column (NAME) and compare literally
        local name="${line%% *}"
        if [ "$name" = "$session_config" ]; then
          echo "* $line (session active)"
        else
          echo "  $line"
        fi
      done
    else
      # shellcheck disable=SC2001
      echo "$list_output" | sed 's/^/  /'
    fi

    echo ""
    echo "Usage: gsw [options] <config_name>"
    echo "  (Default switches only for this terminal session)"
    echo ""
    echo "Options:"
    echo "  -g, --global    Switch the GLOBAL active configuration"
    return
  fi

  # Security: Validate configuration name (allow only [a-z0-9_-])
  # This prevents command injection or other malicious input.
  if [[ ! "$config_name" =~ ^[a-z0-9_-]+$ ]]; then
    echo "Error: Invalid configuration name '$config_name'."
    echo "Configuration names can only contain lowercase letters, numbers, hyphens, and underscores."
    return 1
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

if [ -n "$BASH_VERSION" ]; then
  # Bash Completion
  _gsw_bash_autocomplete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Flags
    opts="-g --global -h --help -v --version"
    
    case "${prev}" in
      -g|--global)
        # Only configurations after global flag
        local configs
        configs=$(gcloud config configurations list --format="value(name)" 2>/dev/null)
        # shellcheck disable=SC2207
        COMPREPLY=( $(compgen -W "${configs}" -- "${cur}") )
        return 0
        ;;
    esac

    if [[ ${cur} == -* ]] ; then
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
      return 0
    fi

    # Default: configurations + flags
    local configs
    configs=$(gcloud config configurations list --format="value(name)" 2>/dev/null)
    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -W "${opts} ${configs}" -- "${cur}") )
    return 0
  }
  complete -F _gsw_bash_autocomplete gsw

elif [ -n "$ZSH_VERSION" ]; then
  # Zsh Completion
  _gsw() {
    _arguments \
      '(-g --global)'{-g,--global}'[Switch the GLOBAL active configuration]' \
      '(-h --help)'{-h,--help}'[Show help message]' \
      '(-v --version)'{-v,--version}'[Show version information]' \
      '*:gcloud configuration:_gsw_configs'
  }
  _gsw_configs() {
    local -a configs
    # shellcheck disable=SC2034,SC2296
    configs=("${(@f)$(gcloud config configurations list --format="value(name)" 2>/dev/null)}")
    _describe -t configurations 'gcloud configuration' configs
  }
  compdef _gsw gsw
fi
