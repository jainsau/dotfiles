{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # System monitoring
    lsof
    ncdu
    podman

    # Network diagnostics (cross-platform)
    nmap
    bandwhich
    iftop
    mtr
    whois
    dig
    ipcalc
    socat
    trippy
    termshark
    curl
    wget
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    tcpdump
    traceroute
  ];

  home.shellAliases = {
    ports = "lsof -i -P -n | grep LISTEN";
    listening = "lsof -i -P -n | grep LISTEN";
    pod = "podman";
  };
} 