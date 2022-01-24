{ config, pkgs, ... }: {
  home = {
    file.".mozilla/firefox/toxic/chrome/lepton" = {
      recursive = true;
      source = (pkgs.fetchFromGitHub {
        owner = "black7375";
        repo = "Firefox-Ui-Fix";
        rev = "23af4e43a9af9d9faa006c87d5266cf590dc953c";
        sha256 = "eEpElBl69w8DLzF+M8q6WASUhIcEZ17UCX8RiW8h5nQ=";
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
            url = "https://raw.githubusercontent.com/yokoffing/Better-Fox/14b7563f89689663d889244e413ada27f9bcaf21/user.js";
            sha256 = "10f8p2p2frlmj3amagr2067r3mz0q0jndc85j24gba2j9mds1z6l";
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
        ublock-origin
      ];
    };
    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };
}
