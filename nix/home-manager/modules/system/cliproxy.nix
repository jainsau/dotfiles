{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.tools.enableCLIProxy;
in {
  config = mkIf cfg {
    # Provide handy scripts for manual control
    home.packages = [
      (pkgs.writeShellScriptBin "cliproxy-up" ''
        #!/usr/bin/env bash
        echo "Starting CLIProxyAPIPlus via Podman (Local TCP)..."
        
        # Ensure podman machine is running on macOS before starting
        if [[ "$(uname)" == "Darwin" ]]; then
          podman machine start 2>/dev/null || true
        fi
        
        # Create a default config file to ensure it starts properly
        mkdir -p ~/.cliproxy
        cat > ~/.cliproxy/config.yaml << 'EOF'
port: 8317
host: "0.0.0.0"
auth-dir: "/app/data"
remote-management:
  allow-remote: true
  secret-key: 'admin'
api-keys: []
kiro:
  - token-file: "~/.aws/sso/cache/kiro-auth-token-cli.json"
EOF
        
        # Bind to 127.0.0.1 so it's not exposed to the local network
        podman run -d --name cliproxy --replace \
          -p 127.0.0.1:8317:8317 \
          -v ~/.cliproxy/config.yaml:/CLIProxyAPI/config.yaml \
          -v ~/.cliproxy:/app/data \
          -v ~/.aws:/root/.aws \
          kaitranntt/cli-proxy-api-plus:latest
        
        echo "CLIProxyAPIPlus is running on http://127.0.0.1:8317"
        echo "Open http://127.0.0.1:8317/management.html to configure your API keys."
      '')
      (pkgs.writeShellScriptBin "cliproxy-down" ''
        #!/usr/bin/env bash
        podman stop cliproxy || true
        podman rm cliproxy || true
        echo "CLIProxyAPIPlus stopped."
      '')
      (pkgs.writeShellScriptBin "cliproxy-logs" ''
        #!/usr/bin/env bash
        podman logs -f cliproxy
      '')
    ];

    # Linux Systemd User Service
    systemd.user.services.cliproxy = mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "CLIProxyAPIPlus Podman Container";
        After = [ "network.target" ];
      };
      Service = {
        ExecStartPre = "-${pkgs.podman}/bin/podman rm -f cliproxy";
        ExecStart = "${pkgs.podman}/bin/podman run --name cliproxy -p 127.0.0.1:8317:8317 -v %h/.cliproxy/config.yaml:/CLIProxyAPI/config.yaml -v %h/.cliproxy:/app/data -v %h/.aws:/root/.aws kaitranntt/cli-proxy-api-plus:latest";
        ExecStop = "${pkgs.podman}/bin/podman stop cliproxy";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # macOS Launchd Agent
    launchd.agents.cliproxy = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.bash}/bin/bash" "-c"
          "PATH=${pkgs.podman}/bin:$PATH && podman machine start 2>/dev/null || true && podman rm -f cliproxy || true && podman run --name cliproxy -p 127.0.0.1:8317:8317 -v ~/.cliproxy/config.yaml:/CLIProxyAPI/config.yaml -v ~/.cliproxy:/app/data -v ~/.aws:/root/.aws kaitranntt/cli-proxy-api-plus:latest"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/cliproxy.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/cliproxy.err";
      };
    };
  };
}
