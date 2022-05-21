{ inputs, nixpkgs, stable, async_generator, freezegun, gunicorn, pytest-mock, pytestCheckHook, re-assert, trustme, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      # expose stable packages via pkgs.stable
      stable = import inputs.stable { system = prev.system; };
    })
    (self: super: {
      python = super.python.override {
        packageOverrides = self: super: {
          aiohttp = super.aiohttp.overrideAttrs (old: {
            checkInputs = [
              async_generator
              freezegun
              gunicorn
              pytest-mock
              pytestCheckHook
              re-assert
            ] ++ lib.optionals stdenv.isLinux [
              trustme
            ];
          });
          pyopenssl = super.pyopenssl.overrideAttrs (old: {
            meta = old.meta // {
              broken = false;
            };
          });
        };
      };
    })
  ];
}
