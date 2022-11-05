{ pkgs, ... }: {
  imports = [
    ../common.nix
    ./core.nix
    ./brew.nix
    ./preferences.nix
    ./security.nix
    # ./display-manager.nix
  ];
}
