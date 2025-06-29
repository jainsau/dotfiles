# === FZF MODULE ===
{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--preview 'bat --color=always --style=numbers --line-range :500 {}'"
    ];
  };
} 