{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bun
    cargo
    clang
    rustc
    go
    nodejs
    markdownlint-cli2
    glow
    watchexec
    entr
    nil
    cfssl
    k9s
  ];
}
