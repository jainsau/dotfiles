# === LOLCAT MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.lolcat ];
  home.shellAliases.rainbow = "lolcat";
} 