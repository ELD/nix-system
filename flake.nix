{
  description = "My system configuration in Nix — forked from kclejeune/system";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org?priority=40"
      "https://nix-community.cachix.org?priority=41"
      "https://numtide.cachix.org?priority=42"
      "https://edattore-attic-nix-binary-cache.fly.dev/system?priority=43"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "system:9kc0wfN/u1hwyuvVf34YvpWGutSlLpjMeH8ovjOEJm8="
    ];
  };

  inputs = {
    # package repos
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    devenv.url = "github:cachix/devenv/v0.6.2";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    templ = {
      url = "github:a-h/templ";
    };

    # system management
    nixos-hardware.url = "github:nixos/nixos-hardware";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # shell stuff
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SecureBoot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    devenv,
    flake-utils,
    home-manager,
    ...
  } @ inputs: let
    inherit (flake-utils.lib) eachSystemMap;

    isDarwin = system: (builtins.elem system inputs.nixpkgs.lib.platforms.darwin);
    homePrefix = system:
      if isDarwin system
      then "/Users"
      else "/home";
    defaultSystems = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    # generate a base darwin configuration with the
    # specified hostname, overlays, and any extraModules applied
    mkDarwinConfig = {
      system ? "aarch64-darwin",
      nixpkgs ? inputs.nixpkgs,
      baseModules ? [
        home-manager.darwinModules.home-manager
        ./modules/darwin
      ],
      extraModules ? [],
      hostname ? "",
    }:
      inputs.darwin.lib.darwinSystem {
        inherit system;
        modules =
          [
            {
              networking = {
                hostName = hostname;
                localHostName = hostname;
                computerName = hostname;
              };
            }
          ]
          ++ baseModules
          ++ extraModules;
        specialArgs = {inherit self inputs nixpkgs;};
      };

    # generate a base nixos configuration with the
    # specified overlays, hardware modules, and any extraModules applied
    mkNixosConfig = {
      system ? "x86_64-linux",
      nixpkgs ? inputs.nixpkgs,
      hardwareModules,
      baseModules ? [
        home-manager.nixosModules.home-manager
        ./modules/nixos
        (
          _: {
            nixpkgs.overlays = builtins.attrValues self.overlays;
          }
        )
      ],
      extraModules ? [],
      hostname ? "",
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [
            {
              networking.hostName = hostname;
            }
          ]
          ++ [./modules/hardware/indium.nix]
          ++ baseModules
          ++ hardwareModules
          ++ extraModules;
        specialArgs = {inherit self inputs nixpkgs;};
      };

    # generate a home-manager configuration usable on any unix system
    # with overlays and any extraModules applied
    mkHomeConfig = {
      username,
      system ? "x86_64-linux",
      nixpkgs ? inputs.nixpkgs,
      baseModules ? [
        inputs.nix-index-database.hmModules.nix-index
        ./modules/home-manager
        {
          home = {
            inherit username;
            homeDirectory = "${homePrefix system}/${username}";
            sessionVariables = {
              NIX_PATH = "nixpkgs=${nixpkgs}:stable=${inputs.stable}\${NIX_PATH:+:}$NIX_PATH";
            };
          };
        }
      ],
      extraModules ? [],
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        };
        extraSpecialArgs = {inherit self inputs nixpkgs;};
        modules = baseModules ++ extraModules;
      };

    mkChecks = {
      arch,
      os,
      hostname,
      username ? "edattore",
    }: {
      "${arch}-${os}" = {
        "${hostname}_${os}" =
          (
            if os == "darwin"
            then self.darwinConfigurations
            else self.nixosConfigurations
          )
          ."${hostname}@${arch}-${os}"
          .config
          .system
          .build
          .toplevel;
        "${username}_home" = self.homeConfigurations."${username}@${arch}-${os}".activationPackage;
        devShell = self.devShells."${arch}-${os}".default;
      };
    };
  in {
    checks =
      {}
      // (mkChecks {
        arch = "aarch64";
        os = "darwin";
        hostname = "vanadium";
      })
      // (mkChecks {
        arch = "x86_64";
        os = "linux";
        hostname = "indium";
      });

    darwinConfigurations = {
      "vanadium@aarch64-darwin" = mkDarwinConfig {
        system = "aarch64-darwin";
        extraModules = [
          ./profiles/personal.nix
          ./profiles/darwin/brew.nix
        ];
        hostname = "Vanadium";
      };
      "ellipse@aarch64-darwin" = mkDarwinConfig {
        system = "aarch64-darwin";
        extraModules = [
          ./profiles/work.nix
        ];
        hostname = "cci-ericdattore-t99yh";
      };
      "rhombus@x86_64-darwin" = mkDarwinConfig {
        system = "x86_64-darwin";
        extraModules = [
          ./profiles/work.nix
        ];
        hostname = "cci-ericdattore-t99yh";
      };
    };

    nixosConfigurations = {
      "indium@x86_64-linux" = mkNixosConfig {
        system = "x86_64-linux";
        hardwareModules = [
          inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
        ];
        extraModules = [
          ./profiles/personal.nix
        ];
        hostname = "Indium";
      };
    };

    homeConfigurations = {
      "edattore@x86_64-linux" = mkHomeConfig {
        system = "x86_64-linux";
        username = "edattore";
        extraModules = [
          ./profiles/home-manager/personal.nix
        ];
      };
      "edattore@aarch64-linux" = mkHomeConfig {
        system = "aarch64-linux";
        username = "edattore";
        extraModules = [
          ./profiles/home-manager/personal.nix
        ];
      };
      "edattore@x86_64-darwin" = mkHomeConfig {
        system = "x86_64-darwin";
        username = "edattore";
        extraModules = [./profiles/home-manager/personal.nix];
      };
      "edattore@aarch64-darwin" = mkHomeConfig {
        system = "aarch64-darwin";
        username = "edattore";
        extraModules = [./profiles/home-manager/personal.nix];
      };
    };

    devShells = eachSystemMap defaultSystems (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
      };
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          (import ./devenv.nix)
        ];
      };
    });

    packages =
      eachSystemMap
      defaultSystems
      (system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        };
      in rec {
        pyEnv =
          pkgs.python3.withPackages
          (ps: with ps; [black typer colorama shellingham]);
        devenv = inputs.devenv.defaultPackage.${system};
        sysdo = pkgs.writeScriptBin "sysdo" ''
          #! ${pyEnv}/bin/python3
          ${builtins.readFile ./bin/do.py}
        '';
      });

    apps =
      eachSystemMap
      defaultSystems
      (system: rec {
        sysdo = {
          type = "app";
          program = "${self.packages.${system}.sysdo}/bin/sysdo";
        };
        default = sysdo;
      });

    overlays = {
      channels = _final: prev: {
        stable = import inputs.stable {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      };
      vimPlugins = import ./modules/packages/vimPluginsOverlay.nix;
      pop-launcher = final: _prev: {
        pop-launcher = final.callPackage ./modules/packages/pop-launcher.nix {};
      };
      neovim = inputs.neovim-nightly-overlay.overlays.default;
      templ = inputs.templ.overlays.default;
      extraPackages = _final: prev: {
        inherit (self.packages.${prev.system}) sysdo;
        inherit (self.packages.${prev.system}) pyEnv;
        inherit (self.packages.${prev.system}) devenv;
      };
    };
  };
}
