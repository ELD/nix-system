{ config, lib, pkgs, ... }: {
  user.name = "edattore-cci";
  hm = { imports = [ ./home-manager/work.nix ]; };
}
