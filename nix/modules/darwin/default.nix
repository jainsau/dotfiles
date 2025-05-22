{ pkgs, ... }@args:

{
  ids.gids.nixbld = 350;

  system.primaryUser = "saurabh";

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
  
  security.pam.services.sudo_local.touchIdAuth = true; # Doesn't work inside a tmux session
  system.stateVersion = 4; # Don't touch unless upgrading from older version
}
