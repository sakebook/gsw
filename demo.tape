# demo.tape
# Created by VHS
# Install VHS: brew install vhs
# Run: vhs demo.tape

Output demo.gif

Set Shell "zsh"
Set FontSize 16
Set Width 800
Set Height 500
Set Padding 12
Set TypingSpeed 35ms
Set FontFamily "Menlo"
Set WindowBar Colorful
Set Theme "Catppuccin Frappe"

# Hide the setup commands so the viewer only sees the result
Hide
Type "source ./gsw.sh"
Enter
Type "autoload -Uz colors && colors"
Enter
Type "setopt PROMPT_SUBST"
Enter
Type "setopt INTERACTIVE_COMMENTS"
Enter
# Mock gcloud for simple list usage
Type "function gcloud() { :; }"
Enter
Type 'GSW_GLOBAL="default"; GSW_SESSION="";'
Enter

# OVERRIDE gsw for demo (Mocks output and PS1 updates with state)
Type 'function gsw() { local is_global=false; local config=""; while [[ $# -gt 0 ]]; do case "$1" in -g|--global) is_global=true; shift ;; *) config="$1"; shift ;; esac; done; if [ -z "$config" ]; then echo "Available gcloud configurations:"; echo "NAME               IS_ACTIVE  ACCOUNT               PROJECT"; echo "default            True       user@demo.com         demo-project"; echo "work-project       False      worker@corp.com       work-production"; echo "personal-side-hustle False      me@gmail.com          personal-app"; echo ""; echo "Usage: gsw [options] <config_name>"; return; fi; if [ "$is_global" = true ]; then GSW_GLOBAL="$config"; echo "✅ Switched GLOBALLY to configuration: $config"; else GSW_SESSION="$config"; export CLOUDSDK_ACTIVE_CONFIG_NAME="$config"; echo "✅ Switched SESSION to configuration: $config"; echo "(This change only affects this terminal tab)"; fi; local active=${GSW_SESSION:-$GSW_GLOBAL}; export PS1="%F{blue}%1~%f %F{cyan}(gcloud:$active)%f %# "; }'
Enter

# 2. Configure PS1 (Initial State)
Type "export PS1='%F{blue}%1~%f %F{cyan}(gcloud:default)%f %# '"
Enter
# Clear screen to start fresh
Type "clear"
Enter
Show

# Start the demo
Type "# First, switch the Global configuration"
Enter
Sleep 500ms
Type "gsw -g work-project"
Enter
Sleep 2s

Type "# Now, switch SESSION for just this terminal tab"
Enter
Sleep 500ms
Type "gsw personal-side-hustle"
Enter
Sleep 2s

Type "# Verify: Environment variable is set, overriding global"
Enter
Sleep 500ms
Type "echo $CLOUDSDK_ACTIVE_CONFIG_NAME"
Enter
Sleep 3s
