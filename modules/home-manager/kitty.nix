_: {
  programs.kitty = {
    enable = true;
    font = {
      name = "MonispaceNE NFP";
      size = 16;
    };
    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Macchiato";
    settings = {
      font_features = "MonispaceNeNFM-Regular +calt +liga +dlig +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07 +ss08";
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
  };
}
