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
  ];
}
