{ config, pkgs, lib, ... }:
with lib;
let
  # Determine correct VS Code config path based on OS
  vscodeConfigDir = if pkgs.stdenv.isDarwin
                      then "${config.home.homeDirectory}/Library/Application Support/Code/User"
                      else "${config.home.homeDirectory}/.config/Code/User";

  vscodeFiles = ./.;
in {
  config = mkIf config.editors.enableVSCode {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        github.copilot
        ms-python.python
        esbenp.prettier-vscode
        eamodio.gitlens
        vscodevim.vim
      ];
    };

    home.file = {
      "${vscodeConfigDir}/settings.json".source = vscodeFiles + "/settings.json";
      "${vscodeConfigDir}/keybindings.json".source = vscodeFiles + "/keybindings.json";
    # "${vscodeConfigDir}/snippets".source = vscodeFiles + "/snippets";
    };
  };
}

