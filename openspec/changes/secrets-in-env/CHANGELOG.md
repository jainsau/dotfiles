# Secrets Management Update

**Date**: 2025-05-20  
**Type**: Security Enhancement

## Changes Made

### 1. Created `~/.secrets.env`
- Centralized location for runtime secrets (API tokens, credentials)
- Permissions set to 600 (user-only access)
- Added to `.gitignore`

### 2. Updated `.gitignore`
Added `.secrets.env` to prevent accidental commits:
```
# Runtime secrets
.secrets.env
```

### 3. Updated `nix/home-manager/modules/shell/zsh.nix`
Added automatic sourcing of secrets file:
```nix
# Source secrets (API tokens, credentials)
if [ -f "$HOME/.secrets.env" ]; then
  source "$HOME/.secrets.env"
fi
```

### 4. Cleaned Shell History
- Backed up `.zsh_history` to `.zsh_history.bak`
- Removed lines containing `GITHUB_TOKEN`
- Reduced exposure of secrets in shell history

## Configuration Semantics

### `.user.nix` (Build-time Identity)
- Username, git email, GPG key ID
- Non-secret identity values
- Merged into Nix configuration at build time

### `~/.secrets.env` (Runtime Secrets)
- API tokens, passwords, credentials
- Sourced by shell at runtime
- Never committed to git

## Next Steps

**IMPORTANT**: Rotate the exposed GitHub token:
1. Generate new token at https://github.com/settings/tokens
2. Update `~/.secrets.env` with new token
3. Revoke old token (check `~/.config/zsh/.zsh_history.bak`)

## Testing

```bash
# Rebuild home-manager to apply zsh changes
home-manager switch --flake .

# Restart shell
exec zsh

# Verify secrets are loaded
echo $GITHUB_TOKEN
```

## Documentation

- Full proposal: `openspec/changes/secrets-in-env/proposal.md`
- Incident report: `openspec/changes/secrets-in-env/README.md`
