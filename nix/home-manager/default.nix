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

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

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

  home.shellAliases = {
    serve = "python3 -m http.server";
    myip = "curl -s https://httpbin.org/ip | jq -r .origin";
    cs = "curl https://cheat.sh/{$1}";
  };

  fonts.fontconfig.enable = true;

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

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    fontconfig
  ];

  programs.home-manager.enable = true;

  editors = {
    enableVSCode = true;
    enableNeovim = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "FiraCode Nerd Font";
    };
  };
}
