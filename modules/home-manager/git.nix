{pkgs, ...}: {
  home.packages = [pkgs.github-cli];
  programs.git = {
    userName = "Eric Dattore";
    enable = true;
    extraConfig = {
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin
        then "osxkeychain"
        else "cache --timeout=1000000000";
      http.sslVerify = true;
      pull.rebase = false;
      commit.verbose = true;
      init.defaultBranch = "main";
      push.default = "current";
    };
    ignores = ["target/*" ".dccache" ".idea/*" ".vscode/"];
    aliases = {
      ci = "commit";
      co = "checkout";
      fix = "commit --amend --no-edit";
      ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
      oops = "reset HEAD~1";
      please = "push --force-with-lease";
    };
    delta.enable = true;
    lfs.enable = true;
  };
}
