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

    # Ripgrep + fzf interactive search (Ctrl+F)
    fzf-rg-widget() {
      local result file line
      result=$(rg --color=always --line-number --no-heading "" . 2>/dev/null |
        fzf --ansi --disabled \
          --bind "change:reload:rg --color=always --line-number --no-heading {q} . 2>/dev/null || true" \
          --delimiter ':' \
          --preview 'bat --color=always --style=numbers --highlight-line {2} -- {1}' \
          --preview-window '+{2}-5')
      file=$(echo "$result" | cut -d: -f1)
      line=$(echo "$result" | cut -d: -f2)
      if [[ -n "$file" ]]; then
        BUFFER="''${EDITOR:-vim} +$line $file"
        zle accept-line
      fi
      zle reset-prompt
    }
    zle -N fzf-rg-widget
    bindkey '^F' fzf-rg-widget

    # navi: interactive cheatsheet (Ctrl+G)
    eval "$(navi widget zsh)"
  '';
}
