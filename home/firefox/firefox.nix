{ config, pkgs, ... }: {
  home = {
    file.".mozilla/firefox/toxic/chrome/lepton" = {
      recursive = true;
      source = (pkgs.fetchFromGitHub {
        owner = "black7375";
        repo = "Firefox-Ui-Fix";
        rev = "2c50ba45dd0953d4cd5fe1c5d693079a67588f4f";
        sha256 = "nf08p9Edhug07wnaqZuptdrql5usOrzAwCLTDNmUuZs=";
      });
    };
  };

  programs = {
    firefox = {
      enable = true;
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
            url = "https://raw.githubusercontent.com/yokoffing/Better-Fox/41d94c01d19505f726fddbea7e431737d78b8724/user.js";
            sha256 = "1xv55z97h3wyjlczdi1g1qih6d8rmm0lv31xs878yr8kfh6qd6m7";
          });
          userChrome = ''
            @import "lepton/userChrome.css";

            #TabsToolbar {
              display: none;
            }

            #sidebar {
                max-width: none !important;
                min-width: 0px !important;
            }

            #sidebar-header {
              display: none;
            }

            #PlacesToolbarItems{ -moz-box-pack: center }
          '';
          userContent = ''
            @import "lepton/userContent.css";
          '';
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
