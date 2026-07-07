# === PODMAN CONTAINER RUNTIME ===
{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.tools.enableMonitoring {
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
      podman
      podman-compose
    ]);

    home.shellAliases = {
      p = "podman";
    };

    programs.zsh.initContent = ''
      typeset -gA shell_command_descriptions
      shell_command_descriptions[p]="Podman"
    '';
  };
}
