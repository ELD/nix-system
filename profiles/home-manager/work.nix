{ config, lib, pkgs, ... }:
let
  homePackages = home.packages;
  workPackages = [
    awscli
    google-cloud-sdk
  ];
in
{
  programs.git = {
    enable = true;
    userEmail = "eric.dattore@circleci.com";
    userName = "Eric Dattore";
    signing = {
      key = "eric@dattore.me";
      signByDefault = true;
    };
  };
  home.packages = with pkgs; homePackages ++ workPackages;
}
