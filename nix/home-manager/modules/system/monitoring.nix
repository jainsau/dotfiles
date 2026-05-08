# === SYSTEM MONITORING TOOLS ===
{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf config.tools.enableMonitoring {
    home.packages = with pkgs; [
      lsof
      ncdu
    ];

    home.shellAliases = {
      ports = "lsof -i -P -n | grep LISTEN";
      listening = "lsof -i -P -n | grep LISTEN";
    };
  };
}
