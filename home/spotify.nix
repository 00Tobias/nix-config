{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    spotify
    spicetify-cli # FIXME: Outdated, bump this?
  ];
  # TODO: Generate this with the nix INI format
  xdg.configFile."spicetify/config-xpui.ini" = {
    text = ''
      [Setting]
      prefs_path              = /home/toxic/.config/spotify/prefs
      replace_colors          = 1
      check_spicetify_upgrade = 0
      spotify_launch_flags    =
      spotify_path            = ${pkgs.spotify}/share/spotify
      current_theme           = SpicetifyDefault
      color_scheme            =
      inject_css              = 1
      overwrite_assets        = 0

      [Preprocesses]
      remove_rtl_rule       = 1
      expose_apis           = 1
      disable_upgrade_check = 1
      disable_sentry        = 1
      disable_ui_logging    = 1

      [AdditionalOptions]
      custom_apps =
      extensions  =

      [Patch]

      ; DO NOT CHANGE!
      [Backup]
      version =
    '';
  };
}
