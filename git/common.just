# Common helper functions for git module

# Navigate directories with fzf
_navigate_git base_path action_text action_key="ctrl-o":
    #!/usr/bin/env bash
    set -e
    
    GIT_ROOT="$HOME/Documents/git"
    PARENT_DIR_OPTION=".."
    
    cd "{{base_path}}"
    current_path="{{base_path}}"
    
    while true; do
        dirs=$(find . -maxdepth 1 -type d ! -name '.' | sed 's|^\./||' | sort)
        
        # Add parent directory option if not at GIT_ROOT
        if [ "$current_path" != "$GIT_ROOT" ]; then
            dirs="$PARENT_DIR_OPTION"$'\n'"$dirs"
        fi
        
        if [ -z "$dirs" ]; then
            echo "No directories found"
            break
        fi
        
        selected=$(echo "$dirs" | fzf \
            --prompt="📁 $(basename "$current_path"): " \
            --height=60% \
            --reverse \
            --border \
            --expect={{action_key}} \
            --header="Enter: Navigate into directory | {{action_text}} | .. : Go to parent directory")
        
        key=$(echo "$selected" | head -1)
        choice=$(echo "$selected" | tail -1)
        
        if [ -z "$choice" ]; then
            break
        fi
        
        if [ "$key" = "{{action_key}}" ]; then
            echo "ACTION:$current_path/$choice"
            break
        elif [ "$choice" = "$PARENT_DIR_OPTION" ]; then
            # Navigate to parent directory
            cd ".."
            current_path=$(dirname "$current_path")
        else
            cd "$choice"
            current_path="$current_path/$choice"
        fi
    done