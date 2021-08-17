{ config, pkgs, ... }: {

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

  programs = {
    firefox = {
      enable = true;
      # package = pkgs.firefox-wayland;
      package = pkgs.firefox.override {
        cfg = {
          # Gnome shell native connector
          enableGnomeExtensions = true;
          # Tridactyl native connector
          enableTridactylNative = true;
        };
      };

      profiles = {
        toxic = {
          name = "toxic";
          id = 0;
          isDefault = true;
          settings = {
            "gfx.webrender.all" = true;
          };
        };
        spotify = {
          name = "spotify";
          id = 1;
          isDefault = false;
          settings = {
            "gfx.webrender.all" = true;
          };
        };
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        browserpass
        clearurls
        sidebery
        sponsorblock
        tabliss
        tridactyl
        ublock-origin
      ];
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };
}
