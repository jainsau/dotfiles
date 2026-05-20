# Secrets Management: Move Runtime Secrets to ~/.secrets.env

**Status**: Implemented  
**Created**: 2025-05-20  
**Type**: Security Fix

## Problem

Runtime secrets (API tokens, credentials) were being manually exported in shell sessions and stored in shell history, creating security risks:

1. `GITHUB_TOKEN` was visible in `~/.config/zsh/.zsh_history`
2. No standardized location for runtime secrets
3. Confusion between build-time config (`.user.nix`) and runtime secrets (environment variables)

## Solution

Create `~/.secrets.env` for runtime secrets and source it from zsh configuration.

### Implementation

1. **Created `~/.secrets.env`**:
   - Stores runtime secrets (API tokens, credentials)
   - `chmod 600` for user-only access
   - Never committed to git

2. **Updated `nix/home-manager/modules/shell/zsh.nix`**:
   - Added conditional sourcing of `~/.secrets.env`
   - Placed after PATH setup, before Kiro CLI post block

3. **Cleaned shell history**:
   - Removed `GITHUB_TOKEN` entries from `.zsh_history`
   - Created backup before modification

### File Structure

```
~/.secrets.env          # Runtime secrets (gitignored by default)
.user.nix               # Build-time identity (gitignored, in repo)
nix/user.nix            # Build-time template (committed)
```

## Semantics

### `.user.nix` (build-time identity)
- Username, git email, GPG key ID
- Non-secret identity values
- Merged into Nix configuration at build time
- Used by home-manager modules

### `~/.secrets.env` (runtime secrets)
- API tokens, passwords, private keys
- Actual secrets that should never be committed
- Sourced by shell at runtime
- Used by CLI tools, MCP servers, etc.

### When to use which:

| Value Type | Location | Example |
|------------|----------|---------|
| Identity (public) | `.user.nix` | `gitEmail`, `gpgKey`, `username` |
| Runtime secret | `~/.secrets.env` | `GITHUB_TOKEN`, `ANTHROPIC_API_KEY` |
| Build-time secret | agenix/sops-nix | Encrypted secrets in git (future) |

## Security Improvements

1. ✅ Secrets no longer in shell history
2. ✅ Standardized location for secrets
3. ✅ Proper file permissions (600)
4. ✅ Clear separation: identity vs secrets
5. ✅ `~/.secrets.env` gitignored by default (not in repo)

## Migration Guide

For existing users:

```bash
# 1. Create secrets file
cat > ~/.secrets.env << 'EOF'
# Secrets and API tokens
export GITHUB_TOKEN="your_token_here"
export ANTHROPIC_API_KEY="your_key_here"
EOF

# 2. Set permissions
chmod 600 ~/.secrets.env

# 3. Rebuild home-manager
home-manager switch --flake .

# 4. Clean shell history (optional)
sed -i.bak '/GITHUB_TOKEN\|ANTHROPIC_API_KEY/d' ~/.config/zsh/.zsh_history

# 5. Restart shell
exec zsh
```

## Testing

```bash
# Verify secrets are loaded
echo $GITHUB_TOKEN

# Verify MCP server can access it
cat ~/.0xkobold/mcp.json | grep GITHUB_TOKEN
```

## Related

- See `openspec/specs/secrets-design.md` for agenix integration (future)
- See `AGENTS.md` for "do not commit secrets" guidance
