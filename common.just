# Common helper functions for all modules

# Print header with underline
print_header TITLE:
    @echo "{{TITLE}}:"
    @echo "=================================="
    @echo ""

# Print section header
print_section SECTION:
    @echo "{{SECTION}}:"

# Print command in green color
print_command CMD DESCRIPTION:
    @echo "  \033[1;32m{{CMD}}\033[0m"
    @echo "    → {{DESCRIPTION}}"
