mod summary
mod tree
mod files

# Show usage examples for analyze module
example:
    @just common::print_header "Analyze Module Examples"
    @just common::print_section "Show project summary with file count and token estimation"
    @just common::print_command "just -g analyze::summary \$\(pwd\)" "Analyze current directory"
    @just common::print_command "just -g analyze::summary \$\(pwd\) \"node_modules/*,*.log\"" "Analyze with ignore patterns"
    @echo ""
    @just common::print_section "Show directory tree structure"
    @just common::print_command "just -g analyze::tree \$\(pwd\)" "Show tree of current directory"
    @just common::print_command "just -g analyze::tree \$\(pwd\) --pattern='**/*.txt'" "Show tree with file pattern"
    @just common::print_command "just -g analyze::tree \$\(pwd\) --ignore=node_modules/*,dist/*" "Show tree with ignore patterns"
    @echo ""
    @just common::print_section "Show all file contents"
    @just common::print_command "just -g analyze::files \$\(pwd\)" "Show all files in current directory"
    @just common::print_command "just -g analyze::files \"\$\(pwd\)\" \"*.md,*.txt\"" "Show files with ignore patterns"
