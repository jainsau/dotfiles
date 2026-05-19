## CURRENT Requirements

### Requirement: No plaintext credentials in git
User-specific sensitive values (git email, GPG key fingerprint) must not exist as plaintext in tracked files.

#### Scenario: Git email / GPG key
- **WHEN** `.user.nix` contains `gitEmail` or `gpgKey`
- **THEN** these values should be encrypted at rest via agenix or sourced from system keychain

### Requirement: Secrets tool — agenix (planned)
- **WHEN** secrets management is implemented
- **THEN** use `agenix` (age-encrypted secrets, SSH key decryption, nix-darwin compatible)
- NOT sops-nix (heavier, overkill for personal dotfiles)

### Requirement: GPG signing guard
- **WHEN** `args.gpgKey == ""`
- **THEN** `programs.git.signing` must NOT be set — misconfigures git silently
- Fix: `lib.mkIf (args.gpgKey != "") { ... }` in `cli/git.nix:36-40`

### Requirement: CI/CD must not require secrets
- **WHEN** GitHub Actions runs flake check
- **THEN** no real credentials needed — `.user.nix` provides stub values
