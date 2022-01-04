{ config, lib, pkgs, ... }:
let
  homebrewApps = import ./apps.nix;
  homebrewConfig = import ./brew.nix;
in {
  homebrewConfig.hombrew.taps =
    homebrewConfig.homebrew.taps ++ [ "homebrew/cask-drivers" ];

  homebrewApps.homebrew.casks =
    homebrewApps.homebrew.casks ++ [ "logitech-g-hub" ];
}

