{ config, pkgs, lib, ... }@args:

{
  imports = [
    ./cli/tools.nix
    ./cli/git.nix
    ./dev/tools.nix
    ./dev/direnv.nix
    ./system-tools.nix
    ./shell/zsh.nix
    ./shell/tmux.nix
  ];
}

