{ inputs
, nixpkgs
, stable
, ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      # expose stable packages via pkgs.stable
      stable = import inputs.stable { system = prev.system; };
      small = import inputs.stable { system = prev.system; };
    })
    (final: prev: {
      python3 = prev.python3.override {
        packageOverrides = (pfinal: pprev: {
          pyopenssl = pprev.pyopenssl.overrideAttrs (old: {
            meta = old.meta // { broken = false; };
          });
        });
      };
      python310 = prev.python310.override {
        packageOverrides = (pfinal: pprev: {
          pyopenssl = pprev.pyopenssl.overrideAttrs (old: {
            meta = old.meta // { broken = false; };
          });
        });
      };
      python39 = prev.python39.override {
        packageOverrides = (pfinal: pprev: {
          pyopenssl = pprev.pyopenssl.overrideAttrs (old: {
            meta = old.meta // { broken = false; };
          });
        });
      };
    })
    (final: prev: {
      circleci-cli =
        let
          version = "0.1.20144";
          pname = "circleci";
          src = final.pkgs.fetchFromGitHub {
            owner = "CircleCI-Public";
            repo = "${pname}-cli";
            rev = "v${version}";
            sha256 = "sha256-69GGJfnOHry+N3hKZapKz6eFSerqIHt4wRAhm/q/SOQ=";
          };
        in
        (prev.circleci-cli.override rec {
          buildGoModule = args: final.pkgs.buildGoModule.override { go = final.pkgs.go_1_17; } (args // {
            inherit src version;
            vendorSha256 = "sha256-7u2y1yBVpXf+D19tslD4s3B1KmABl4OWNzzLaBNL/2U=";
          });
        });
    })
    (final: prev: {
      sbctl = final.callPackage ./packages/sbctl.nix { };
    })
  ];
}
