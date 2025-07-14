lsrepo *args:
    #!/usr/bin/env bash
    set -e
    
    GIT_ROOT="$HOME/Documents/git"
    LS_ARGS="{{args}}"
    result=$(just git::common::_navigate_git "$GIT_ROOT" "Ctrl+O: List directory" "ctrl-o")
    
    if [[ "$result" == ACTION:* ]]; then
        path="${result#ACTION:}"
        echo "📂 Listing: $path"
        ls -A ${LS_ARGS} "$path"
    fi
