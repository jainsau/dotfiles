# === TMUX MODULE ===
{ config, pkgs, ... }:

{
  # === Tmux Configuration ===
  programs.tmux = {
    enable = true;
    prefix = "`";
    keyMode = "vi";
    escapeTime = 10; # Improve vi mode response time

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      sensible
      continuum
      tmux-fzf
      yank
    ];

    # --- Custom key bindings and extra config ---
    extraConfig = ''
      set -g mouse on
      set -g set-clipboard on # Fix clipboard issues

      # Auto-start `tmux-continuum`
      set -g @continuum-restore 'on'

      # Keep backtick key accessible
      bind-key "`" send-prefix

      # Add zsh as login shell
      set -g default-shell ${pkgs.zsh}/bin/zsh
      set -g default-command "${pkgs.zsh}/bin/zsh -l"

      # Split creation shortcuts
      unbind %
      bind-key v split-window -h
      unbind "\""
      bind s split-window
    '';
  };
}
