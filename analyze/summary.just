# Show project summary with file count and token estimation
summary TARGET_DIR="." IGNORE="":
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

    # Function to count tokens (rough estimation: 4 chars per token)
    estimate_tokens() {
        local total_chars=0
        local excludes=$(build_find_exclude)

        while IFS= read -r -d '' file; do
            if [[ -f "$file" ]]; then
                chars=$(wc -c < "$file" 2>/dev/null || echo 0)
                total_chars=$((total_chars + chars))
            fi
        done < <(eval "find \"$TARGET_DIR\" -type f $excludes -print0")

        # Rough estimation: 4 characters per token
        echo $((total_chars / 4))
    }

    # Function to count files
    count_files() {
        local excludes=$(build_find_exclude)
        eval "find \"$TARGET_DIR\" -type f $excludes | wc -l"
    }

    # Function to get repository name
    get_repo_name() {
        if [[ -d "$TARGET_DIR/.git" ]]; then
            git -C "$TARGET_DIR" remote get-url origin 2>/dev/null | sed 's|.*[:/]||' | sed 's|\.git$||' || basename "$TARGET_DIR"
        else
            basename "$TARGET_DIR"
        fi
    }

    # Main execution
    repo_name=$(get_repo_name)
    file_count=$(count_files)
    token_estimate=$(estimate_tokens)

    # Format token estimate
    if [[ $token_estimate -ge 1000 ]]; then
        token_display=$(echo "scale=1; $token_estimate / 1000" | bc)"k"
    else
        token_display="$token_estimate"
    fi

    echo "Repository: $repo_name"
    echo "Files analyzed: $file_count"
    echo
    echo "Estimated tokens: $token_display"
