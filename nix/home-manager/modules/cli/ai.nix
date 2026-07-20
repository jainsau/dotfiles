{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.tools.enableAiTools;

  agent-sh-pkg = pkgs.buildNpmPackage rec {
    pname = "agent-sh";
    version = "0.15.9";
    src = pkgs.fetchFromGitHub {
      owner = "guanyilun";
      repo = "agent-sh";
      rev = "v${version}";
      hash = "sha256-ohSpd55zwB6pdooN0b9I7nZ+XYIG2uTznMvjwrKml9g=";
    };
    postPatch = ''
      cp ${./agent-sh-package-lock.json} package-lock.json
    '';
    npmDepsHash = "sha256-4PwwXmaV6ijxxMIFUYzc+qxBYcUB/6l4UaXAwmjXAD8=";
  };

  # Agent Client Protocol adapter for Pi, consumed by Neovim's agentic.nvim.
  pi-acp-pkg = pkgs.buildNpmPackage rec {
    pname = "pi-acp";
    version = "0.0.28";
    src = pkgs.fetchFromGitHub {
      owner = "svkozak";
      repo = "pi-acp";
      rev = "f9ca92d5e14ca5ed4ae3883031e2425bd517f87d";
      hash = "sha256-sGmP6HYHmz2QyACPWnM4vuhnIr8GnKLJXtj98tvTe74=";
    };
    npmDepsHash = "sha256-/k//AikjjJNUkA38O/gXh4yEk/E52+ue6BI/SwRCa8k=";
  };

in {
  config = mkIf cfg {
    home.packages = with pkgs; [
      kiro-cli
      gemini-cli
      claude-code
      codex
      pi-coding-agent
      openspec
      uv
      agent-sh-pkg
      pi-acp-pkg     # ACP adapter for Pi, used by agentic.nvim
    ];


    home.file.".agent-sh/settings.json" = {
      text = builtins.toJSON {
        defaultBackend = "pi";
      };
      force = true;
    };

    # Vendored pi-bridge: spawns `pi --mode rpc` as subprocess.
    # No npm deps — just copy the extension files.
    home.activation.setupAgentShPiBridge = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      bridge_dir="$HOME/.agent-sh/extensions/pi-bridge"
      src_dir="${./agent-sh-pi-bridge}"
      mkdir -p "$bridge_dir"

      if ! cmp -s "$src_dir/index.ts" "$bridge_dir/index.ts" 2>/dev/null; then
        cp "$src_dir/index.ts" "$bridge_dir/index.ts"
        cp "$src_dir/package.json" "$bridge_dir/package.json"
      fi
    '';

    # Override built-in subagent extension to avoid conflict with pi-subagents
    home.file.".pi/agent/extensions/index.ts" = {
      text = "// managed by home-manager: subagent provided by pi-subagents\nexport default () => ({});\n";
      force = true;
    };

    # Declarative npm extensions for Pi — package.json is the source of truth,
    # npm resolves the lockfile natively on activation.
    home.file.".pi/agent/npm/package.json" = {
      source = ./pi-extensions-package.json;
      force = true;
      onChange = ''
        ${pkgs.nodejs}/bin/npm install --prefix "$HOME/.pi/agent/npm" --no-fund --no-audit 2>/dev/null || true
      '';
    };

    # Seed rhubarb-pi's compact-config extension with an empty threshold map so
    # first-time installs do not log a missing-config error before the user opens
    # /compact-config. Use activation instead of home.file so the extension can
    # mutate the JSON normally after bootstrap.
    home.activation.seedPiCompactConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      config_dir="$HOME/.pi/agent"
      mkdir -p "$config_dir"

      if [ ! -e "$config_dir/compact-config.json" ]; then
        printf '%s\n' '{"thresholds":{}}' > "$config_dir/compact-config.json"
      fi

      # Compatibility for the historically mistyped filename seen in setup notes.
      if [ ! -e "$config_dir/compacti-config.json" ]; then
        printf '%s\n' '{"thresholds":{}}' > "$config_dir/compacti-config.json"
      fi
    '';

  };
}