{ config, pkgs, lib, ... }:

{
  # === FONTS AND TYPOGRAPHY ===
  home.packages = with pkgs; [
    # Nerd Fonts for terminal icons
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg

    # Font utilities
    fontconfig   # Ensures fc-list works
  ];

  # === FONT CONFIGURATION ===
  fonts.fontconfig.enable = true;
}
