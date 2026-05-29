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
    navi
    markdownlint-cli2
    pay-respects
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
}
