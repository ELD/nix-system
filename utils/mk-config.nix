{
  self,
  inputs,
  patches ? _f: [],
  system ? "x86_64-linux",
}: let
  patchFetchers = {
    pr = id: sha:
      builtins.fetchurl {
        url = "https://github.com/NixOS/nixpkgs/pull/${builtins.toString id}.patch";
        sha256 = sha;
      };
  };
  pkgsForPatching = import inputs.nixpkgs {inherit system;};
  patchesToApply = patches patchFetchers;
  patchedNixpkgsDrv =
    if patchesToApply != []
    then
      pkgsForPatching.applyPatches
      {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = patchesToApply;
      }
    else inputs.nixpkgs;
  patchedNixpkgs = import patchedNixpkgsDrv;
  patchedNixpkgsFor = system:
    patchedNixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  mkNixOSSystem = {
    hostname,
    modules ? [],
    system ? "x86_64-linux",
  }: let
    machineSpecificConfig = ../modules/hardware + "/${hostname}.nix";
    machineSpecificModules =
      if builtins.pathExists machineSpecificConfig
      then [machineSpecificConfig]
      else [];
    pkgs = patchedNixpkgsFor system;
  in
    import "${patchedNixpkgsDrv}/nixos/lib/eval-config.nix" {
      inherit system;
      modules =
        [
          {
            networking.hostName = hostname;
            nixpkgs.pkgs = pkgs;

            nix = {
              registry.nixpkgs.flake = patchedNixpkgsDrv;
              nixPath = ["nixpkgs=${patchedNixpkgsDrv}"];
            };
          }
        ]
        ++ machineSpecificModules
        ++ modules;
      specialArgs = {inherit self inputs;};
    };
in {
  inherit mkNixOSSystem;
  pkgs = with system; patchedNixpkgsFor system;
}
