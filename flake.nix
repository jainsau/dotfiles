{
  description = "Pure Nix flake for dotfiles";

  # === INPUTS ===
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # === OUTPUTS ===
  outputs = inputs @ { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      systems = import ./nix/systems.nix;
      userSettings = import ./nix/user.nix;
      mkConfig = import ./nix/mkConfig.nix inputs;
      homeConfigs = mkConfig.makeConfigs systems "home" mkConfig.mkHomeConfig userSettings;
      darwinConfigs = mkConfig.makeConfigs systems "darwin" mkConfig.mkDarwinConfig userSettings;
      packages = mkConfig.switchPackages systems userSettings;
    in
    {
      homeConfigurations = homeConfigs;
      darwinConfigurations = darwinConfigs;
      packages = packages;
    };
}
