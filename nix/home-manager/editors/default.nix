# === EDITORS AGGREGATOR ===
{ config, lib, pkgs, ... }:

with lib;
{
  options.editors = {
    enableVSCode = mkEnableOption "Enable VS Code setup";
    enableNeovim = mkEnableOption "Enable Neovim setup";
  };

  imports = [
    ./vscode
    ./nvim
  ];

  config.home.sessionVariables = {
    EDITOR = "nvim";
  };
}
