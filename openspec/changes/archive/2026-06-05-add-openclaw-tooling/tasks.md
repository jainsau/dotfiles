## 1. Implement declarative configuration and packages in Home Manager

- [x] 1.1 Define OpenClaw configuration file `~/.openclaw/openclaw.json` in `ai.nix` using `home.file`
- [x] 1.2 Add unbranded `openclaw-pkg` launcher in `ai.nix`
- [x] 1.3 Add `assistant-pkg` central launcher in `ai.nix`
- [x] 1.4 Reference `openclaw-pkg` and `assistant-pkg` in `home.packages` list of `ai.nix`

## 2. Verification and Switching

- [x] 2.1 Run `nix flake check` to verify configuration syntax
- [x] 2.2 Apply Home Manager changes via switch script
- [x] 2.3 Verify execution of `openclaw` and `assistant` commands
