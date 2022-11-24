{
  projectRootFile = "flake.lock";
  programs = {
    alejandra.enable = true;
    black.enable = true;
    gofmt.enable = true;
    prettier.enable = true;
    rufo.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
  };
}
