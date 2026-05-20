# Project Instructions

- This is a Nix + Home Manager dotfiles repo targeting macOS (Darwin) and Linux.
- Config logic lives in `nix/` — parameterized by settings in `nix/user.nix` (or `.user.nix` override).
- Apply changes: `nix run --impure .#dma-switch` (macOS Apple Silicon) or `nix run --impure .#hma-switch` (HM only).
- Neovim config is at `nix/home-manager/editors/nvim/` — requires HM switch + nvim restart after edits.
- CRITICAL: NEVER read files in the `openspec/` directory using file-reading tools (like `read`, `cat`, or `ctx_read`). You MUST ONLY use the `openspec` CLI (e.g., `openspec list`, `openspec show`) to interact with specs and changes.
- CRITICAL: Every architectural, structural or feature change we make to this codebase MUST be correspondingly updated in openspec (via the `openspec` CLI).
- CRITICAL: All commits MUST follow the Conventional Commits format (e.g., `feat:`, `fix:`, `chore:`, `docs:`, etc.). Include a descriptive body if the change is non-trivial.
- Do not commit secrets or real identity values:
  - **Identity values** (username, git email, GPG key ID) → `.user.nix` (gitignored)
  - **Runtime secrets** (API tokens, passwords) → `~/.secrets.env` (gitignored, chmod 600)
- **Flag exposed secrets immediately**: If you encounter API tokens, passwords, or private keys in shell history, logs, or code, stop and remediate before continuing:
  1. Move secret to `~/.secrets.env`
  2. Clean shell history
  3. Document in openspec
  4. Recommend token rotation
- Run `nix flake check` before switching to catch config errors early.
