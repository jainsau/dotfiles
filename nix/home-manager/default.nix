# === HOME MANAGER CONFIGURATION ===
{ config, pkgs, ... }@args:

let
  username = args.username;
  homeDirectory = args.homeDirectory;
in {
  imports = [
    ./editors
    ./languages
    ./modules
  ];

  # --- User and Home Directory ---
  home.username = args.username;
  home.homeDirectory = args.homeDirectory;
  home.stateVersion = "24.05";

  # --- Environment Variables ---
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL="en_US.UTF-8";
    TERM = "xterm-256color";
    TERMINAL = "kitty";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
  };

  # --- Garbage Collection Optimization (weekly cleanup of old generations) ---
  systemd.user = {
    timers.nix-gc = {
      Unit.Description = "Garbage collect old Nix generations";
      Timer = { OnCalendar = "weekly"; Persistent = true; };
      Install.WantedBy = [ "timers.target" ];
    };
    services = {
      nix-gc.Service.ExecStart = "${pkgs.nix}/bin/nix-collect-garbage -d";
      podman = {
        enable = true;
        description = "Podman API Socket";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.podman}/bin/podman system service --time=0";
        };
      };
    };
  };

  # Package Installations
  home.packages = with pkgs; [
    # opencode  # TODO: Uncomment when package definition is working
  ];

  # --- Enable Home Manager ---
  programs.home-manager.enable = true;

  # --- Editor Configurations ---
  editors = {
    enableVSCode = true;
    enableNeovim = true;
  };

  # --- Kitty Terminal Configuration ---
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "FiraCode Nerd Font";  # Or "MesloLGS Nerd Font"
    };
  };
}
