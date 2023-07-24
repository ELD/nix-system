{lib, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "[░▒▓](#A3AED2)"
        "[  ](bg:#A3AED2 fg:#090c0c)"
        "[](bg:#769FF0 fg:#A3AED2)"
        "$directory"
        "[](fg:#769FF0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#212736)"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "[](fg:#212736 bg:#1D2230)"
        "$time"
        "[ ](fg:#1D2230)"
        "$character"
      ];

      directory = {
        style = "fg:#E3E5E5 bg:#769FF0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769FF0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769FF0 bg:#394260)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769FF0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769FF0 bg:#212736)]($style)";
      };

      golang = {
        symbol = " ";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769FF0 bg:#212736)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769FF0 bg:#212736)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#1D2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1D2230)]($style)";
      };

      username = {
        show_always = true;
        style_user = "fg:#769FF0 bg:#212736";
        style_root = "fg:#769FF0 bg:#212736";
        format = "[$user ]($style)";
        disabled = false;
      };

      os = {
        style = "fg:#769FF0 bg:#212736";
        disabled = true; # Disabled by default
      };

      docker_context = {
        symbol = " ";
        style = "fg:#769FF0 bg:#212736";
        format = "[ $symbol $context ]($style)$path";
      };

      haskell = {
        symbol = " ";
        style = "fg:#769FF0 bg:#212736";
        format = "[ $symbol ($version) ]($style)";
      };
    };
  };
}
