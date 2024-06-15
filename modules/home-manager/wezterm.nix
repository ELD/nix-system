_: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig =
      /*
      lua
      */
      ''
        local wezterm = require('wezterm')
        local act = wezterm.action

        local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
        local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

        function tab_title(tab_info)
          local title = tab_info.tab_title
          if title and #title > 0 then
            return title
          end

          return tab_info.active_pane.title
        end

        wezterm.on(
          "format-tab-title",
          function(tab, tabs, panes, config, hover, max_width)
            local edge_background = '#0b0022'
            local background = '#1b1032'
            local foreground = '#808080'

            if tab.is_active then
              background = "#2b2042"
              foreground = "#c0c0c0"
            elseif hover then
              background = "#3b3052"
              foreground = "#909090"
            end

            local edge_foreground = background

            local title = tab_title(tab)

            title = wezterm.truncate_right(title, max_width - 2)

            return {
              { Background = { Color = edge_background } },
              { Foreground = { Color = edge_foreground } },
              { Text = SOLID_LEFT_ARROW },
              { Background = { Color = background } },
              { Foreground = { Color = foreground } },
              { Text = title },
              { Background = { Color = edge_background } },
              { Foreground = { Color = edge_foreground } },
              { Text = SOLID_RIGHT_ARROW },
            }
          end
        )

        return {
          window_decorations = "RESIZE",
          color_scheme = 'Rosé Pine Moon (Gogh)',
          font_size = 20,
          font = wezterm.font({
            family = 'BerkeleyMono Nerd Font',
            harfbuzz_features = { 'calt=1', 'dlig=1', 'liga=1' }
          }),
          freetype_load_flags = "NO_HINTING",
          freetype_load_target = "Normal",
          front_end = "WebGpu",
          line_height = 1.2,
          use_fancy_tab_bar = true,
          keys = {
            {
              key = "Enter",
              mods = "META",
              action = act.SendKey { key = "Enter", mods = "META" },
            },
            {
              key = "k",
              mods = "SUPER|SHIFT",
              action = act.ClearScrollback "ScrollbackOnly",
            },
            {
              key = "k",
              mods = "SUPER",
              action = act.ClearScrollback "ScrollbackAndViewport",
            },
          },
          window_frame = {
            font_size = 18.0,
            font = wezterm.font({
              family = "BerkeleyMono Nerd Font",
              harfbuzz_features = { 'calt=1', 'dlig=1', 'liga=1' },
            }),
          },
        }
      '';
  };
}
