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
        BUFFER="$EDITOR +$line $file"
        zle accept-line
      fi
      zle reset-prompt
    }
    zle -N fzf-rg-widget
    bindkey '^F' fzf-rg-widget

    # Alias/function picker (Alt+A): insert selected command into the prompt
    typeset -gA shell_command_descriptions
    _fzf_shell_command_select() {
      {
        alias | while IFS= read -r line; do
          local name="''${line%%=*}"
          printf 'alias\t%s\t%s\t%s\n' "$name" "''${shell_command_descriptions[$name]-}" "''${line#*=}"
        done

        local fn
        for fn in fe frg fcd fgl fbr fkill fenv fjobs; do
          (( $+functions[$fn] )) && printf 'function\t%s\t%s\t%s\n' "$fn" "''${shell_command_descriptions[$fn]-}" "$(whence -f "$fn" | sed -n '1p')"
        done
      } |
        sort |
        fzf --ansi --delimiter=$'\t' --with-nth=1,2,3 \
          --preview 'printf "%s\n" {4..}' \
          --preview-window=wrap |
        cut -f2
    }

    # Callable fallback for testing/discovery: prints the selected command name.
    fa() {
      _fzf_shell_command_select
    }

    fzf-shell-command-widget() {
      emulate -L zsh
      local name
      name="$(_fzf_shell_command_select)"
      [[ -n "$name" ]] && LBUFFER+="$name"
      zle reset-prompt
    }
    zle -N fzf-shell-command-widget
    for keymap in emacs viins vicmd; do
      bindkey -M "$keymap" '^[a' fzf-shell-command-widget
      bindkey -M "$keymap" '^[A' fzf-shell-command-widget
    done

    # Job picker (Alt+J): list current shell jobs and resume the selected one
    _fzf_job_select() {
      emulate -L zsh
      typeset -g FZF_JOB_SELECTED
      local jobs_file
      FZF_JOB_SELECTED=
      jobs_file="$(mktemp "''${TMPDIR:-/tmp}/fzf-jobs.XXXXXX")" || return 1
      jobs -l >| "$jobs_file"
      if [[ ! -s "$jobs_file" ]]; then
        rm -f "$jobs_file"
        return 1
      fi
      FZF_JOB_SELECTED="$(fzf --ansi --no-sort --header='Select job to resume' --preview 'printf "%s\n" {}' < "$jobs_file")"
      rm -f "$jobs_file"
      [[ -n "$FZF_JOB_SELECTED" ]]
    }

    shell_command_descriptions[fjobs]="Pick and resume a shell job"

    fjobs() {
      emulate -L zsh
      local job_id
      _fzf_job_select || return
      job_id="''${FZF_JOB_SELECTED%%]*}"
      job_id="''${job_id#\[}"
      [[ -n "$job_id" ]] && fg "%$job_id"
    }

    fzf-resume-job-widget() {
      emulate -L zsh
      local job_id
      if _fzf_job_select; then
        job_id="''${FZF_JOB_SELECTED%%]*}"
        job_id="''${job_id#\[}"
        if [[ -n "$job_id" ]]; then
          BUFFER="fg %$job_id"
          zle accept-line
          return
        fi
      fi
      zle reset-prompt
    }
    zle -N fzf-resume-job-widget
    for keymap in emacs viins vicmd; do
      bindkey -M "$keymap" '^[j' fzf-resume-job-widget
      bindkey -M "$keymap" '^[J' fzf-resume-job-widget
    done

    # navi: interactive cheatsheet (Ctrl+G)
    eval "$(navi widget zsh)"
  '';
}
