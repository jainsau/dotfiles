{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bun
    cargo
    rustc
    go
    nodejs
    glow
    watchexec
    entr
    nil
  ];
}
