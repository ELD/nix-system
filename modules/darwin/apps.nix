{ config, lib, pkgs, ... }: {
  homebrew = {
    # Uninstall all brews that aren't in the Brewfile(s)
    cleanup = "zap";

    casks = [
      "1password"
      "airbuddy"
      "bartender"
      "bettertouchtool"
      "daisydisk"
      "dash"
      "discord"
      "docker"
      "firefox-developer-edition"
      "google-chrome"
      "gpg-suite"
      "hookshot"
      # Check the system before installing
      # "intel-power-gadget"
      "istat-menus"
      "iterm2"
      "jetbrains-toolbox"
      "microsoft-teams"
      "numi"
      "obsidian"
      "paw"
      "screenflow"
      "sensei"
      "sketch"
      "tableplus"
      # No support for Apple Silicon yet
      # "virtualbox"
      "visual-studio-code"
      "zoom"
      "zotero"
    ];

    masApps = {
      "1Blocker" = 1365531024;
      "Cardhop" = 1290358394;
      "Fantastical" = 975937182;
      # "JSONPeep for Safari" = 11458969831;
      "Pipifier" = 1160374471;
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
    };
  };
}
