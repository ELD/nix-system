{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "eric.dattore@circleci.com";
    userName = "Eric Dattore";
    signing = {
      key = "eric@dattore.me";
      signByDefault = true;
    };
  };
  home.packages = [
    pkgs.awscli
    pkgs.google-cloud-sdk
    pkgs.leiningen
  ];
}
