{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    yq
    tokei
    hyperfine
    tealdeer
    htop
    pstree
    fd
    ripgrep
    bat
    eza
    dust
    duf
    procs
    bottom
    tree
    zoxide
  ];

  home.shellAliases = {
    cat = "bat";
    grep = "rg";
    find = "fd";
    du = "dust";
    df = "duf";
    ps = "procs";
    top = "bottom";
    ll = "eza -l --git";
    l = "eza -l";
    la = "eza -la --git";
    tl = "tree -aL";
  };

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