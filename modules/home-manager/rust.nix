{pkgs, ...}: {
  home.packages = with pkgs; [
    cargo-nextest
    cargo-expand
    cargo-outdated
    cargo-sweep
    cargo-wipe
    mold
    sqlx-cli
  ];

  home.file.".cargo/config.toml".source = (pkgs.formats.toml {}).generate "cargo-config" {
    # Commented out, for now, since mold doesn't seem to work on aarch64-darwin
    # target = {
    #   x86_64-unknown-linux-gnu = {
    #     linker = "clang";
    #     rustflags = ["-C" "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"];
    #   };
    #   aarch64-apple-darwin = {
    #     linker = "clang";
    #     rustflags = ["-C" "link-arg=-fuse-ld=${pkgs.mold}/bin/ld64.mold"];
    #   };
    #   x86_64-apple-darwin = {
    #     linker = "clang";
    #     rustflags = ["-C" "link-arg=-fuse-ld=${pkgs.mold}/bin/ld64.mold"];
    #   };
    # };
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
