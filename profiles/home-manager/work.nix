{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userEmail = "eric.dattore@circleci.com";
    userName = "Eric Dattore";
    signing = {
      key = "0x26CCB5CE8AE20CE0";
      signByDefault = true;
    };
  };
  home.packages = with pkgs; [
    awscli
    google-cloud-sdk
    leiningen
    poetry
    protobuf
  ];
}
