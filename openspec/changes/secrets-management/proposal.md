# Proposal: Secrets Management with agenix

## Problem

`.user.nix` stores plaintext `gitEmail` and `gpgKey` — committed to git. Anyone with repo access sees credentials. No encrypted secrets layer exists.

## Proposed Solution: agenix

Use `agenix` (age-encrypted secrets, SSH key decryption):
- Secrets encrypted with age, decrypted at activation time using SSH host key
- Works with nix-darwin + home-manager
- Lightweight vs sops-nix — no KMS, no complex key management

## Changes Required

1. Add `agenix` to `flake.nix` inputs
2. Add `agenix.darwinModules.default` to darwin config
3. Create `secrets/` directory with encrypted secret files
4. Replace `.user.nix` `gitEmail`/`gpgKey` with agenix secret references
5. Document initial key setup in README

## Migration Path

1. Generate age key from existing SSH key: `ssh-to-age`
2. Encrypt existing values: `agenix -e secrets/git.age`
3. Remove plaintext values from `.user.nix`
4. Add `.user.nix` to `.gitignore` or stub it with empty strings

## Impact

- Breaks existing `.user.nix` workflow — migration guide required
- First-time setup needs SSH key present before activation
- CI/CD uses stub `.user.nix` with empty strings (no secrets needed for flake check)
