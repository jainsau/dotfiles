{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    bottom
    duf
    dust
    eza
    fd
    htop
    hyperfine
    jq
    opencode
    procs
    pstree
    ripgrep
    tealdeer
    tokei
    tree
    yq
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
