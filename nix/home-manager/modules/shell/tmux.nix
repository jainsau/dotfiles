# === TMUX MODULE ===
{ config, pkgs, lib, ... }:

let
  # TMUX Auto-start Configuration (OMZ-style)
  tmuxConfig = {
    # Auto-start tmux in new shells
    autoStart = true;
    # Only start once per login (prevents nested sessions)
    autoStartOnce = true;
    # Auto-connect to existing sessions
    autoConnect = true;
    # Fix terminal issues
    fixTerm = true;
    # Default session name
    defaultSession = "main";
    # Start tmux over SSH
    startOnSSH = true;
    # Start tmux in local terminals
    startOnLocal = true;
  };
in
with lib;
{
  config = mkIf config.tools.enableTmux {
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
      yank
    ];

    # --- Custom key bindings and extra config ---
    extraConfig = ''
      set -g mouse on
      set -g set-clipboard on # Fix clipboard issues
      set -g extended-keys on
      set -g extended-keys-format csi-u

      # Auto-start `tmux-continuum`
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '5'

      # Keep backtick key accessible
      bind-key "`" send-prefix

      # Let tmux use the default shell from the environment
      set -g default-shell $SHELL
      set -g default-command "$SHELL -l"

      # Split creation shortcuts
      unbind %
      bind-key v split-window -h
      unbind "\""
      bind s split-window

      # Nested tmux toggle — F12 suspends local key capture to pass keys to inner session
      bind -T root F12  set prefix None \; set key-table off
      bind -T off  F12  set prefix "`" \; set -u key-table

      # === Popups ===
      bind-key / display-popup -E -w 70% -h 60% -T "Shell" "zsh"
    '';
  };

  # === TMUX Auto-start Logic (OMZ-style) ===
  home.sessionVariables = {
    # TMUX auto-start configuration
    ZSH_TMUX_AUTOSTART = if tmuxConfig.autoStart then "true" else "false";
    ZSH_TMUX_AUTOSTART_ONCE = if tmuxConfig.autoStartOnce then "true" else "false";
    ZSH_TMUX_AUTOCONNECT = if tmuxConfig.autoConnect then "true" else "false";
    ZSH_TMUX_FIXTERM = if tmuxConfig.fixTerm then "true" else "false";
    ZSH_TMUX_DEFAULT_SESSION = tmuxConfig.defaultSession;
    ZSH_TMUX_START_ON_SSH = if tmuxConfig.startOnSSH then "true" else "false";
    ZSH_TMUX_START_ON_LOCAL = if tmuxConfig.startOnLocal then "true" else "false";
  };

  # Add the auto-start logic to zsh
  programs.zsh.initContent = ''
    # === TMUX Auto-start Logic (OMZ-style) ===
    _zsh_tmux_plugin_run() {
      # Only run if tmux auto-start is enabled
      [[ "$ZSH_TMUX_AUTOSTART" != "true" ]] && return 0

      # Don't run if we're already in tmux
      [[ -n "$TMUX" ]] && return 0

      # Don't run if we're in a nested shell
      [[ -n "$TMUX_PLUGIN_MANAGER_PATH" ]] && return 0

      # Check if we should start tmux
      local should_start=false

      # Start on SSH if enabled
      if [[ "$ZSH_TMUX_START_ON_SSH" == "true" ]] && [[ -n "$SSH_CONNECTION" ]]; then
        should_start=true
      fi

      # Start on local terminals if enabled
      if [[ "$ZSH_TMUX_START_ON_LOCAL" == "true" ]] && [[ -z "$SSH_CONNECTION" ]]; then
        should_start=true
      fi

      # Don't start if we're in certain terminal types
      if [[ "$TERM_PROGRAM" == "tmux" ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        should_start=false
      fi

      if [[ "$should_start" == "true" ]]; then
        # Fix terminal issues if enabled
        if [[ "$ZSH_TMUX_FIXTERM" == "true" ]]; then
          export TERM="screen-256color"
        fi

        # Create or attach to session
        if [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]]; then
          # Try to attach to existing session
          if tmux has-session -t "$ZSH_TMUX_DEFAULT_SESSION" 2>/dev/null; then
            tmux attach-session -t "$ZSH_TMUX_DEFAULT_SESSION"
          else
            tmux new-session -s "$ZSH_TMUX_DEFAULT_SESSION"
          fi
        else
          # Always create new session
          tmux new-session -s "$ZSH_TMUX_DEFAULT_SESSION"
        fi
      fi
    }

    # Run tmux auto-start logic
    _zsh_tmux_plugin_run
  '';
  };
}
