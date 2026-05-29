## Context

The GitHub CLI is currently listed in `nix/home-manager/modules/cli/tools.nix` as a generic home package without any configuration. This design aims to leverage Home Manager's built-in `programs.gh` module for declarative control.

## Goals / Non-Goals

**Goals:**
- Enable `programs.gh` to declaratively install and configure the GitHub CLI.
- Set default protocol to SSH.
- Keep the Nix configuration clean and properly modularized.

**Non-Goals:**
- Auto-injecting authentication credentials (which are interactive or handled dynamically).

## Decisions

- **Configure `programs.gh` in `nix/home-manager/modules/cli/git.nix`:** Since `gh` is highly coupled with Git, it fits naturally within `git.nix`, which is conditional on `config.tools.enableGit`.
- **Remove `gh` from `nix/home-manager/modules/cli/tools.nix`:** To avoid duplicate declarations and keep package definitions clean.

## Risks / Trade-offs

- **Risk:** Existing manual config in `~/.config/gh/` might be overwritten by Home Manager links.
  - **Mitigation:** The settings are minimal and standardized (`git_protocol = "ssh"`), and authentication tokens are kept in hosts.yml or git credentials which Home Manager preserves unless explicitly defined.
