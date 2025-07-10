mod lsrepo
mod opcode

# Show usage examples for git module
example:
    @just common::print_header "Git Module Examples"
    @just common::print_section "Interactive repository browser and VS Code opener"
    @just common::print_command "just git::opcode" "Browse git repositories interactively and open in VS Code"
    @echo ""
    @just common::print_command "just git::opcode -r" "Open selected repository in the current VS Code window"
    @echo ""
    @just common::print_section "List and navigate repositories"
    @just common::print_command "just git::lsrepo" "Alternative repository navigation interface"
