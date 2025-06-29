# === DELTA MODULE ===
{ pkgs, ... }:
{
  # === INSTALL DELTA PACKAGE ===
  home.packages = [ pkgs.delta ];
  
  # === CONFIGURE DELTA THROUGH GIT ===
  programs.git.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "TwoDark";
    };
  };
} 