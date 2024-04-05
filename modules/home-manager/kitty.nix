_: {
  programs.kitty = {
    enable = true;
    font = {
      name = "OperatorMonoSSmLig Nerd Font Mono";
      size = 18;
    };
    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Macchiato";
    extraConfig = builtins.concatStringsSep "\n" [
      "font_features OperatorMonoSSmLigNFM +ss01 +ss03 +ss05 +ss08 +ss09 +ss10 +ss11 +ss12"
      "font_features OperatorMonoSSmLigNFM-Bold +ss01 +ss03 +ss05 +ss08 +ss09 +ss10 +ss11 +ss12"
      "font_features OperatorMonoSSmLigNFM-Italic +ss01 +ss03 +ss05 +ss08 +ss09 +ss10 +ss11 +ss12"
      "font_features OperatorMonoSSmLigNFM-BoldItalic +ss01 +ss03 +ss05 +ss08 +ss09 +ss10 +ss11 +ss12"
    ];
    settings = {
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
  };
}
