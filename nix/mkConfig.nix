{ self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
let
  getHomeDirectory = system: homeDirectoryName:
    let
      isDarwin = builtins.match ".*-darwin" system != null;
    in
    if isDarwin then "/Users/${homeDirectoryName}" else "/home/${homeDirectoryName}";

  mkHomeConfig = name: cfg: settings:
    let
      homeDirectory = getHomeDirectory cfg.system settings.homeDirectoryName;
    in
    {
      name = name;
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = (import nixpkgs {
          inherit (cfg) system;
          config.allowUnfree = true;
        });
        extraSpecialArgs = {
          inherit inputs;
          inherit (settings) username gitUser gitEmail gpgKey;
          inherit homeDirectory;
          system = cfg.system;
        };
        modules = [ "${self}/nix/home-manager" ];
      };
    };

  mkDarwinConfig = name: cfg: settings:
    let
      homeDirectory = getHomeDirectory cfg.system settings.homeDirectoryName;
    in
    {
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
          inherit homeDirectory;
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
              text = "exec sudo ${inputs.nix-darwin.packages.${cfg.system}.darwin-rebuild}/bin/darwin-rebuild switch --impure --flake .#${name}";
            }
          else if cfg.type == "home" then
            pkgsForSystem.writeShellApplication {
              name = "${name}-switch";
              runtimeInputs = [ home-manager.packages.${cfg.system}.home-manager ];
              text = "exec home-manager switch --impure --flake .#${name}";
            }
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
