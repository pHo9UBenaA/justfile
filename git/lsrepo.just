opcode *args:
    #!/usr/bin/env bash
    set -e

    GIT_ROOT="$HOME/Documents/git"
    CODE_ARGS="{{args}}"

    cd "$GIT_ROOT"
    current_path="$GIT_ROOT"

    while true; do
        dirs=$(find . -maxdepth 1 -type d ! -name '.' | sed 's|^\./||' | sort)

        if [ -z "$dirs" ]; then
            echo "No directories found"
            break
        fi

        selected=$(echo "$dirs" | fzf \
            --prompt="📁 $(basename "$current_path"): " \
            --height=60% \
            --reverse \
            --border \
            --expect=ctrl-o \
            --header="Enter: Navigate into directory | Ctrl+O: Open in VS Code")

        key=$(echo "$selected" | head -1)
        choice=$(echo "$selected" | tail -1)

        if [ -z "$choice" ]; then
            break
        fi

        if [ "$key" = "ctrl-o" ]; then
            echo "🚀 Opening: $current_path/$choice"
            ls -A ${CODE_ARGS} "$current_path/$choice" &
            break
        else
            cd "$choice"
            current_path="$current_path/$choice"
        fi
    done
