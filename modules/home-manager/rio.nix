_: {
  programs.rio = {
    enable = true;
    settings = {
      editor = "nvim";
      blinking-cursor = true;
      theme = "rose-pine-moon";
      option-as-alt = "both";
      window = {
        mode = "Maximized";
        decorations = "Enabled";
      };
      renderer = {
        performance = "High";
        backend = "Automatic";
        disable-unfocused-render = false;
      };
      fonts = {
        family = "BerkeleyMono Nerd Font Mono";
        size = 22;
      };
      navigation = {
        mode = "NativeTab";
        clickable = true;
      };
    };
  };
}
