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

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHomeConfig = name: cfg: {
        name = name;
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs cfg.system;
          extraSpecialArgs = {
            inherit inputs;
            system = cfg.system;
            username = "saurabh";
            homeDirectory = "/Users/saurabh";
          };
          modules = [ ./nix/modules/home-manager ];
        };
      };

      mkDarwinConfig = name: cfg: {
        name = name;
        value = nix-darwin.lib.darwinSystem {
          inherit (cfg) system;
          pkgs = mkPkgs cfg.system;
          specialArgs = {
            inherit inputs;
            system = cfg.system;
            username = "saurabh";
          };
          modules = [ ./nix/modules/darwin ];
        };
      };

      allNames = builtins.attrNames systems;
      
      makeConfigs = type: mkFunc: builtins.listToAttrs (
        builtins.filter (x: x != null) (
          map (name:
            let cfg = systems.${name}; in
            if cfg.type == type then mkFunc name cfg else null
          ) allNames
        )
      );

      homeConfigs = makeConfigs "home" mkHomeConfig;

      darwinConfigs = makeConfigs "darwin" mkDarwinConfig;

      switchPackages = builtins.foldl'
        (acc: name:
          let
            cfg = systems.${name};
            pkgsForSystem = mkPkgs cfg.system;
            switchScript = if cfg.type == "darwin" then
              pkgsForSystem.writeShellApplication {
                name = "${name}-switch";
                text = "exec sudo darwin-rebuild switch --flake .#${name}";
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
      homeConfigurations = homeConfigs;
      darwinConfigurations = darwinConfigs;
      packages = switchPackages;
    };
}

# packages = builtins.mapAttrs (_: cfg: {
#           darwin-switch = nixpkgs.legacyPackages.${cfg.system}.writeShellApplication {
#             name = "darwin-switch";
#             text = ''
#               exec darwin-rebuild switch --flake .#${_}
#             '';
#           };
#           home-switch = self.homeConfigurations.${_}.activationPackage;
#         }) systems;
