{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    duf
    dust
    eza
    fd
    btop
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
    top = "btop";
    ll = "eza -l --git";
    l = "eza -l";
    la = "eza -la --git";
    t = "tree -aL";
  };

  programs.zsh.initContent = ''
    typeset -gA shell_command_descriptions
    shell_command_descriptions[cat]="Show file with bat"
    shell_command_descriptions[grep]="Search text with ripgrep"
    shell_command_descriptions[find]="Find files with fd"
    shell_command_descriptions[du]="Show disk usage with dust"
    shell_command_descriptions[df]="Show filesystem usage with duf"
    shell_command_descriptions[ps]="Show processes with procs"
    shell_command_descriptions[top]="Open btop monitor"
    shell_command_descriptions[ll]="Long directory listing with git status"
    shell_command_descriptions[l]="Long directory listing"
    shell_command_descriptions[la]="All files with git status"
    shell_command_descriptions[t]="Tree view; pass depth after alias"
  '';
}
