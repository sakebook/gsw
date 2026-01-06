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
# Mock gcloud for simple list usage if needed (though gsw mock handles most)
Type "function gcloud() { :; }"
Enter

# OVERRIDE gsw/gsw-local
# Using single quotes for VHS 'Type' makes it much safer to define functions with double quotes internally
Type 'function gsw() { if [ -z "$1" ]; then echo "Available gcloud configurations:"; echo "NAME               IS_ACTIVE  ACCOUNT               PROJECT"; echo "default            True       user@demo.com         demo-project"; echo "work-project       False      worker@corp.com       work-production"; echo "personal-side-hustle False      me@gmail.com          personal-app"; echo ""; echo "Usage: gsw <config_name>"; echo "  Switches the GLOBAL active configuration."; else echo "Activated [$1]."; echo "✅ Switched to configuration: $1"; echo "Current Identity:"; echo "- user@demo.com"; echo "- $1-id"; export PS1="%F{blue}%1~%f %F{cyan}(gcloud:$1)%f %# "; fi }'
Enter

Type 'function gsw-local() { echo "✅ Switched LOCALLY to configuration: $1"; echo "(This change only affects this terminal tab)"; echo "Current Identity:"; echo "- user@demo.com"; echo "- $1-id"; export CLOUDSDK_ACTIVE_CONFIG_NAME="$1"; export PS1="%F{blue}%1~%f %F{cyan}(gcloud:$1)%f %# "; }'
Enter

# 2. Configure PS1 (Initial State)
Type "export PS1='%F{blue}%1~%f %F{cyan}(gcloud:default)%f %# '"
Enter
# Clear screen to start fresh
Type "clear"
Enter
Show

# Start the demo
# (Removed no-arg 'gsw' check as requested)

Type "# Switch global configuration easily"
Enter
Sleep 500ms
Type "gsw work-project"
Enter
Sleep 2s

Type "# Or switch LOCALLY for just this shell session"
Enter
Sleep 500ms
Type "gsw-local personal-side-hustle"
Enter
Sleep 2s

Type "# Verify: Only this shell session is affected (env var is set)"
Enter
Sleep 500ms
Type "echo $CLOUDSDK_ACTIVE_CONFIG_NAME"
Enter
Sleep 3s
