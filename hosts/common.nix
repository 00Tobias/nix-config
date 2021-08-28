{ config, pkgs, ... }: {
  services = {
    dbus.packages = with pkgs; [ gnome3.dconf ]; # Fixes GTK themes
  };
  fonts = {
    fonts = with pkgs; [
      cozette
      hack-font
    ];
    enableDefaultFonts = true;
    fontconfig = {
      allowBitmaps = true;
      defaultFonts = {
        monospace = [ "Hack" ];
      };
    };
  };
}
