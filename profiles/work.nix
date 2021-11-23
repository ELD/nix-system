{ config, lib, pkgs, ... }: {
  user.name = "edattore";
  hm = { imports = [ ./home-manager/work.nix ]; };
}
