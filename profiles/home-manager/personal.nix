{ config, lib, pkgs, ... }: {
  programs.git = {
    userEmail = "eric@dattore.me";
    userName = "Eric Dattore";
    signing = {
      key = "eric@dattore.me";
      signByDefault = true;
    };
  };
}
