# Nix Package Review Prompt

You are reviewing a Nix-based dotfiles project. Your task is to audit the packages and configurations for:

## Review Criteria

1. **Package Necessity**: Is each package actually needed?
2. **Version Updates**: Are packages using recent versions?
3. **Security**: Are there any security concerns with packages?
4. **Dependencies**: Are there missing or redundant dependencies?
5. **Configuration**: Are packages properly configured?
6. **Performance**: Are there performance optimizations possible?

## Project Context

This is a cross-platform dotfiles project with:
- **Systems**: Darwin (macOS) and Linux
- **Architectures**: aarch64 and x86_64
- **Management**: Home Manager + nix-darwin
- **Structure**: Modular organization with CLI, dev, fun, system, and shell modules

## Current Package Categories

- **CLI Tools**: eza, fd, ripgrep, jq, yq, htop, tree, pstree, dust, duf, procs, bottom, tealdeer, hyperfine, tokei, fzf, zoxide, bat, git (with delta, lazygit)
- **Development**: direnv, watchexec, entr, nil, glow, nodejs, markdownlint, go, rustc, cargo, bun
- **System**: nmap, bandwhich, iftop, lsof, ncdu, podman
- **Shell**: zsh, tmux

## Questions to Answer

1. Are there any packages that could be removed or replaced?
2. Are there any missing packages that would be valuable?
3. Are there any version conflicts or compatibility issues?
4. Are there any security vulnerabilities in the current package set?
5. Are there any performance optimizations possible?
6. Are there any packages that should be moved between categories?

Please provide specific recommendations with reasoning. 