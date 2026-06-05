## 1. Implement XDG migration in Home Manager

- [x] 1.1 Replace `home.file.".openclaw/openclaw.json"` with `xdg.configFile."openclaw/openclaw.json"` in `ai.nix`
- [x] 1.2 Update `openclaw-pkg` wrapper in `ai.nix` to export `OPENCLAW_CONFIG_PATH="$HOME/.config/openclaw/openclaw.json"`
- [x] 1.3 Update `assistant-pkg` wrapper in `ai.nix` to export `OPENCLAW_CONFIG_PATH="$HOME/.config/openclaw/openclaw.json"`

## 2. Verification and Switching

- [x] 2.1 Run `nix flake check` to verify configuration syntax
- [x] 2.2 Apply Home Manager changes via switch script
- [x] 2.3 Verify execution and configuration path resolution of `openclaw` and `assistant` commands
