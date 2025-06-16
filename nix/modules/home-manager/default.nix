{ config, pkgs, ... }@args:

let
  username = args.username;
  homeDirectory = args.homeDirectory;
  gitUser = args.gitUser;
  gitEmail = args.gitEmail;
in {
  # Importing language specific modules
  imports = [
    ./editors
    ./languages/python.nix
  ];

  home.username = args.username;
  home.homeDirectory = args.homeDirectory;
  home.stateVersion = "24.05";

  # Environment variables
  home.sessionVariables = {
    DIRENV_LOG_FORMAT="";
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL="en_US.UTF-8";
    PATH = "$HOME/.nix-profile/bin:$PATH";
    TERM = "xterm-256color";
    TERMINAL = "kitty";
    ZSH_TMUX_AUTOSTART = "true";    # Auto-starts tmux when shell launches
    ZSH_TMUX_AUTOCONNECT = "true";  # Don't close the shell if you exit tmux
    ZSH_TMUX_AUTOQUIT = "false";    # Attaches to existing tmux session if available
    ZSH_TMUX_FIXTERM = "true";      # Fix $TERM inside tmux to avoid comatibility issues
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
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
    eza fd htop jq ripgrep tree
    yq lazygit stow pstree nmap
    nerd-fonts.fira-code nerd-fonts.meslo-lg fontconfig # Ensures `fc-list` works
    nodejs_20 nodePackages.markdownlint-cli
    go nil
    rustc cargo
  ];

  programs.home-manager.enable = true;

  editors = {
    enableVSCode = true;
    enableNeovim = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "FiraCode Nerd Font";  # Or "MesloLGS Nerd Font"
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initContent = ''
      # Nix
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi
      # End Nix

      # Homebrew (Apple Silicon)
      eval "$(/opt/homebrew/bin/brew shellenv)"

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
        "git-extras" "history" "sudo" "vi-mode" "z" "tmux"
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
  home.file.".config/zsh/p10k.zsh".source = ./p10k.zsh;

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

      # Add zsh as login shell
      set -g default-shell ${pkgs.zsh}/bin/zsh
      set -g default-command "${pkgs.zsh}/bin/zsh -l"

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

    stdlib = ''
      layout_poetry() {
        PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
        if [[ ! -f "$PYPROJECT_TOML" ]]; then
            log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
            poetry init
        fi

        if [[ -d ".venv" ]]; then
            VIRTUAL_ENV="$(pwd)/.venv"
        else
            VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)
        fi

        if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
            log_status "No virtual environment exists. Executing \`poetry install\` to create one."
            poetry install
            VIRTUAL_ENV=$(poetry env info --path)
        fi

        PATH_add "$VIRTUAL_ENV/bin"
        export POETRY_ACTIVE=1
        export VIRTUAL_ENV
      }
    '';
  };

  # Git Configuration
  programs.git = {
    enable = true;
    userName = args.gitUser;
    userEmail = args.gitEmail;
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

  # Other Useful Programs
  programs.fzf = { enable = true; enableZshIntegration = true; };
  programs.bat.enable = true;
}
