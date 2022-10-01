{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    autoUpdate = true;
    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
      "teamookla/speedtest"
      "mongodb/brew"
    ];

    brews = [ ];
  };
}
