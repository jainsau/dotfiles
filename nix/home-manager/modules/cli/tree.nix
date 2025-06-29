# === TREE MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.tree ];
  home.shellAliases.tl = "tree -aL";
} 