# === DUST MODULE ===
{ pkgs, ... }:
{
  home.packages = [ pkgs.dust ];
  home.shellAliases.du = "dust";
} 