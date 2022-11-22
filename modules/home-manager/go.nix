{ config, lib, pkgs, ... }: {
  programs.go = {
    enable = true;
    goPath = "workspace/go";
    goBin = "workspace/go/bin";
  };
}
