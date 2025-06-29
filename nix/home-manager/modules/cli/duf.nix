# === DUF MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.duf ];
  home.shellAliases.df = "duf";
} 