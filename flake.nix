# === FLAKE DEFINITION ===
{
  description = "Cross-platform Nix configuration for Darwin and Home Manager";

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

    # User config (like username, home directory, git identity)
    userConfig.url = "path:./config/userConfig";
  };

  # === OUTPUTS ===
  outputs = inputs @ { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      # --- Supported system definitions ---
      systems = {
        "dma" = { system = "aarch64-darwin"; type = "darwin"; };
        "dmx" = { system = "x86_64-darwin"; type = "darwin"; };
        "hma" = { system = "aarch64-darwin"; type = "home"; };
        "hmx" = { system = "x86_64-darwin"; type = "home"; };
        "hla" = { system = "aarch64-linux"; type = "home"; };
        "hlx" = { system = "x86_64-linux"; type = "home"; };
      };

      # --- Local package overlay ---
      localOverlay = final: prev: {
        opencode = final.callPackage ./nix/home-manager/modules/cli/opencode.nix { };
      };

      # --- Helper: Create a pkgs instance per target system ---
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ localOverlay ];
      };

      userConfig = inputs.userConfig.config;

      # --- Helper: Create a Home Manager configuration ---
      mkHomeConfig = name: cfg: {
        name = name;
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs cfg.system;
          extraSpecialArgs = {
            inherit inputs;
            inherit (userConfig) username homeDirectory gitUser gitEmail;
            system = cfg.system;
          };
          modules = [ ./nix/home-manager ];
        };
      };

      # --- Helper: Create a nix-darwin system configuration ---
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
            ./nix/darwin
          ];
        };
      };

      # --- Helper: Get all defined system names ---
      allNames = builtins.attrNames systems;

      # --- Helper: Generate a set of configurations of a given type ---
      makeConfigs = type: mkFunc: builtins.listToAttrs (
        builtins.filter (x: x != null) (
          map (name:
            let cfg = systems.${name}; in
            if cfg.type == type then mkFunc name cfg else null
          ) allNames
        )
      );

      # --- Generate all home-manager configs ---
      homeConfigs = makeConfigs "home" mkHomeConfig;

      # --- Generate all nix-darwin configs ---
      darwinConfigs = makeConfigs "darwin" mkDarwinConfig;

      # --- Create per-system `*-switch` packages for convenience ---
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
      # === EXPORTED OUTPUTS ===
      homeConfigurations = homeConfigs;      # Home Manager configurations
      darwinConfigurations = darwinConfigs;  # nix-darwin system configurations
      packages = switchPackages;             # Helper packages to run switch commands
    };
}
