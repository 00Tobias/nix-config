{ config, pkgs, ... }: {

  home = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
    };
    file."${config.home.homeDirectory}/.mozilla/firefox/toxic/chrome/lepton" = {
      recursive = true;
      source = (pkgs.fetchFromGitHub {
        owner = "black7375";
        repo = "Firefox-Ui-Fix";
        rev = "319c39dbd07da2ed763a44928803b3f66ffe018c";
        sha256 = "sha256-eGi0gkeqO2oVdwFU4cx7edYTq5Bo3YdnUjxutcO6HKM=";
      });
    };

    file."${config.home.homeDirectory}/.tridactylrc".text = ''
      " Set a dark colorscheme
      colors dark

      " Swap tab switching to make it make more sense with Vertical tabs
      bind J tabnext
      bind K tabprev

      " More Kakoune-like binds
      bind gk scrollto 0
      bind gj scrollto 100

      " Don't show the mode indicator on certain sites
      seturl youtube.com modeindicator false

      " Don't show the mode indicator in fullscreen
      autocmd FullscreenEnter .* set modeindicator false
      autocmd FullscreenLeft .* set modeindicator true
    '';
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
            "gfx.webrender.all" = true; # Enable Webrender
            "fission.autostart" = true; # Enable Fission
            "extensions.pocket.enabled" = false; # Disable Pocket
            "identity.fxaccounts.enabled" = false; # Disable Firefox account
            "ui.context_menus.after_mouseup" = true; # Fix behaviour with tiling window managers
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
            # Lepton stuff
            "svg.context-properties.content.enabled" = true;
            "layout.css.backdrop-filter.enabled" = true;
            "browser.compactmode.show" = true;
            "browser.urlbar.suggest.calculator" = true;
          };
          extraConfig = builtins.readFile (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/yokoffing/Better-Fox/master/user.js";
            sha256 = "sha256:1452756d84915f25dd7df9546f9801152ec950f30536717e7f9b377b634828b2";
          });
          userChrome = ''
            @import "lepton/userChrome.css";
            
            #TabsToolbar {
              display: none;
            }

            /* Vertical tabs with Sidebery */

            /* Sidebar min and max width removal */
            #sidebar {
                max-width: none !important;
                min-width: 0px !important;
            }

            #sidebar-header {
              display: none;
            }
          '';
          userContent = ''
            @import "lepton/userContent.css";
          '';
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
