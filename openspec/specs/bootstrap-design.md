## CURRENT Requirements

### Requirement: Two-phase bootstrap
Installation splits into two phases that cannot be merged (shell restart required between them).

#### Scenario: Phase 1 — pre-Nix
- **WHEN** Nix is not installed
- **THEN** install Nix only, prompt user to restart shell

#### Scenario: Phase 2 — post-Nix
- **WHEN** Nix is available
- **THEN** install zsh via Nix/HM, chsh, wire zsh sourcing, run darwin/hm switch

### Requirement: Idempotent install script
- **WHEN** `install.sh` is run more than once
- **THEN** no duplicate sourcing lines, no failed commands, safe re-run

### Requirement: No system package manager for zsh
- **WHEN** installing zsh
- **THEN** use Nix/Home Manager exclusively — no apt/brew/yum fallback

### Requirement: Auto-switch after bootstrap
- **WHEN** Phase 2 completes
- **THEN** run `darwin-rebuild switch` or `home-manager switch` automatically
- Current state: shows instructions but requires manual execution (gap)

### Requirement: Go CLI (planned replacement)
- **WHEN** `dotfiles` CLI is implemented
- **THEN** replaces `install.sh`, `*-switch` shell scripts
- Commands: `dotfiles apply`, `dotfiles bootstrap`, `dotfiles update`
- Provides TUI for `.user.nix` feature flag selection on first run
