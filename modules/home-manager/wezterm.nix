_: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require('wezterm')
      local act = wezterm.action
      return {
        color_scheme = 'Rosé Pine Moon (Gogh)',
        font_size = 20,
        font = wezterm.font {
          family = 'BerkeleyMono Nerd Font Mono',
          harfbuzz_features = { 'calt=1', 'dlig=1', 'liga=1' }
        },
        use_fancy_tab_bar = true,
        keys = {
          {
            key = "Enter",
            mods = "META",
            action = act.SendKey { key = "Enter", mods = "META" },
          },
          {
            key = "K",
            mods = "SUPER",
            action = act.ClearScrollback "ScrollbackAndViewport",
          },
        },
      }
    '';
  };
}
