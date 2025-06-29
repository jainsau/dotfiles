# === MARKDOWNLINT MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.nodePackages.markdownlint-cli ];
} 