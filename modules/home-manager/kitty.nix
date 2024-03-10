_: {
  programs.kitty = {
    enable = true;
    font = {
      name = "OperatorMonoSSmLig Nerd Font Regular";
      size = 18;
    };
    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Macchiato";
    settings = {
      bold_font = "OperatorMonoSSmLig Nerd Font Bold";
      italic_font = "OperatorMonoSSmLig Nerd Font Italic";
      bold_italic_font = "OperatorMonoSSmLig Nerd Font Bold Italic";
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      extra_config = ''
        "OperatorMonoSSmLigNFM +calt +lig +dlig +ss01 +ss02 +ss03 +ss05 +ss06 +ss08 +ss12"
        "OperatorMonoSSmLigNFM-Bold +calt +lig +dlig +ss01 +ss02 +ss03 +ss05 +ss06 +ss08 +ss12"
        "OperatorMonoSSmLigNFM-Italic +calt +lig +dlig +ss01 +ss02 +ss03 +ss05 +ss06 +ss08 +ss12"
        "OperatorMonoSSmLigNFM-BoldItalic +calt +lig +dlig +ss01 +ss02 +ss03 +ss05 +ss06 +ss08 +ss12"
      '';
    };
  };
}
