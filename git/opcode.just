opcode *args:
    #!/usr/bin/env bash
    set -e
    
    GIT_ROOT="$HOME/Documents/git"
    CODE_ARGS="{{args}}"
    result=$(just git::common::_navigate_git "$GIT_ROOT" "Ctrl+O: Open in VS Code" "ctrl-o")
    
    if [[ "$result" == ACTION:* ]]; then
        path="${result#ACTION:}"
        echo "🚀 Opening: $path"
        code ${CODE_ARGS} "$path" &
    fi
