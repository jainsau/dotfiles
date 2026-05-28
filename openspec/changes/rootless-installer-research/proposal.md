## Why

Currently, installing Nix requires `sudo` privileges to create and mount the `/nix` volume. This is often a blocker for users on corporate machines, restricted environments, or shared systems where root access is unavailable.

We want to explore creating a completely rootless, unprivileged installer that bypasses the need for `sudo` entirely, making dotfiles bootstrapping seamless on any machine.

## What Changes

This is an exploratory research phase. The notes and findings will inform either the `install.sh` bootstrap script refactor or the upcoming `go-cli-wrapper`.

### Key Research Areas

1. **Devbox Wrapper Approach**
   - We should learn from [Jetpack devbox](https://github.com/jetify-com/devbox) on how they wrap the Nix installer. They have built an excellent onboarding experience that abstracts away the underlying Nix complexity.
   - Investigate their fallback mechanisms, curl-to-bash payload delivery, and how they handle edge cases during Nix provisioning.

2. **nix-portable for Rootless Execution**
   - Look into [nix-portable](https://github.com/DavHau/nix-portable) to solve the `sudo` requirement.
   - `nix-portable` enables running Nix without installation or root privileges, which could serve as the perfect bootstrap engine before falling back to a full system installation or running entirely portable.

3. **proot and $HOME/nix Displacement**
   - Look at namespace/chroot primitives like `proot` to displace the hardcoded `/nix` path to `$HOME/nix`.
   - By mapping `/nix` to a user-owned directory in `$HOME`, we can trick Nix into installing and building packages without requiring root-owned directories at the root filesystem level.

## Capabilities

### New Capabilities
- `rootless-installer-research`: Exploration of unprivileged installation methods for Nix and dotfiles bootstrapping.

### Modified Capabilities

## Impact

- Could completely redesign the `install.sh` bootstrapping process.
- May inform the architecture of the Go CLI wrapper.
- Success here would unlock dotfiles usage on locked-down corporate macOS/Linux laptops.