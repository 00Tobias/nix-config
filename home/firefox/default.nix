{ config, pkgs, ... }: {
  home = {
    packages = [ pkgs.noto-fonts ];
    file.".mozilla/firefox/toxic/chrome/lepton" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "black7375";
        repo = "Firefox-Ui-Fix";
        rev = "272fda96a4c17112a715c7e61a288a18cd42990e";
        sha256 = "Lto5X96MyNpTYuqlkFO1lTPixL+gqMxqtwlxzz0ruJ8=";
      };
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
            # "ui.context_menus.after_mouseup" = true; # Fix behaviour with tiling window managers
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css

            # Lepton stuff
            "svg.context-properties.content.enabled" = true;
            "layout.css.backdrop-filter.enabled" = true;
            "browser.compactmode.show" = true;
            "browser.urlbar.suggest.calculator" = true;
          };
          # user.js plus fixes
          extraConfig = ''
            ${builtins.readFile (builtins.fetchurl {
              url = "https://raw.githubusercontent.com/yokoffing/Better-Fox/74da6ae43374ff04740397a50538d499935cefb3/user.js";
              sha256 = "11x39wfqm0hmmw802zskllgff9i0pbjn8xgpd4qg5j8rhgw3zc50";
            })}
            user_pref("browser.search.separatePrivateDefault", false);
            user_pref("browser.search.separatePrivateDefault.ui.enabled", false);
            user_pref("browser.search.suggest.enabled", true);
            user_pref("privacy.cpd.history", false);
            user_pref("privacy.cpd.formdata", false);
            user_pref("privacy.cpd.offlineApps", false);
            user_pref("privacy.cpd.cache", false);
            user_pref("privacy.cpd.cookies", false);
            user_pref("privacy.cpd.sessions", false);

            ${builtins.readFile (builtins.fetchurl {
              url = "https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/272fda96a4c17112a715c7e61a288a18cd42990e/user.js";
              sha256 = "0hrjw4fbad2wywinzjs67m2swf6fwv03p7r0llxflycacww03nqs";
            })}
          '';
          userChrome = ''
            @import "lepton/css/leptonChrome.css";

            #webrtcIndicator {
              display: none;
            }

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

            #PlacesToolbarItems {
              -moz-box-pack: center;
            }
          '';
          userContent = ''
            @import "lepton/css/leptonContent.css";
          '';
        };
      };
    };
  };
}
