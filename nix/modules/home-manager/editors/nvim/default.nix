{ config, lib, pkgs, ... }:
with lib;
{
  config = mkIf config.editors.enableNeovim {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;

      # Add additional packages you need for your config
      extraPackages = with pkgs; [
        ruby
        lua5_1
        luarocks
        ripgrep
        fd
        tree-sitter
      ];
    };

    # Symlink ./config to ~/.config/nvim
    xdg.configFile."nvim".source = ./.;  # assumes init.lua and lua/ live here
  };
}

