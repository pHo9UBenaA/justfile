# Show directory tree structure
tree TARGET_DIR="." IGNORE="":
    #!/bin/bash
    set -e

    TARGET_DIR="{{ TARGET_DIR }}"
    IGNORE="{{ IGNORE }}"

    # Get directory name for display
    get_dir_name() {
        if [[ "$TARGET_DIR" == "." ]]; then
            basename "$(pwd)"
        else
            basename "$TARGET_DIR"
        fi
    }

    # Build ignore patterns for tree command
    build_tree_ignore() {
        local ignore_pattern=".git|.DS_Store|.gitignore"
        if [[ -n "$IGNORE" ]]; then
            IFS=',' read -ra patterns <<< "$IGNORE"
            for pattern in "${patterns[@]}"; do
                pattern=$(echo "$pattern" | xargs)
                if [[ "$pattern" == *"/*" ]]; then
                    ignore_pattern="$ignore_pattern|$(basename "${pattern%/*}")"
                else
                    ignore_pattern="$ignore_pattern|$pattern"
                fi
            done
        fi
        echo "$ignore_pattern"
    }

    # Generate tree output
    if command -v tree >/dev/null 2>&1; then
        echo "└── $(get_dir_name)/"
        tree "$TARGET_DIR" -I "$(build_tree_ignore)" -a --dirsfirst | tail -n +2 | sed 's/^/    /'
    else
        echo "tree command not found. Install with: brew install tree"
    fi
