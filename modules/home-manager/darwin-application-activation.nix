{
  lib,
  pkgs,
  config,
  ...
}: {
  home.activation.darwinApps =
    if pkgs.stdenv.isDarwin
    then
      lib.hm.dag.entryAfter ["writeBoundary"]
      /*
      bash
      */
      ''
        app_folder="${config.home.homeDirectory}/Applications/Home Manager Apps"
        rm -rf "$app_folder"
        mkdir -p "$app_folder"
        find "$newGenPath/home-path/Applications" -type l -print | while read -r app; do
          app_target="$app_folder/$(basename "$app")"
          real_app="$(readlink "$app")"
          echo "mkalias \"$real_app\" \"$app_target\"" >&2
          $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_target"
        done
      ''
    else "";
}
