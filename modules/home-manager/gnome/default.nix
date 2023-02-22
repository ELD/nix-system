{pkgs, ...}: {
  imports = [./dconf.nix];

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.pop-icon-theme;
      name = "Pop";
    };

    theme = {
      package = pkgs.pop-gtk-theme;
      name = "Pop";
    };

    gtk3.extraConfig = {
      gtk-icon-theme-name = "Pop";
      gtk-theme-name = "Pop";
      gtk-application-prefer-dark-theme = 1;
    };
  };
  services.gnome-keyring.enable = true;
}
