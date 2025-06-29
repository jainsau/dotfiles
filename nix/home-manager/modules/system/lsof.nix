# === LSOF MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.lsof ];
  home.shellAliases.ports = "lsof -i -P -n | grep LISTEN";
  home.shellAliases.listening = "lsof -i -P -n | grep LISTEN";
} 