{ config, lib, pkgs, ... }: {
  homebrew = {
    # Uninstall all brews that aren't in the Brewfile(s)
    onActivation.cleanup = "zap";

    casks = [
      "1password"
      "airbuddy"
      "alfred"
      "audacity"
      "bartender"
      "bettertouchtool"
      "boop"
      "cyberduck"
      "daisydisk"
      "dash"
      "deckset"
      "discord"
      "docker"
      "element"
      "elgato-wave-link"
      "firefox-developer-edition"
      "google-chrome"
      "gpg-suite"
      "hookshot"
      "istat-menus"
      "iterm2"
      "jetbrains-toolbox"
      "macfuse"
      "numi"
      "obsidian"
      "paw"
      "postman"
      "screenflow"
      "sensei"
      "sketch"
      "tableplus"
      "veracrypt"
      "visual-studio-code"
      "zoom"
      "zotero"
    ] ++ (lib.lists.optionals (pkgs.system == "x86_64-darwin") [
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

      "TestFlight" = 899247664;
    };
  };
}
