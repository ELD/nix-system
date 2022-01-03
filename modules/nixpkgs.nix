{ inputs, config, lib, pkgs, nixpkgs, stable, ... }: {
  nixpkgs = { config = import ./config.nix; };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "${config.user.name}" "root" "@admin" "@wheel" ];
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    buildCores = 8;
    maxJobs = 8;
    readOnlyStore = true;
    nixPath = [
      (source: "${source}=/etc/${config.environment.etc.${source}.target}") [
        "home-manager"
        "nixpkgs"
        "small"
        "stable"
        "trunk"
      ]
    ];

    binaryCaches =
      [ "https://eld.cachix.org" "https://kclejeune.cachix.org" "https://nix-community.cachix.org/" ];
    binaryCachePublicKeys = [
      "eld.cachix.org-1:ddhUxMCAKZVJOVPUcGGWwB5UZfhlhG12rN4GRz8D7sk="
      "kclejeune.cachix.org-1:fOCrECygdFZKbMxHClhiTS6oowOkJ/I/dh9q9b1I4ko="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = nixpkgs;
      };

      stable = {
        from = {
          id = "stable";
          type = "indirect";
        };
        flake = stable;
      };

      trunk = {
        from = {
          id = "trunk";
          type = "indirect";
        };
        flake = inputs.trunk;
      };

      small = {
        from = {
          id = "small";
          type = "indirect";
        };
        flake = inputs.small;
      };
    };
  };
}
