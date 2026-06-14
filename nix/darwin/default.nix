# === DARWIN (macOS) SYSTEM CONFIGURATION ===
{ pkgs, lib, ... }@args:

{
  imports = [ ];

  # --- Multipass alias ---
  environment.shellAliases.m = "multipass";

  # --- Set build group ID for nixbld ---
  ids.gids.nixbld = 350;

  # --- Set primary user for the system ---
  system.primaryUser = args.username;

  # --- Basic system config ---
  environment.systemPackages = with pkgs; [ ];

  nix.enable = true;
  nix.optimise.automatic = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # --- Enable Touch ID for sudo (doesn't work inside tmux) ---
  security.pam.services.sudo_local.touchIdAuth = true;
  system.stateVersion = 4; # Do not change unless upgrading from older version

  # --- Homebrew integration for additional packages ---
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
      # nix-darwin invokes brew via sudo --set-home without inheriting the
      # user's shell environment. Preserve Homebrew's XDG trust store so
      # trusted taps/formulae are visible during activation.
      extraEnv.XDG_CONFIG_HOME = "${args.homeDirectory}/.config";
    };

    casks = [
      "maccy"
      "utm"
      "ollama-app"
      "obsidian"
      "multipass"
      "postman"
    ];
    brews = [
      "lima"
      "colima"
      "archon"
    ] ++ lib.optionals pkgs.stdenv.hostPlatform.isAarch64 [
      # Apple's Container CLI is Apple Silicon-only.
      "container"
    ];
    taps = [
      "coleam00/archon"
    ];
  };
}
