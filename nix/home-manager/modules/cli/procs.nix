# === PROCS MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.procs ];
  home.shellAliases.ps = "procs";
} 