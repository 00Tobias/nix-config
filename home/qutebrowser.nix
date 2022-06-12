{ config, pkgs, ... }:
let
  colors = import ./colors.nix;
in
{
  home.packages = with pkgs; [
    cozette

    # For qute-bitwarden
    bitwarden-cli
    keyutils
    python3Packages.tldextract
  ];
  # Discord desktop entry using QB
  xdg.desktopEntries = {
    discordQB = {
      name = "Discord (QB)";
      icon = "discord";
      exec = "qutebrowser --target window -- https://discord.com/app";
    };
  };
  # Userscripts
  xdg.dataFile = {
    # FrankerfaceZ for Twitch
    "qutebrowser/greasemonkey/ffz_injector.user.js".source = pkgs.fetchurl {
      url = "https://cdn.frankerfacez.com/static/ffz_injector.user.js";
      sha256 = "0vl038x7mm98ghrirr5zcdv24zmhfaj7mrygcm07qs6dri99yjsl";
    };
    # Screensharing with audio for Discord
    "qutebrowser/greasemonkey/screenshare_with_audio.user.js".source = pkgs.fetchurl {
      url = "https://openuserjs.org/install/samantas5855/Screenshare_with_Audio.min.user.js";
      sha256 = "1hg01mahf12llr5nn4klsaa35fgc7j4czf31nb0ph0567ags7xqj";
    };
  };
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true; # For notification prompts
    searchEngines.DEFAULT = "https://kagi.com/search?q={}";
    keyBindings = {
      normal = {
        "gk" = "scroll-to-perc 0";
        "gj" = "scroll-to-perc 100";
        "e" = "config-cycle statusbar.show always never";
        "E" = "config-cycle tabs.position right top";
        "z" = "spawn --userscript qute-bitwarden";
        "+" = "zoom-in";
        "-" = "zoom-out";
      };
      insert = {
        "<Ctrl-E>" = "open-editor";
      };
    };
    extraConfig = ''
      c.statusbar.padding = {
        "bottom": 8,
        "left": 2,
        "right": 2,
        "top": 8
      }

      c.tabs.padding = {
        "bottom": 8,
        "left": 5,
        "right": 5,
        "top": 8
      }
    '';
    settings = {
      auto_save.session = false;
      session.lazy_restore = true;
      qt.args = [ "ignore-gpu-blocklist" "enable-gpu-rasterization" "enable-accelerated-video-decode" "enable-features=WebRTCPipeWireCapturer" ];

      url.start_pages = "https://kagi.com/";

      completion.web_history.exclude = [
        "*://kagi.com/*"
        "*://duckduckgo.com/*"
        "*://www.google.com/*"
        "*://twitter.com/*"
        "*://twitch.com/videos/*"
        "*://discord.com/*"
        "*://piped.kavin.rocks/*"
        "*://*.youtube.com/*"
        "*://*.reddit.com/r/*"
      ];

      content.autoplay = false;
      content.blocking = {
        enabled = true;
        method = "adblock";
        adblock.lists = [
          "https://easylist.to/easylist/easylist.txt"
          "https://easylist.to/easylist/easyprivacy.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt"
          "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt"
          "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
          "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
          "https://hosts.netlify.app/Pro/adblock.txt"
          "https://filters.adtidy.org/extension/ublock/filters/2.txt"
        ];
      };

      tabs = {
        indicator.width = 0;
        title.format = "{audio}{current_title} {private}"; # {index}:
        background = true;
        show = "multiple";
        position = "top";
      };

      statusbar = {
        show = "never";
        position = "top";
      };

      downloads.position = "bottom";

      fonts.default_family = "cozette";

      colors = with colors.theme; {
        # Dark theme
        webpage = {
          preferred_color_scheme = "dark";
          darkmode.enabled = true;
          darkmode.policy.images = "never";
          bg = "${background}";
        };

        completion = {
          fg = "${foreground}";
          odd.bg = "${background}";
          even.bg = "${background}";
          category = {
            fg = "${blue}";
            bg = "${background}";
            border.top = "${background}";
            border.bottom = "${background}";
          };
          item.selected = {
            fg = "${foreground}";
            bg = "${darkGrey}";
            border.top = "${darkGrey}";
            border.bottom = "${darkGrey}";
            match.fg = "${lighterGrey}";
          };
          match.fg = "${orange}";
          scrollbar.fg = "${lighterGrey}";
          scrollbar.bg = "${background}";
        };

        contextmenu = {
          disabled.bg = "${darkerGrey}";
          disabled.fg = "${lightGrey}";
          menu.bg = "${background}";
          menu.fg = "${lighterGrey}";
          selected.bg = "${darkGrey}";
          selected.fg = "${lighterGrey}";
        };

        downloads = {
          bar.bg = "${background}";
          start.fg = "${background}";
          start.bg = "${blue}";
          stop.fg = "${background}";
          stop.bg = "${teal}";
          error.fg = "${red}";
        };

        hints = {
          fg = "${background}";
          bg = "${yellow}";
          match.fg = "${lighterGrey}";
        };

        keyhint = {
          fg = "${lighterGrey}";
          suffix.fg = "${lighterGrey}";
          bg = "${background}";
        };

        messages = {
          error.fg = "${background}";
          error.bg = "${red}";
          # error.border = "${red}";
          warning.fg = "${background}";
          warning.bg = "${magenta}";
          # warning.border = "${magenta}";
          info.fg = "${lighterGrey}";
          info.bg = "${background}";
          # info.border = "${background}";
        };

        prompts = {
          fg = "${lighterGrey}";
          border = "${background}";
          bg = "${background}";
          selected.bg = "${darkGrey}";
          selected.fg = "${lighterGrey}";
        };

        statusbar = {
          normal.fg = "${lighterGrey}";
          normal.bg = "${background}";
          insert.fg = "${teal}";
          insert.bg = "${background}";
          passthrough.fg = "${yellow}";
          passthrough.bg = "${background}";
          private.fg = "${magenta}";
          private.bg = "${background}";
          command.fg = "${lightGrey}";
          command.bg = "${darkerGrey}";
          command.private.fg = "${magenta}";
          command.private.bg = "${darkerGrey}";
          caret.fg = "${blue}";
          caret.bg = "${background}";
          caret.selection.fg = "${blue}";
          caret.selection.bg = "${background}";
          progress.bg = "${blue}";
          url.fg = "${lighterGrey}";
          url.error.fg = "${red}";
          url.hover.fg = "${orange}";
          url.success.http.fg = "${green}";
          url.success.https.fg = "${green}";
          url.warn.fg = "${magenta}";
        };

        tabs = {
          bar.bg = "${background}";
          indicator.start = "${blue}";
          indicator.stop = "${teal}";
          indicator.error = "${red}";
          odd.fg = "${lighterGrey}";
          odd.bg = "${background}";
          even.fg = "${lighterGrey}";
          even.bg = "${background}";
          pinned = {
            even.bg = "${green}";
            even.fg = "${background}";
            odd.bg = "${green}";
            odd.fg = "${background}";
            selected = {
              even.bg = "${darkGrey}";
              even.fg = "${lighterGrey}";
              odd.bg = "${darkGrey}";
              odd.fg = "${lighterGrey}";
            };
          };
          selected = {
            odd.fg = "${lighterGrey}";
            odd.bg = "${darkGrey}";
            even.fg = "${lighterGrey}";
            even.bg = "${darkGrey}";
          };
        };
      };
    };
  };
}
