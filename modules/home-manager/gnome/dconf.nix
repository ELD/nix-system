{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
      dynamic-workspaces = true;
      overlay-key = "";
    };

    "org/gnome/shell/keybindings" = {
      toggle-overview = [];
      toggle-overlay = [];
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
    };

    "org/gnome/system/location" = {enabled = true;};

    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = false;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "pop-shell@system76.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      activate-launcher = ["<Super>slash" "<Super>space"];
      activate-hint = true;
      gap-inner = mkUint32 1;
      gap-outer = mkUint32 1;
      hint-color-rgba = "rgba(226,108.251,0.72)";
      show-skip-taskbar = true;
      show-title = true;
      smart-gaps = false;
      tile-by-default = true;
      tile-enter = ["<Super>KP_Enter" "<Super>r"];
    };
  };
}
