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
