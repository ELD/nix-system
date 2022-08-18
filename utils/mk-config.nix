# Shamelessly stolen from: https://gitlab.com/K900/nix
{
  inputs,
  system,
  lib,
  patches ? f: [],
  toPatch,
}: let
  patchFetchers = {
    pr = id: builtins.fetchurl {
      url = "https://github.com/NixOS/nixpkgs/pull/${builtins.toString id}.patch";
      sha256 = "sha256:0xnv3zzj74vk2yfim03szh65hqinwapixsshdzmigh96qiigwf6a";
    };
  };
  pkgsForPatching = import toPatch { inherit system; };
  patchesToApply = patches patchFetchers;
  patchedNixpkgsDrv =
    if patchesToApply != []
    then
      pkgsForPatching.applyPatches {
        name = "nixpkgs-patched";
        src = toPatch;
        patches = patchesToApply;
      }
    else toPatch;
  patchedNixpkgs = import patchedNixpkgsDrv;
  patchedNixpkgsFor = system:
    patchedNixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  patchNixosSystem = {
    hostname,
    modules ? [],
    system ? "x86_64-linux"
  }: let
    machineSpecificConfig = ../hardware + "/${hostname}.nix";
    machineSpecificModules =
      if builtins.pathExists machineSpecificConfig
      then [ machineSpecificConfig ]
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
              nixPath = [ "nixpkgs=${patchedNixpkgsDrv}" ];
            };
          }
        ] ++ modules;
        specialArgs = { inherit inputs; };
    };
in {
  inherit patchNixosSystem;
  pkgs = with system; patchedNixpkgsFor system;
}
