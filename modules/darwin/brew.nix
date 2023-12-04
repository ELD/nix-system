{
  pkgs,
  lib,
  ...
}: {
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
    ];

    brews = [
      "mongodb-community"
    ];

    casks =
      [
        "1password"
        "adobe-acrobat-reader"
        "airbuddy"
        "alfred"
        "audacity"
        "bartender"
        "bettertouchtool"
        "boop"
        "coconutbattery"
        "cyberduck"
        "daisydisk"
        "dash"
        "deckset"
        "discord"
        "docker"
        "element"
        "elgato-stream-deck"
        "elgato-wave-link"
        "firefox-developer-edition"
        "google-chrome"
        "gpg-suite"
        "istat-menus"
        "iterm2-beta"
        "jetbrains-toolbox"
        "lm-studio"
        "lunar"
        "macfuse"
        "numi"
        "obsidian"
        "orbstack" # Docker Desktop replacement?
        "paw"
        "philips-hue-sync"
        "postman"
        "rectangle-pro"
        "screenflow"
        "sensei"
        "sketch"
        "tableplus"
        "visual-studio-code-insiders"
        "warp"
        "zoom"
        "zotero"
      ]
      ++ (lib.lists.optionals (pkgs.system == "x86_64-darwin") [
        "intel-power-gadget"
        "virtualbox"
      ]);

    masApps = {
      "1Blocker" = 1365531024;
      "1Password for Safari" = 1569813296;
      "Cardhop" = 1290358394;
      "Fantastical" = 975937182;
      "Pixelmator Pro" = 1289583905;
      "Slack" = 803453959;
      "Things 3" = 904280696;
      "Twitter" = 1482454543;

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
      "Structured" = 1499198946;

      "TestFlight" = 899247664;

      "Flighty" = 1358823008;
      "Kindle" = 302584613;
    };
  };
}
