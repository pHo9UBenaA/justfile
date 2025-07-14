cd *args:
    #!/usr/bin/env bash
    set -e
    
    GIT_ROOT="$HOME/Documents/git"
    result=$(just git::common::_navigate_git "$GIT_ROOT" "Ctrl+O: Select directory" "ctrl-o")
    
    if [[ "$result" == ACTION:* ]]; then
        path="${result#ACTION:}"
        echo cd "$path"
    fi