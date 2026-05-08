# === ZSH KEYBINDINGS & ZLE WIDGETS ===
{ ... }:
{
  programs.zsh.initContent = ''
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

    # Edit command line in $EDITOR (Ctrl+X Ctrl+E in insert mode, v in normal mode)
    autoload -Uz edit-command-line
    zle -N edit-command-line
    bindkey '^X^E' edit-command-line
    bindkey -M vicmd 'v' edit-command-line

    # Prepend sudo to current/previous command (Ctrl+S)
    insert-sudo() {
      if [[ -z "$BUFFER" ]]; then
        BUFFER="sudo $(fc -ln -1)"
      elif [[ "$BUFFER" != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
      fi
      CURSOR=$#BUFFER
    }
    zle -N insert-sudo
    stty -ixon
    bindkey '^S' insert-sudo

    # navi: interactive cheatsheet (Ctrl+G)
    eval "$(navi widget zsh)"
  '';
}
