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
      python39 = prev.python39.override {
        packageOverrides = pfinal: pprev: {
          pyopenssl = pprev.pyopenssl.overrideAttrs (old: {
            meta = with old; {
              inherit meta;
              broken = false;
            };
          });
        };
      };
      python310 = prev.python39.override {
        packageOverrides = pfinal: pprev: {
          pyopenssl = pprev.pyopenssl.overrideAttrs (old: {
            meta = with old; {
              inherit meta;
              broken = false;
            };
          });
        };
      };
    })
  ];
}
