# === JUST MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.just ];
  home.shellAliases.j = "just";
} 