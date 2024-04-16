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
    keybindings = {
      "cmd+w" = "close_window";
      "cmd+shift+n" = "new_os_window";
      "cmd+d" = "launch --location=hsplit --cwd=current";
      "cmd+shift+d" = "launch --location=vsplit --cwd=current";

      "cmd+t" = "new_tab";

      "cmd+]" = "next_window";
      "cmd+[" = "previous_window";

      "cmd+k" = "combine : clear_terminal scrollback active : send_text normal,application \\x0c";

      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";

      "cmd+left" = "send_text all \\x01";
      "cmd+right" = "send_text all \\x05";

      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";

      "cmd+equal" = "change_font_size all +2.0";
      "cmd+minsu" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";

      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
    };
    settings = {
      draw_minimal_borders = true;
      inactive_text_alpha = "0.7";
      hide_window_decorations = "no";

      macos_titlebar_color = "background";

      enabled_layouts = "splits";

      window_border_width = "0px";
      enable_audio_bell = "no";

      scrollback_lines = 4000;

      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
  };
}
