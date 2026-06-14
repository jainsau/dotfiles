# === PODMAN CONTAINER RUNTIME ===
{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.tools.enableMonitoring {
    home.packages = with pkgs; [
      podman
    ];

    home.shellAliases = {
      pod = "podman";
      docker = "podman";
      docker-compose = "podman compose";
    };
  };
}
