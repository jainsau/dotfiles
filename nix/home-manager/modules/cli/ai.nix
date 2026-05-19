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
    ];

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
