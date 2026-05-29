{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.tools.enableAiTools;
in {
  config = mkIf cfg {
    home.packages = with pkgs; [
      kiro-cli
      gemini-cli
      claude-code
      pi-coding-agent
      openspec
      uv
    ];

    home.activation.setupGraphify = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Install graphifyy via uv and set it up for Pi
      if [ "$(uname)" = "Darwin" ] && [ -x /usr/bin/xcrun ]; then
        export SDKROOT=$(/usr/bin/xcrun --show-sdk-path)
      fi
      $DRY_RUN_CMD ${pkgs.uv}/bin/uv tool install graphifyy || true
      if [ -f "$HOME/.local/bin/graphify" ]; then
        $DRY_RUN_CMD "$HOME/.local/bin/graphify" install --platform pi || true
      fi
    '';

    # Model Context Protocol (MCP) Configuration for Pi and other MCP clients
    home.file.".0xkobold/mcp.json".text = builtins.toJSON {
      servers = [
        {
          name = "github";
          transport = {
            type = "stdio";
            command = "npx";
            args = [ "-y" "@modelcontextprotocol/server-github" ];
            env = {
              GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_TOKEN}";
            };
          };
          enabled = true;
          autoReconnect = true;
        }
      ];
    };

    # Override built-in subagent extension to avoid conflict with pi-subagents (managed via kit.yml)
    home.file.".pi/agent/extensions/index.ts" = {
      text = "// managed by home-manager: subagent provided by pi-subagents (kit.yml)\nexport default () => ({});\n";
      force = true;
    };
  };
}
