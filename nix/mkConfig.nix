{ self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
let
  mkHomeConfig = name: cfg: settings: {
    name = name;
    value = home-manager.lib.homeManagerConfiguration {
      pkgs = (import nixpkgs {
        inherit (cfg) system;
        config.allowUnfree = true;
      });
      extraSpecialArgs = {
        inherit inputs;
        inherit (settings) username homeDirectory gitUser gitEmail;
        system = cfg.system;
      };
      modules = [ "${self}/nix/home-manager" ];
    };
  };

  mkDarwinConfig = name: cfg: settings: {
    name = name;
    value = nix-darwin.lib.darwinSystem {
      inherit (cfg) system;
      pkgs = (import nixpkgs {
        inherit (cfg) system;
        config.allowUnfree = true;
      });
      specialArgs = {
        inherit inputs;
        system = cfg.system;
        inherit (settings) username;
      };
      modules = [
        { users.users.${settings.username}.home = settings.homeDirectory; }
        "${self}/nix/darwin"
      ];
    };
  };

  makeConfigs = systems: type: mkFunc: settings: builtins.listToAttrs (
    builtins.filter (x: x != null) (
      map (name:
        let cfg = systems.${name}; in
        if cfg.type == type then mkFunc name cfg settings else null
      ) (builtins.attrNames systems)
    )
  );

  switchPackages = systems: settings: builtins.foldl'
    (acc: name:
      let
        cfg = systems.${name};
        pkgsForSystem = (import nixpkgs {
          inherit (cfg) system;
          config.allowUnfree = true;
        });
        switchScript =
          if cfg.type == "darwin" then
            pkgsForSystem.writeShellApplication {
              name = "${name}-switch";
              text = "exec sudo ${inputs.nix-darwin.packages.${cfg.system}.darwin-rebuild}/bin/darwin-rebuild switch --flake .#${name}";
            }
          else if cfg.type == "home" then
            (makeConfigs systems "home" mkHomeConfig settings).${name}.activationPackage
          else throw "Unknown type: ${cfg.type}";
      in acc // {
        ${cfg.system} = (acc.${cfg.system} or {}) // {
          "${name}-switch" = switchScript;
        };
      }
    )
    {}
    (builtins.attrNames systems);
in
{
  inherit mkHomeConfig mkDarwinConfig makeConfigs switchPackages;
} 