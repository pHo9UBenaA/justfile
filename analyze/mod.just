mod summary
mod tree
mod files

# Show usage examples for analyze module
example:
    @just common::print_header "Analyze Module Examples"
    @just common::print_section "Show project summary with file count and token estimation"
    @just common::print_command "just analyze::summary" "Analyze current directory"
    @just common::print_command "just analyze::summary \"/path/to/project\"" "Analyze specific directory"
    @just common::print_command "just analyze::summary \".\" \"node_modules/*,*.log\"" "Analyze with ignore patterns"
    @echo ""
    @just common::print_section "Show directory tree structure"
    @just common::print_command "just analyze::tree" "Show tree of current directory"
    @just common::print_command "just analyze::tree \"/path/to/project\"" "Show tree of specific directory"
    @just common::print_command "just analyze::tree \".\" \"node_modules/*,dist/*\"" "Show tree with ignore patterns"
    @echo ""
    @just common::print_section "Show all file contents"
    @just common::print_command "just analyze::files" "Show all files in current directory"
    @just common::print_command "just analyze::files \"src\"" "Show all files in src directory"
    @just common::print_command "just analyze::files \".\" \"*.md,*.txt\"" "Show files with ignore patterns"
