# Show all file contents
files TARGET_DIR="." IGNORE="":
    #!/bin/bash
    set -e

    TARGET_DIR="{{ TARGET_DIR }}"
    IGNORE="{{ IGNORE }}"

    # Function to build find command with ignore patterns
    build_find_exclude() {
        local base_excludes="-not -path '*/.git/*' -not -name '.DS_Store' -not -name '.gitignore'"
        local custom_excludes=""

        if [[ -n "$IGNORE" ]]; then
            IFS=',' read -ra patterns <<< "$IGNORE"
            for pattern in "${patterns[@]}"; do
                pattern=$(echo "$pattern" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                if [[ "$pattern" == *"/*" ]]; then
                    # Directory pattern like "src/*"
                    dir_pattern="${pattern%/*}"
                    custom_excludes="$custom_excludes -not -path '*/$dir_pattern/*'"
                else
                    # File pattern like "README.md"
                    custom_excludes="$custom_excludes -not -name '$pattern'"
                fi
            done
        fi

        echo "$base_excludes $custom_excludes"
    }

    # Function to display file contents
    display_files() {
        local excludes=$(build_find_exclude)
        eval "find \"$TARGET_DIR\" -type f $excludes | sort" | while read -r file; do
            if [[ -f "$file" && -r "$file" ]]; then
                rel_path="${file#$TARGET_DIR/}"
                echo "================================================"
                echo "FILE: $rel_path"
                echo "================================================"
                cat "$file"
                echo
                echo
                echo
                echo
            fi
        done
    }

    display_files