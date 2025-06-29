# 🛠️ TODO

A growing list of tasks and ideas for improving and evolving this dotfiles + Nix setup.

---

## ✅ Planned Features

- [ ] Add support for Darwin manager
- [ ] Migrate `home.nix` to Nix Flakes
- [ ] Add project templates with `nix-direnv` for:
  - [ ] Go
  - [ ] C
  - [ ] Python
  - [ ] Rust
- [ ] Modularize documentation
  - [ ] Use separate Markdown files per component
  - [ ] Organize docs inside respective folders
- [ ] Factor out reusable utility modules:
  - [ ] Logging
  - [ ] Bootstrap/setup logic
- [ ] Add CLI support for verbose/quiet install modes

---

## 💡 Ideas / Future Enhancements

- [ ] Remote bootstrap (e.g., over SSH)
- [ ] Multi-platform dotfile overrides
- [ ] Automatic detection of environment (Mac/Linux)
- [ ] Add CI workflow for config validation/build

---

## 📌 Notes

- Favor declarative and reproducible workflows
- Stick to minimal external dependencies
- Prioritize clean UX for setup scripts

# ✅ Completed Tasks

- [x] **Modularize Home Manager Configuration**: Refactored the monolithic `home.nix` into a fully modular structure under `nix/home-manager/modules/`.
  - [x] Grouped modules by category (`cli`, `dev`, `fun`, `shell`, `system`).
  - [x] Created individual Nix files for each tool or component.
- [x] **Zsh Environment Refinement**:
  - [x] Replaced Oh My Zsh with native Home Manager Zsh plugin management.
  - [x] Switched from Powerlevel10k to Starship for prompt.
  - [x] Replaced `z` command with Zoxide.
  - [x] Restored `...` directory navigation aliases.
  - [x] Added `ll`, `l`, `la` aliases.
  - [x] Ensured Zsh completions, autosuggestions, and syntax highlighting are enabled.
  - [x] Removed redundant Git aliases.
- [x] **Configuration Cleanup**:
  - [x] Removed obsolete `p10k-link.nix` file and its import.

- [x] **Update Documentation**: Overhauled `README.md` to reflect the new modular structure, features, and installation process.

---

# 💡 Future Enhancements

This is a list of potential ideas for further improving this setup.

- [ ] **macOS System Configuration**: Fully utilize `nix-darwin` to manage system-level settings on macOS declaratively (e.g., Dock, Finder, keyboard settings).
- [ ] **Secret Management**: Integrate a tool like `sops-nix` or `agenix` to manage secrets (e.g., API keys, tokens) declaratively and securely.
- [ ] **CI/CD Pipeline**: Add a GitHub Actions workflow to automatically check for Nix formatting (`nixpkgs-fmt`) and validate that the flake builds successfully on push.
- [ ] **Advanced `direnv` Setups**: Create more sophisticated `direnv` templates for different project types (Go, Python, Rust) to automate environment setup.
- [ ] **Cross-Platform Support**: Abstract macOS-specific settings to allow the configuration to be easily adapted for a Linux environment.
- [ ] **Explore Overlays**: Use Nix overlays to easily override or patch packages with custom versions or configurations.
