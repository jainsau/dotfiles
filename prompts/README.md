# Prompts Directory

This directory contains AI agent prompts and workflows for managing and maintaining this dotfiles project.

## Structure

- `nix/` - Nix-specific prompts for package management, configuration, and troubleshooting
- `dotfiles/` - General dotfiles management and organization prompts
- `workflows/` - Multi-step workflows for common tasks
- `templates/` - Reusable prompt templates

## Usage

These prompts are designed to work with:
- **opencode** - Terminal-based AI assistant
- **Gemini CLI** - Google's AI assistant
- **Other AI agents** - Claude, ChatGPT, etc.

## Examples

```bash
# Using with opencode
opencode -p prompts/nix/audit.md

# Using with Gemini CLI
gemini -f prompts/workflows/check.md
```

## Available Commands

### `nix/audit.md`
Audit packages and configurations for necessity, security, and performance.

### `workflows/check.md`
Comprehensive audit of modular structure and cross-module dependencies.

### `templates/review.md`
Reusable template for reviewing any configuration file.

### `dotfiles/migrate.md`
Structured approach to planning major changes and migrations.

## Best Practices

1. Keep prompts focused and specific
2. Include context about the project structure
3. Use markdown formatting for readability
4. Version prompts alongside code changes
5. Test prompts with different AI agents 