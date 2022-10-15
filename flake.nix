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
    # package repos
    stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixos-unstable.url = "github:ELD/nixpkgs/nixos-unstable-bootspec-patched";
    nixpkgs.url = "github:ELD/nixpkgs/nixpkgs-unstable-bootspec-patched";
    small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    # system management
    nixos-hardware.url = "github:nixos/nixos-hardware";
    darwin = {
      url = "github:kclejeune/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    # shell stuff
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Bootspec/Secure Boot
    bootspec-secureboot = {
      url = "github:DeterminateSystems/bootspec-secureboot/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , darwin
    , home-manager
    , flake-utils
    , ...
    }:
    let
      inherit (flake-utils.lib) eachSystemMap;

      isDarwin = system: (builtins.elem system inputs.nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";
      defaultSystems = [ "aarch64-linux" "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];

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
        inputs.darwin.lib.darwinSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = { inherit self inputs nixpkgs; };
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
            ({ config, pkgs, ... }:
              {
                nixpkgs.overlays = builtins.attrValues self.overlays;
              }
            )
          ]
        , extraModules ? [ ]
        , hostname ? ""
        }:
        inputs.nixos-unstable.lib.nixosSystem {
          inherit system;
          modules =
            [
              {
                networking.hostName = hostname;
              }
            ]
            ++ [ ./modules/hardware/indium.nix ]
            ++ baseModules
            ++ hardwareModules
            ++ extraModules;
          specialArgs = { inherit self inputs nixpkgs; };
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
        inputs.home-manager.lib.homeManagerConfiguration rec {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = { inherit self inputs nixpkgs; };
          modules = baseModules ++ extraModules ++ [ ./modules/overlays.nix ];
        };
    in
    {
      checks = builtins.listToAttrs (
        # darwin checks
        (builtins.map
          (system: {
            name = system;
            value = {
              darwin =
                self.darwinConfigurations.rhombus.config.system.build.toplevel;
              darwinServer =
                self.homeConfigurations.darwinServer.activationPackage;
            };
          })
          inputs.nixpkgs.lib.platforms.darwin) ++
        # linux checks
        (builtins.map
          (system: {
            name = system;
            value = {
              server = self.homeConfigurations.server.activationPackage;
              indium = self.nixosConfigurations.indium.config.system.build.toplevel;
            };
          })
          inputs.nixpkgs.lib.platforms.linux)
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
          hardwareModules = [
            inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
          ];
          extraModules = [
            ./profiles/personal.nix
          ];
          hostname = "indium";
        };
      };

      homeConfigurations = {
        server = mkHomeConfig {
          nixpkgs = inputs.nixpkgs;
          stable = inputs.stable;
          username = "edattore";
          extraModules = [
            ./profiles/home-manager/personal.nix
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
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };
        in
        {
          default = pkgs.devshell.mkShell {
            packages = with pkgs; [
              nixfmt
              pre-commit
              rnix-lsp
              self.packages.${system}.pyEnv
              stylua
              treefmt
            ];
            commands = [{
              name = "sysdo";
              package = self.packages.${system}.sysdo;
              category = "utilities";
              help = "perform actions on this repository";
            }];
          };
        });

      packages = eachSystemMap defaultSystems (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };
        in
        rec {
          pyEnv = pkgs.python3.withPackages
            (ps: with ps; [ black typer colorama shellingham ]);
          sysdo = pkgs.writeScriptBin "sysdo" ''
            #! ${pyEnv}/bin/python3
            ${builtins.readFile ./bin/do.py}
          '';
        });

      apps = eachSystemMap defaultSystems (system: rec {
        sysdo = {
          type = "app";
          program = "${self.package.${system}.sysdo}/bin/sysdo";
        };
        default = sysdo;
      });

      overlays = {
        channels = final: prev: {
          stable = import inputs.stable { system = prev.system; config.allowUnfree = true; };
          small = import inputs.small { system = prev.system; config.allowUnfree = true; };
          nixos-unstable = import inputs.nixos-unstable { system = prev.system; config.allowUnfree = true; };
        };
        python =
          let
            overrides = (pfinal: pprev: {
              pyopenssl = pprev.pyopenssl.overrideAttrs
                (old: { meta = old.meta // { broken = false; }; });
            });
          in
          final: prev: {
            python3 = prev.python3.override {
              packageOverrides = overrides;
            };
            python39 = prev.python39.override {
              packageOverrides = overrides;
            };
            python310 = prev.python310.override {
              packageOverrides = overrides;
            };
          };
        sbctl = final: prev: {
          sbctl = final.callPackage ./modules/packages/sbctl.nix { };
        };
        extraPackages = final: prev: {
          sysdo = self.packages.${prev.system}.sysdo;
          pyEnv = self.packages.${prev.system}.pyEnv;
        };
        devshell = inputs.devshell.overlay;
      };
    };
}
