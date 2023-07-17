{pkgs, ...}: {
  home.packages = with pkgs; [
    # Cargo utilities
    cargo-nextest
    cargo-expand
    cargo-outdated
    cargo-shuttle
    cargo-sweep
    cargo-vet
    cargo-wipe
    diesel-cli
    # evcxr
    sqlx-cli

    # Rust CLI utilities
    du-dust

    # Rust/LLVM linkers
    mold
  ];

  home.file.".cargo/config.toml".source = (pkgs.formats.toml {}).generate "cargo-config" {
    build = {
      rustc-wrapper = "${pkgs.sccache}/bin/sccache";
    };
    target.x86_64-unknown-linux-gnu = {
      linker = "clang";
      rustflags = ["-C" "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"];
    };
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
