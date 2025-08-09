# Show directory tree structure

DEFAULT_IGNORE_PATTERNS := ".git,.DS_Store"
PATTERN_SEPARATOR_CHAR := ","
TREE_OUTPUT_INDENT := "    "

tree target_directory_path="." *command_flags:
    #!/bin/bash
    set -e
    
    parse_command_flags() {
        additional_ignore_patterns="" file_match_pattern=""
        for arg in {{ command_flags }}; do
            case "$arg" in
                --ignore=*) additional_ignore_patterns="${arg#*=}" ;;
                --pattern=*) file_match_pattern="${arg#*=}" ;;
                *) echo "Unknown flag: $arg"; exit 1 ;;
            esac
        done
    }
    
    build_combined_ignore_pattern() {
        local combined_pattern="{{DEFAULT_IGNORE_PATTERNS}}"
        if [[ -n "$additional_ignore_patterns" ]]; then
            combined_pattern="$combined_pattern{{PATTERN_SEPARATOR_CHAR}}$additional_ignore_patterns"
        fi
        echo "$combined_pattern" | tr '{{PATTERN_SEPARATOR_CHAR}}' '|'
    }
    
    extract_directory_display_name() {
        if [[ "{{ target_directory_path }}" == "." ]]; then
            basename "$(pwd)"
        else
            basename "$(realpath "{{ target_directory_path }}")"
        fi
    }
    
    if ! command -v tree >/dev/null; then
        echo "tree command not found. Install with: brew install tree"
        exit 1
    fi
    
    parse_command_flags
    echo "└── $(extract_directory_display_name)/"
    
    if [[ -n "$file_match_pattern" ]]; then
        # Use find + tree for better pattern matching
        if [[ "$file_match_pattern" == "**/*."* ]]; then
            # Convert **/*.ext to *.ext for find
            find_pattern="${file_match_pattern#**/}"
        else
            find_pattern="$file_match_pattern"
        fi
        
        # Find matching files and get their directories
        matching_files=$(find "{{ target_directory_path }}" -name "$find_pattern" 2>/dev/null)
        
        if [[ -z "$matching_files" ]]; then
            echo "{{TREE_OUTPUT_INDENT}}No files matching pattern '$file_match_pattern' found."
            exit 0
        fi
        
        # Show tree with pattern filter and prune empty directories
        tree "{{ target_directory_path }}" -I "$(build_combined_ignore_pattern)" -a --dirsfirst -P "$find_pattern" --prune
    else
        # Standard tree without pattern filtering
        tree "{{ target_directory_path }}" -I "$(build_combined_ignore_pattern)" -a --dirsfirst
    fi | tail -n +2 | sed "s/^/{{TREE_OUTPUT_INDENT}}/"
