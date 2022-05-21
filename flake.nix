{
  description = "My system configuration in Nix — forked from kclejeune/system";

  nixConfig = {
    substituters =
      [ "https://cache.nixos.org" "https://nix-community.cachix.org/" "https://eld.cachix.org" ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "eld.cachix.org-1:ddhUxMCAKZVJOVPUcGGWwB5UZfhlhG12rN4GRz8D7sk="
    ];
  };

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    comma = {
      url = "github:Shopify/comma";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    darwin = {
      url = "github:kclejeune/nix-darwin/backup-etc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , darwin
    , home-manager
    , flake-utils
    , ...
    }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;
      inherit (builtins) listToAttrs map;

      isDarwin = system: (builtins.elem system nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      # generate a base darwin configuration with the
      # specified hostname, overlays, and any extraModules applied
      mkDarwinConfig =
        { system
        , nixpkgs ? inputs.nixpkgs
        , stable ? inputs.stable
        , baseModules ? [
            home-manager.darwinModules.home-manager
            ./modules/darwin
          ]
        , extraModules ? [ ]
        }:
        darwinSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = { inherit inputs nixpkgs stable; };
        };

      # generate a base nixos configuration with the
      # specified overlays, hardware modules, and any extraModules applied
      mkNixosConfig =
        { system ? "x86_64-linux"
        , nixpkgs ? inputs.nixos-unstable
        , stable ? inputs.stable
        , hardwareModules
        , baseModules ? [
            home-manager.nixosModules.home-manager
            ./modules/nixos
          ]
        , extraModules ? [ ]
        }:
        nixosSystem {
          inherit system;
          modules = baseModules ++ hardwareModules ++ extraModules;
          specialArgs = { inherit inputs nixpkgs stable; };
        };

      # generate a home-manager configuration usable on any unix system
      # with overlays and any extraModules applied
      mkHomeConfig =
        { username
        , system ? "x86_64-linux"
        , nixpkgs ? inputs.nixpkgs
        , stable ? inputs.stable
        , baseModules ? [
            ./modules/home-manager
            {
              home.sessionVariables = {
                NIX_PATH = "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH+:}$NIX_PATH";
              };
            }
          ]
        , extraModules ? [ ]
        }:
        homeManagerConfiguration rec {
          inherit system username;
          homeDirectory = "${homePrefix system}/${username}";
          extraSpecialArgs = { inherit inputs nixpkgs stable; };
          configuration = {
            imports = baseModules ++ extraModules ++ [
              ./modules/overlays.nix
            ];
          };
        };
    in
    {
      checks = listToAttrs (
        # darwin checks
        (map
          (system: {
            name = system;
            value = {
              darwin =
                self.darwinConfigurations.silicon-intel.config.system.build.toplevel;
              darwinServer =
                self.homeConfigurations.darwinServer.activationPackage;
            };
          })
          nixpkgs.lib.platforms.darwin) ++
        # linux checks
        (map
          (system: {
            name = system;
            value = {
              server = self.homeConfigurations.server.activationPackage;
            };
          })
          nixpkgs.lib.platforms.linux)
      );

      darwinConfigurations = {
        vanadium = mkDarwinConfig {
          system = "aarch64-darwin";
          extraModules = [
            ./profiles/personal.nix
            ./modules/darwin/apps.nix
            ./modules/darwin/network/personal.nix
            { homebrew.brewPrefix = "/opt/homebrew/bin"; }
          ];
        };
        silicon-intel = mkDarwinConfig {
          system = "x86_64-darwin";
          extraModules = [
            ./profiles/personal.nix
            ./modules/darwin/apps.nix
            { homebrew.brewPrefix = "/opt/homebrew/bin"; }
          ];
        };
        rhombus = mkDarwinConfig {
          system = "x86_64-darwin";
          extraModules = [
            ./profiles/work.nix
            ./modules/darwin/apps-work.nix
            ./modules/darwin/apps.nix
            ./modules/darwin/network/work.nix
          ];
        };
      };

      homeConfigurations = {
        server = mkHomeConfig {
          username = "edattore";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
        darwinServer = mkHomeConfig {
          username = "edattore";
          system = "x86_64-darwin";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
        darwinServerM1 = mkHomeConfig {
          username = "edattore";
          system = "aarch64-darwin";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
        workServer = mkHomeConfig {
          username = "edattore";
          extraModules = [ ./profiles/home-manager/work.nix ];
        };
        vagrant = mkHomeConfig {
          username = "vagrant";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
      };
    } //
    # add a devShell to this flake
    eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          inputs.devshell.overlay
          (final: prev: rec {
            python3 = prev.python3.override
              {
                packageOverrides = final: prev: {
                  aiohttp = prev.aiohttp.overrideAttrs
                    (old: {
                      checkInputs = builtins.filter (pkg: pkg != inputs.trustme) old.checkInputs;
                    });
                  pyopenssl = prev.pyopenssl.overrideAttrs
                    (old: {
                      meta = old.meta // { broken = false; };
                    });
                };
              };
          })
        ];
      };
      pyEnv = (pkgs.python3.withPackages
        (ps: with ps;
        [ black pylint typer colorama shellingham ]));
      sysdo = pkgs.writeShellScriptBin
        "sysdo"
        ''
          cd $PRJ_ROOT && ${pyEnv}/bin/python3 bin/do.py $@
        '';
    in
    {
      devShell = pkgs.devshell.mkShell {
        packages = with pkgs; [ nixfmt pyEnv rnix-lsp stylua treefmt ];
        commands = [{
          name = "sysdo";
          package = sysdo;
          category = "utilities";
          help = "perform actions on this repository";
        }];
      };
    });
}
