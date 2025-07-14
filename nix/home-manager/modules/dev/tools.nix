{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bun
    cargo
    rustc
    go
    nodejs
    nodePackages.markdownlint-cli2
    glow
    watchexec
    entr
    nil
  ];
}
