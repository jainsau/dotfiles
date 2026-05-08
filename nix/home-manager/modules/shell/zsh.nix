# === CORE ZSH CONFIG ===
{ config, pkgs, lib, ... }:
{
  # Override ~/.zshenv: source HM session vars but don't set ZDOTDIR.
  home.file.".zshenv".text = lib.mkForce ''
    . "${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh"
  '';

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = ''
      # Nix
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi
      # End Nix

      # Homebrew (skip on Linux and when not installed)
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi

      # Kiro CLI pre block. Keep at the top of this file.
      if [[ -f "$HOME/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]]; then
        builtin source "$HOME/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
      elif [[ -f "''${XDG_DATA_HOME:-$HOME/.local/share}/kiro-cli/shell/zshrc.pre.zsh" ]]; then
        builtin source "''${XDG_DATA_HOME:-$HOME/.local/share}/kiro-cli/shell/zshrc.pre.zsh"
      fi

      # Zsh Options
      setopt AUTO_CD
      setopt AUTO_PUSHD

      # Local user binaries
      export PATH="$HOME/.local/bin:$PATH"

      # Kiro CLI post block. Keep at the bottom of this file.
      if [[ -f "$HOME/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]]; then
        builtin source "$HOME/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
      elif [[ -f "''${XDG_DATA_HOME:-$HOME/.local/share}/kiro-cli/shell/zshrc.post.zsh" ]]; then
        builtin source "''${XDG_DATA_HOME:-$HOME/.local/share}/kiro-cli/shell/zshrc.post.zsh"
      fi
    '';

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };

    plugins = [
      {
        name = "zsh-interactive-cd";
        src = pkgs.fetchFromGitHub {
          owner = "mrjohannchang";
          repo = "zsh-interactive-cd";
          rev = "e7d4802aa526ec069dafec6709549f4344ce9d4a";
          sha256 = "sha256-j23Ew18o7i/7dLlrTu0/54+6mbY8srsptfrDP/9BI/Q=";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];
  };

  # Navigation aliases
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
  };
}
