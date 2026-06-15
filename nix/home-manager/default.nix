{ config, pkgs, lib, ... }@args:

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
  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL="en_US.UTF-8";
    TERM = "xterm-256color";
    TERMINAL = "kitty";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.local/share/npm";
  };

  home.shellAliases = {
    serve = "python3 -m http.server";
    myip = "curl -s https://httpbin.org/ip | jq -r .origin";
  };

  programs.zsh.initContent = ''
    typeset -gA shell_command_descriptions
    shell_command_descriptions[serve]="Serve current directory over HTTP"
    shell_command_descriptions[myip]="Show public IP address"
  '';

  fonts.fontconfig.enable = true;

  # Linux-only services
  systemd.user = lib.mkIf pkgs.stdenv.isLinux {
    timers.nix-gc = {
      Unit.Description = "Garbage collect old Nix generations";
      Timer = { OnCalendar = "weekly"; Persistent = true; };
      Install.WantedBy = [ "timers.target" ];
    };

    services = {
      nix-gc.Service.ExecStart = "${pkgs.nix}/bin/nix-collect-garbage -d";

      podman = {
        Unit.Description = "Podman API Socket";
        Install.WantedBy = [ "default.target" ];
        Service = {
          ExecStart = "${pkgs.podman}/bin/podman system service --time=0";
        };
      };
    };
  };

  # macOS-only services
  launchd.agents = lib.mkIf pkgs.stdenv.isDarwin {
    nix-gc = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.nix}/bin/nix-collect-garbage" "-d" ];
        StartCalendarInterval = { Weekday = 0; Hour = 3; Minute = 0; };
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
      # Make Option behave as Meta/Alt so shell widgets like fzf Alt+C work.
      macos_option_as_alt = "left";
    };
  };

  xdg.configFile."mimeapps.list" = {
    text = ''
      [Default Applications]
    '';
    force = true;
  };
}
