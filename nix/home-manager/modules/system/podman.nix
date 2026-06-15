# === PODMAN CONTAINER RUNTIME ===
{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.tools.enableMonitoring {
    home.packages = with pkgs; [
      podman
    ];

    home.shellAliases = {
      p = "podman";
    };

    programs.zsh.initContent = ''
      typeset -gA shell_command_descriptions
      shell_command_descriptions[p]="Podman"
    '';
  };
}
