mod speakerdeck

# Show usage examples for web module
example:
    @just common::print_header "Web Module Examples"
    @just common::print_section "SpeakerDeck PDF utilities"
    @just common::print_command "just web::speakerdeck::pdf-download [URL]" "Download PDF from SpeakerDeck page"
    @echo ""
