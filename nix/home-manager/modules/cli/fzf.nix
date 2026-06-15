# === FZF — Fuzzy Finder ===
{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Default file search (used by fzf without arguments)
    defaultCommand = "fd --type f --hidden --follow --exclude .git";

    # Ctrl+T: paste selected file path
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range :300 {}'"
    ];

    # Alt+C: cd into selected directory
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=2 --color=always {}'"
    ];

    # Ctrl+R: search command history (already built-in, just style it)
    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];

    defaultOptions = [
      "--height 40%"
      "--border"
      "--layout=reverse"
      "--info=inline"
      "--bind 'ctrl-/:toggle-preview'"
    ];
  };

  programs.zsh.initContent = ''
    # fzf-powered helpers
    typeset -gA shell_command_descriptions
    shell_command_descriptions[fe]="Open selected file in editor"
    shell_command_descriptions[frg]="Search file contents and open match"
    shell_command_descriptions[fcd]="cd into selected directory"
    shell_command_descriptions[fgl]="Browse git log and checkout commit"
    shell_command_descriptions[fbr]="Switch git branch interactively"
    shell_command_descriptions[fkill]="Select processes to kill"
    shell_command_descriptions[fenv]="Browse environment variables"

    # Interactive git log browser → checkout
    fgl() {
      git log --oneline --graph --decorate --color=always |
        fzf --ansi --no-sort --preview 'git show --color=always {2}' |
        awk '{print $2}' | xargs -r git checkout
    }

    # Interactive git branch switcher
    fbr() {
      git branch --all --color=always |
        fzf --ansi --preview 'git log --oneline --graph --color=always {1}' |
        sed 's/^[* ]*//' | sed 's|remotes/origin/||' | xargs -r git checkout
    }

    # Interactive process killer
    fkill() {
      ps aux |
        fzf --header='Select process to kill' --multi |
        awk '{print $2}' | xargs -r kill -9
    }

    # Interactive environment variable viewer
    fenv() {
      env | sort | fzf --preview 'echo {}' --preview-window=wrap
    }

    # Fuzzy cd into any subdirectory
    fcd() {
      local dir
      dir=$(fd --type d --hidden --follow --exclude .git | fzf --preview 'eza --tree --level=2 --color=always {}')
      [[ -n "$dir" ]] && cd "$dir"
    }

    # Fuzzy open file in $EDITOR
    fe() {
      local file
      file=$(fzf --preview 'bat --color=always --style=numbers --line-range :300 {}')
      [[ -n "$file" ]] && "$EDITOR" "$file"
    }

    # Fuzzy grep: search file contents with ripgrep + fzf, open result in $EDITOR
    frg() {
      local file line
      local result
      result=$(rg --color=always --line-number --no-heading "''${1:-}" "''${2:-.}" |
        fzf --ansi --delimiter ':' \
          --preview 'bat --color=always --style=numbers --highlight-line {2} -- {1}' \
          --preview-window '+{2}-5')
      file=$(echo "$result" | cut -d: -f1)
      line=$(echo "$result" | cut -d: -f2)
      [[ -n "$file" ]] && "$EDITOR" "+$line" "$file"
    }
  '';
}
