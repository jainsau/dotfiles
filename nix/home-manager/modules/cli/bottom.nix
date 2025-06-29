# === BOTTOM MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.bottom ];
  home.shellAliases.top = "bottom";
} 