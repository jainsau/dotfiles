{ config, pkgs, ... }:

{
  # User settings
  home.username = "saurabh";
  home.homeDirectory = "/Users/saurabh";
  home.stateVersion = "24.05";

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL="en_US.UTF-8";
    PATH = "$HOME/.nix-profile/bin:$PATH";
    TERM = "xterm-256color";
    TERMINAL = "kitty";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    ZSH_TMUX_AUTOSTART = "true";
  };

  # Enable Fontconfig (for proper font rendering)
  fonts.fontconfig.enable = true;

  # Garbage Collection Optimization (weekly cleanup of old generations)
  systemd.user = {
    timers.nix-gc = {
      Unit.Description = "Garbage collect old Nix generations";
      Timer = { OnCalendar = "weekly"; Persistent = true; };
      Install.WantedBy = [ "timers.target" ];
    };
    services.nix-gc.Service.ExecStart = "${pkgs.nix}/bin/nix-collect-garbage -d";
  };

  # Package Installations
  home.packages = with pkgs; [
    eza fd htop jq ripgrep tree yq lazygit stow
    fontconfig # Ensures `fc-list` works
    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" ]; })
  ];

  # Powerlevel10k Configuration File
  home.file.".config/zsh/p10k.zsh".source = ./p10k.zsh;

  # Enable Home Manager
  programs.home-manager.enable = true;

  # Kitty Terminal
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "FiraCode Nerd Font";  # Or "MesloLGS Nerd Font"
    };
  };

  # Zsh Configuration
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtra = ''
      # Enable Powerlevel10k instant prompt (if available)
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      [[ -f ~/.config/zsh/p10k.zsh ]] && source ~/.config/zsh/p10k.zsh

      # Vi Mode & Cursor Shape Handling
      bindkey -v                            # Enable Vi mode
      export KEYTIMEOUT=1                   # Reduce delay in mode switching
      function zle-keymap-select {          # Change cursor shape based on mode
        case $KEYMAP in
          vicmd) echo -ne '\e[1 q' ;;       # Block cursor in normal mode
          viins|main) echo -ne '\e[5 q' ;;  # Beam cursor in insert mode
        esac
      }
      zle -N zle-keymap-select
      echo -ne '\e[5 q'                     # Set beam cursor on startup

      # Shortcut to Internet Man-Pages
      cs() {
        if command -v curl >/dev/null; then
          curl https://cheat.sh/{$1}
        else
          echo "curl not found. Install it to use cs function."
        fi

      # Hook DIRENV
      eval "$(direnv hook zsh)"
      }
    '';

    shellAliases = {
      g = "git";
      ga = "git add";
      gc = "git commit -m";
      gs = "git status";
      gl = "git log --oneline --graph --decorate";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      gp = "git push";
      gpl = "git pull";
      lg = "lazygit";
      ll = "eza -alh --git";
      lt = "eza -alr";
      tl = "tree -aL";
      vim = "nvim";
      cat = "bat";
    };

    # Oh My Zsh Plugins
    oh-my-zsh = {
      enable = true;
      plugins = [
        "aliases" "command-not-found" "common-aliases" "dirhistory" "git"
        "git-extras" "history" "sudo" "vi-mode" "z"
        "zsh-interactive-cd"
      ];
    };

    # Zsh Enhancements
    enableCompletion = true;
    autosuggestion.enable = true;
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];
  };

  # Tmux Configuration
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

    # Custom key bindings
    extraConfig = ''
      set -g mouse on
      set -g set-clipboard on # Fix clipboard issues

      # Auto-start `tmux-continuum`
      set -g @continuum-restore 'on'

      # Keep backtick key accessible
      bind-key "`" send-prefix

      # Split creation shortcuts
      unbind %
      bind-key v split-window -h
      unbind \"
      bind s split-window
    '';
  };

  # Direnv for Project Environment Management
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "Saurabh Jain";
    userEmail = "saurabh_jain2011@pgp.isb.edu";
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.showIcons = true; # Enable icons
      confirmOnQuit = true; # Prevent accidental quits
      keybinding = {
        universal.quit = "q"; # Quit with 'q'
        universal.return = "<esc>"; # Escape to go back
        commits.viewResetOptions = "R"; # Reset menu with 'R'
        stash.open = "s"; # Open stash menu with 's'
      };
    };
  };

  # # Python package management
  # programs.poetry = {
  #   enable = true;
  #   virtualenvs.prefer-active = true;  # Uses existing virtualenvs instead of making new ones
  #     virtualenvs.in-project = true;     # Keeps virtualenv inside project folder
  # };
  #
  # Other Useful Programs
  programs.fzf = { enable = true; enableZshIntegration = true; };
  programs.bat.enable = true;
  programs.neovim.enable = true;
}
