{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.tools.enableAiTools;

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
      pi-coding-agent
      openspec
      uv
      pi-acp-pkg     # ACP adapter for Pi, used by agentic.nvim
    ];


    # Override built-in subagent extension to avoid conflict with pi-subagents (managed via kit.yml)
    home.file.".pi/agent/extensions/index.ts" = {
      text = "// managed by home-manager: subagent provided by pi-subagents (kit.yml)\nexport default () => ({});\n";
      force = true;
    };

  };
}