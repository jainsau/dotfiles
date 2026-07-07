## Design

Use a small local `buildNpmPackage` derivation in the existing AI tools module, matching the current pattern used for `pi-acp`.

The upstream source is pinned to `v0.15.9`. Because upstream does not ship a package lock in the GitHub source, include a generated `package-lock.json` next to the module and copy it during `postPatch`.

The package already contains the bundled `examples/extensions/pi-bridge` workspace and its dependencies in the Nix-built node_modules tree, so Home Manager can expose that directory directly as `~/.agent-sh/extensions/pi-bridge`. No separate npm install step is needed.
