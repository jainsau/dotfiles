# === BAT MODULE ===
{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
      style = "numbers,changes,header";
    };
  };
  home.shellAliases.cat = "bat";
} 