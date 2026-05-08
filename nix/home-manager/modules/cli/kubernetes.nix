# === KUBERNETES TOOLS ===
{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.tools.enableKubernetes {
    home.packages = with pkgs; [
      kubectl
      k9s
    ];

    programs.zsh.initContent = ''
      # kubectl shortcut with shell completion
      if command -v kubectl &>/dev/null; then
        source <(kubectl completion zsh)
        alias k=kubectl
        compdef k=kubectl
      fi
    '';
  };
}
