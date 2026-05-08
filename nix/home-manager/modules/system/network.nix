# === NETWORK DIAGNOSTIC TOOLS ===
{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.tools.enableNetworkTools {
    home.packages = with pkgs; [
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
    ] ++ optionals pkgs.stdenv.isLinux [
      tcpdump
      traceroute
    ];
  };
}
