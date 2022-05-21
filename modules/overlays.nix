{ inputs
, nixpkgs
, stable
, ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      # expose stable packages via pkgs.stable
      stable = import inputs.stable { system = prev.system; };
    })
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
}
