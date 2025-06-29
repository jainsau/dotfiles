# === FD MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.fd ];
  home.shellAliases.find = "fd";
} 