# Proposal: Bootstrap Script Refactor

## Problem

`install.sh` has several gaps:
- Not idempotent — re-running adds duplicate sourcing lines
- Phase 2 shows switch commands but doesn't execute them
- Hardcoded Nix/shell paths
- No `--phase` flag — user must manually re-run after shell restart
- No error recovery

## Proposed Changes

### Phase detection
```bash
if command -v nix &>/dev/null; then
  run_phase_2
else
  run_phase_1
fi
```

### Auto-switch
Add `--auto-switch` flag — after Phase 2 setup, automatically run:
- macOS: `darwin-rebuild switch --flake .`
- Linux: `home-manager switch --flake .`

### Idempotency guards
Before appending to `.zshrc`/`.zprofile`, check if line already exists.

### Pre-switch validation
Run `nix flake check` before switch to catch config errors early.

## Files Changed

- `install.sh` — primary changes
- `README.md` — updated bootstrap instructions

## Relationship to Go CLI

This refactor is a stepping stone. If/when `go-cli-wrapper` is implemented, `install.sh` is replaced entirely. These improvements make the bash script more robust in the interim.
