{ pkgs, ... }@args:

{
  ids.gids.nixbld = 350;

  system.primaryUser = args.username;

  # Basic system config
  environment.systemPackages = with pkgs; [
    # home-manager
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
    };

    casks = [ "utm" ];
    # brews = [  ]; # "kitty" "lima" "nerdctl"
  };

  nix.enable = true;
  nix.optimise.automatic = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  security.pam.services.sudo_local.touchIdAuth = true; # Doesn't work inside a tmux session
  system.stateVersion = 4; # Don't touch unless upgrading from older version
}
