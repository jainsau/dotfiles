# Shell Conditional Style Guide

## Pattern

Use `[ ]` (single bracket, POSIX test) for **all file tests** in shell scripts within Nix configs:

```bash
# ✅ Correct - single bracket for file tests
if [ -f "$HOME/.secrets.env" ]; then
  source "$HOME/.secrets.env"
fi

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
```

```bash
# ❌ Wrong - don't mix [[ ]] for simple file tests
if [[ -f "$HOME/.secrets.env" ]]; then
  source "$HOME/.secrets.env"
fi
```

## Rationale

1. **Consistency** - The codebase already uses `[ ]` for file tests in critical paths (Nix daemon, Homebrew)
2. **POSIX compatibility** - `[ ]` works in all shells; `[[ ]]` is bash/zsh-specific
3. **Simplicity** - File tests don't need bash extensions like pattern matching or regex

## When to use `[[ ]]`

Only use `[[ ]]` when you need bash/zsh-specific features:
- String comparisons: `[[ "$var" == "value" ]]`
- Pattern matching: `[[ "$file" == *.txt ]]`
- Regex: `[[ "$string" =~ ^[0-9]+$ ]]`
- Logical operators: `[[ -f file && -x file ]]`

## Applied

Fixed `nix/home-manager/modules/shell/zsh.nix` to use `[ ]` consistently for all file tests.
