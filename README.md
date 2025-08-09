# Justfile Collection

A modular collection of Just recipes for common development tasks.

## Setup

Enable global access to all justfile commands:

```bash
ln -s "$(pwd)" ~/.config/just
```

This allows you to use the justfiles from anywhere with:

```bash
just -g [MODULE]::[FEATURE]
```

## Usage

### View available modules
```bash
just -g
```

### View module examples
```bash
just -g [MODULE]::example
```

### Examples
```bash
# Git operations
just -g git::cd                  # Navigate git repositories
just -g git::log                  # View formatted git logs
just -g git::branch              # Manage branches

# Time calculations
just -g time::gap 20:00 21:30   # Calculate time difference
just -g time::add 09:00 08:30   # Add time durations

# Code analysis
just -g analyze::token "file.txt"  # Count tokens in file
just -g analyze::lang ./project    # Analyze language distribution

# Web utilities
just -g web::pdf-download "https://example.com/doc.pdf"  # Download PDFs
```

## Modules

- **analyze**: Code analysis tools (token counting, language statistics)
- **git**: Git workflow utilities
- **time**: Time calculation and manipulation
- **web**: Web-related utilities (PDF downloads, etc.)

## Contributing

See CLAUDE.md for project structure and contribution guidelines.
