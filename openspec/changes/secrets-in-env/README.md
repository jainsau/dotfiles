# Security Fix: Exposed GITHUB_TOKEN

**Incident**: 2025-05-20  
**Severity**: High  
**Status**: Remediated

## What Happened

During a routine code review, a `GITHUB_TOKEN` was found:
1. Exposed in shell history (`~/.config/zsh/.zsh_history`)
2. Manually exported in shell sessions
3. No standardized secrets management

## Immediate Actions Taken

1. ✅ Created `~/.secrets.env` with proper permissions (600)
2. ✅ Moved `GITHUB_TOKEN` to `~/.secrets.env`
3. ✅ Updated zsh config to source secrets file
4. ✅ Removed token from shell history
5. ✅ Added `.secrets.env` to `.gitignore`
6. ✅ Documented in openspec

## Token Status

**Action Required**: Rotate the exposed token

```bash
# 1. Generate new token at https://github.com/settings/tokens
# 2. Update ~/.secrets.env with new token
# 3. Revoke old token (found in shell history backup)
```

## Prevention

- Secrets now in `~/.secrets.env` (gitignored, chmod 600)
- Shell history cleaned
- Clear documentation: `.user.nix` for identity, `~/.secrets.env` for secrets
- Added to standing instructions for AI agents

## Lessons Learned

1. **AI agents should flag exposed secrets immediately** - not just answer questions about them
2. **Separate identity from secrets** - `.user.nix` vs `~/.secrets.env`
3. **Shell history is not secure** - use dedicated secrets files
4. **Document security patterns** - make it obvious where secrets belong
