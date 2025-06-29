# === PODMAN MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.podman ];
  home.shellAliases.pod = "podman";
} 