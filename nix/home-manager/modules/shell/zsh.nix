# === BASE ZSH MODULE ===
{ pkgs, ... }:
{
  # Enable command-not-found handler
  programs.command-not-found.enable = true;



  # Starship Prompt Configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # For full configuration options, see: https://starship.rs/config/
    settings = {
      # A minimal, single-line prompt
      format = ''
        $directory$git_branch$git_status$character'';

      # Disable the newline at the start of the prompt
      add_newline = false;

      # Configure the directory module
      directory = {
        style = "bold blue";
        truncation_length = 5;
      };
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

      # Prepend sudo to current command line (ESC ESC)
      insert-sudo() {
          zle beginning-of-line;
          zle -U "sudo "
      }
      zle -N insert-sudo
      bindkey "\e\e" insert-sudo



      # Hook DIRENV
      eval "$(direnv hook zsh)"

      # Initialize completions
      autoload -U compinit
      compinit




    '';

    # Zsh Enhancements
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

  # === NAVIGATION ALIASES ===
  home.shellAliases = {
    # Directory navigation shortcuts
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
  };
}
