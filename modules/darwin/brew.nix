{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    global = {
      brewfile = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
      "koekeishiya/formulae"
      "teamookla/speedtest"
      "mongodb/brew"
      "mrkai77/cask"
    ];

    brews = [
      "mongodb-community"
    ];

    casks = [
      "1password"
      "airbuddy"
      "alfred"
      "audacity"
      "bartender"
      "bettertouchtool"
      "coconutbattery"
      "cyberduck"
      "daisydisk"
      "dash"
      "deckset"
      "discord"
      "element"
      "elgato-stream-deck"
      "elgato-wave-link"
      "firefox-developer-edition"
      "google-chrome"
      "gpg-suite"
      "istat-menus"
      "iterm2@beta"
      "jetbrains-toolbox"
      "loop"
      "lunar"
      "macfuse"
      "monodraw"
      "numi"
      "obs"
      "obsidian"
      "orbstack" # Docker Desktop replacement?
      "paw"
      "philips-hue-sync"
      "postman"
      "raycast"
      "rectangle-pro"
      "screenflow"
      "sensei"
      "sketch"
      "tableplus"
      "visual-studio-code@insiders"
      "warp"
      "zoom"
      "zotero"
    ];

    masApps = {
      "1Blocker" = 1365531024;
      "1Password for Safari" = 1569813296;
      "Cardhop" = 1290358394;
      "Fantastical" = 975937182;
      "Pile" = 1549454338;
      "Pixelmator Pro" = 1289583905;
      "Slack" = 803453959;
      "Things 3" = 904280696;

      "Pages" = 409201541;
      "Keynote" = 409203825;
      "Numbers" = 409183694;

      "MainStage 3" = 634159523;
      "Logic Pro X" = 634148309;

      "Final Cut Pro" = 424389933;

      "iA Writer" = 775737590;
      "MindNode" = 1289197285;
      "UlyssesMac" = 1225570693;

      "Xcode" = 497799835;

      "Day Progress" = 6450280202;
      # "Structured" = 1499198946;

      "TestFlight" = 899247664;

      "Flighty" = 1358823008;
      "Kindle" = 302584613;
    };
  };
}
