{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    autoUpdate = true;
    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
      "teamookla/speedtest"
    ];

    brews = [ ];
  };
}
