{ config, pkgs, ... }: {

  home = {
    file."${config.home.homeDirectory}/.mozilla/firefox/toxic/chrome/lepton" = {
      recursive = true;
      source = (pkgs.fetchFromGitHub {
        owner = "black7375";
        repo = "Firefox-Ui-Fix";
        rev = "87ce645514c17d9674d7cb1a3dbe63d392f52d67";
        sha256 = "lb4efUeMEB2dkhkOzg5h01C/zIfoCpKYmiYp/0x2TDk=";
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

      " Leave Control + E to Sidebery
      unbind <C-e>

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
      # NOTE: The following causes Firefox not to build, due to some gtk3 buildInput error...
      # Strange behaviour, have to look into that.
      # package = pkgs.firefox.override {
      #   cfg = {
      #     # Tridactyl native connector
      #     enableTridactylNative = true;
      #   };
      # };

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
            # Betterfox overrides FIXME: doesn't do shit lol
            "browser.search.separatePrivateDefault" = false;
            "browser.search.separatePrivateDefault.ui.enabled" = false;
          };
          extraConfig = builtins.readFile (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/yokoffing/Better-Fox/master/user.js";
            sha256 = "0agp657jkl2i3chmxgf5jdk69lm9sycx1r0zkgz5xg0v5748r6hb";
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

            /* Center bookmarks toolbar */
            #PlacesToolbarItems{ -moz-box-pack: center }
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
        darkreader
        privacy-redirect
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
