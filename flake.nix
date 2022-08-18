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

    stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    bootis = {
      url = "gitlab:K900/bootis";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
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
      inputs.utils.follows = "flake-utils";
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
      inherit (flake-utils.lib) eachSystemMap defaultSystems;
      inherit (builtins) listToAttrs map;

      isDarwin = system: (builtins.elem system nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      # generate a base darwin configuration with the
      # specified hostname, overlays, and any extraModules applied
      mkDarwinConfig =
        { system ? "aarch64-darwin"
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
        , nixpkgs ? inputs.nixpkgs
        , stable ? inputs.stable
        , hardwareModules
        , baseModules ? [
            home-manager.nixosModules.home-manager
            ./modules/nixos
          ]
        , extraModules ? [ ]
        , hostname ? ""
        }:
        with import ./utils/mk-config.nix {
          inherit inputs system;
          lib = nixpkgs.lib;
          patches = f:
            with f; [
              (pr "172237")
            ];
          toPatch = inputs.nixpkgs;
        };
        patchNixosSystem {
          inherit hostname system;
          modules = baseModules ++ hardwareModules ++ extraModules;
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
              home = {
                inherit username;
                homeDirectory = "${homePrefix system}/${username}";
                sessionVariables = {
                  NIX_PATH = "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH:+:}$NIX_PATH";
                };
              };
            }
          ]
        , extraModules ? [ ]
        }:
        homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            inherit system;
          };
          extraSpecialArgs = { inherit inputs nixpkgs stable; };
          modules = baseModules ++ extraModules ++ [ ./modules/overlays.nix ];
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
                self.darwinConfigurations.rhombus.config.system.build.toplevel;
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
              indium = self.nixosConfigurations.indium.config.system.build.toplevel;
            };
          })
          nixpkgs.lib.platforms.linux)
      );

      darwinConfigurations = {
        vanadium = mkDarwinConfig {
          extraModules = [
            ./profiles/personal.nix
            ./modules/darwin/apps.nix
            ./modules/darwin/network/personal.nix
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

      nixosConfigurations = {
        indium = mkNixosConfig {
          hostname = "indium";
          hardwareModules = [
            ./modules/hardware/indium.nix
            inputs.nixos-hardware.nixosModules.framework
          ];
          extraModules = [
            ./profiles/personal.nix
          ];
        };
      };

      homeConfigurations = {
        server = mkHomeConfig {
          username = "edattore";
          nixpkgs = inputs.small;
          extraModules = [
              ./profiles/home-manager/personal.nix
              ./modules/nixos/home-manager.nix
          ];
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
      };

      devShells = eachSystemMap defaultSystems (system:
        let
          pkgs = import inputs.stable {
            inherit system;
            overlays = [
              inputs.devshell.overlay
              (final: prev: {
                python39 = prev.python39.override {
                  packageOverrides = (pfinal: pprev: {
                    pyopenssl = pprev.pyopenssl.overrideAttrs (old: {
                      meta = old.meta // { broken = false; };
                    });
                    typer = pprev.typer.overrideAttrs (old: {
                      meta = old.meta // { broken = false; };
                    });
                  });
                };
              })
            ];
          };
          pyEnv = (pkgs.python3.withPackages
            (ps: with ps; [ black pylint typer colorama shellingham ]));
          sysdo = pkgs.writeShellScriptBin "sysdo" ''
            cd $PRJ_ROOT && ${pyEnv}/bin/python3 bin/do.py $@
          '';
        in
        {
          default = pkgs.devshell.mkShell {
            packages = with pkgs; [ nixfmt pyEnv rnix-lsp stylua treefmt ];
            commands = [{
              name = "sysdo";
              package = sysdo;
              category = "utilities";
              help = "perform actions on this repository";
            }];
          };
        }
      );
    };
}
