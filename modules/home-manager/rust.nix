{pkgs, ...}: {
  home.packages = with pkgs;
    [
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
    ]
    ++ (lib.lists.optionals (pkgs.system == "x86_64-linux") [
      # Rust/LLVM linkers (Linux-only)
      mold
    ]);

  home.file.".cargo/config.toml".source = (pkgs.formats.toml {}).generate "cargo-config" {
    build = {
      rustc-wrapper = "${pkgs.sccache}/bin/sccache";
    };
    target.x86_64-unknown-linux-gnu = {
      linker = "clang";
      rustflags = ["-C" "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"];
    };
    target.aarch64-apple-darwin = {
      rustflags = ["-C" "link-arg=-ld_new"];
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
