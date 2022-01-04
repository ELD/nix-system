{ config, lib, pkgs, ... }: {
  homebrew.taps = [ "homebrew/cask-drivers" ];
  homebrew.casks = [ "logitech-g-hub" ];
}

