{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.github-cli ];
  programs.git = {
    userName = "Eric Dattore";
    extraConfig = {
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin then
          "osxkeychain"
        else
          "cache --timeout=1000000000";
      http.sslVerify = true;
      pull.rebase = false;
      commit.verbose = true;
      init.defaultBranch = "main";
      push.default = "current";
    };
    ignores = [ "target/*" ".dccache" ".idea/*" ];
    aliases = {
      ci = "commit";
      co = "checkout";
      fix = "commit --amend --no-edit";
      oops = "reset HEAD~1";
      please = "push --force-with-lease";
    };
    delta.enable = true;
    lfs.enable = true;
  };
}
