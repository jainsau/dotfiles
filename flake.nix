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
      baseUserSettings = import ./nix/user.nix;
      localUserConfigPath =
        let
          fromEnv = builtins.getEnv "DOTFILES_USER_CONFIG";
          pwd = builtins.getEnv "PWD";
          fromPwd = if pwd == "" then "" else "${pwd}/.user.nix";
          candidate = if fromEnv != "" then fromEnv else fromPwd;
        in
        if candidate != "" && builtins.pathExists candidate then builtins.toPath candidate else null;
      localUserSettings = if localUserConfigPath == null then { } else import localUserConfigPath;
      userSettings = baseUserSettings // localUserSettings;
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
