# === RIPGREP MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.ripgrep ];
  home.shellAliases.grep = "rg";
} 