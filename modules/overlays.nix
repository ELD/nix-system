{ inputs, nixpkgs, stable, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      # expose stable packages via pkgs.stable
      stable = import inputs.stable { system = prev.system; };
      trunk = import inputs.trunk { system = prev.system; };
    })
    (final: prev: rec {
      gnupg =
        let
          inherit(prev);
        in
        if prev.stable.gnupg.version == "2.3.3" then
        prev.trunk.gnupg
        else
        prev.trunk.gnupg;
      })
  ];
}
