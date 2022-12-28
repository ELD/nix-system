{pkgs, ...}: {
  home.packages = with pkgs; [
    cargo-nextest
    cargo-expand
    cargo-outdated
    cargo-sweep
    cargo-wipe
    sqlx-cli
  ];

  home.file.".cargo/config.toml".source = (pkgs.formats.toml {}).generate "cargo-config" {
    alias = {
      b = "build";
      t = "test";
      c = "clippy";
      r = "run";
      rr = "run --release";
      br = "build --release";
    };
  };
}
