# === ZOXIDE MODULE ===
{ pkgs, ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];  # Use 'cd' instead of 'z'
  };
} 