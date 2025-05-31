{
  description = "Cross-platform Nix configuration for Darwin and Home Manager";

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

    nvim-config = {
      url = "path:./config/nvim";
      flake = false;
    };

    # User config (like username, home directory, git identity)
    userConfig.url = "path:./config/userConfig";
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      systems = {
        "dma" = { system = "aarch64-darwin"; type = "darwin"; };
        "dmx" = { system = "x86_64-darwin"; type = "darwin"; };
        "hma" = { system = "aarch64-darwin"; type = "home"; };
        "hmx" = { system = "x86_64-darwin"; type = "home"; };
        "hla" = { system = "aarch64-linux"; type = "home"; };
        "hlx" = { system = "x86_64-linux"; type = "home"; };
      };

      # Create a pkgs instance per target system
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      userConfig = inputs.userConfig.config;

      # Create a Home Manager configuration
      mkHomeConfig = name: cfg: {
        name = name;
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs cfg.system;
          extraSpecialArgs = {
            inherit inputs;
            inherit (userConfig) username homeDirectory gitUser gitEmail;
            system = cfg.system;
          };
          modules = [ ./nix/modules/home-manager ];
        };
      };

      # Create a nix-darwin system configuration
      mkDarwinConfig = name: cfg: {
        name = name;
        value = nix-darwin.lib.darwinSystem {
          inherit (cfg) system;
          pkgs = mkPkgs cfg.system;
          specialArgs = {
            inherit inputs;
            system = cfg.system;
            inherit (userConfig) username;
          };
          modules = [
            { users.users.${userConfig.username}.home = userConfig.homeDirectory; }
            ./nix/modules/darwin
          ];
        };
      };

      # Get all defined system names
      allNames = builtins.attrNames systems;

      # Generate a set of configurations of a given type
      makeConfigs = type: mkFunc: builtins.listToAttrs (
        builtins.filter (x: x != null) (
          map (name:
            let cfg = systems.${name}; in
            if cfg.type == type then mkFunc name cfg else null
          ) allNames
        )
      );

      # Generate all home-manager configs
      homeConfigs = makeConfigs "home" mkHomeConfig;

      # Generate all nix-darwin configs
      darwinConfigs = makeConfigs "darwin" mkDarwinConfig;

      # Create per-system `*-switch` packages for convenience
      switchPackages = builtins.foldl'
        (acc: name:
          let
            cfg = systems.${name};
            pkgsForSystem = mkPkgs cfg.system;
            switchScript =
              if cfg.type == "darwin" then
                pkgsForSystem.writeShellApplication {
                  name = "${name}-switch";
                  text = "exec sudo ${inputs.nix-darwin.packages.${cfg.system}.darwin-rebuild}/bin/darwin-rebuild switch --flake .#${name}";
                }
              else if cfg.type == "home" then
                homeConfigs.${name}.activationPackage
              else throw "Unknown type: ${cfg.type}";
          in acc // {
            ${cfg.system} = (acc.${cfg.system} or {}) // {
              "${name}-switch" = switchScript;
            };
          }
        )
        {}
        allNames;
    in
    {
      # Expose home-manager configurations
      homeConfigurations = homeConfigs;

      # Expose nix-darwin system configurations
      darwinConfigurations = darwinConfigs;

      # Expose helper packages to run switch commands
      packages = switchPackages;
    };
}
