mod timegap

# Show usage examples for time module
example:
    @just common::print_header "Time Module Examples"
    @just common::print_section "Calculate work time progress"
    @just common::print_command "just time::timegap \"09:00\" 8 1" "Started at 9:00, target 8 hours, 1 hour break"
