{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nmap
    bandwhich
    iftop
    lsof
    ncdu
    podman
  ];

  home.shellAliases = {
    ports = "lsof -i -P -n | grep LISTEN";
    listening = "lsof -i -P -n | grep LISTEN";
    pod = "podman";
  };
} 