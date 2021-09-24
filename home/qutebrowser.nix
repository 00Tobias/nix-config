{ config, pkgs, ... }:
let
  colors = import ./colors.nix;
in
{
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true; # For notification prompts
    settings = {
      auto_save.session = true;
      session.lazy_restore = true;
      qt.args = [ "enable-gpu-rasterization" "enable-accelerated-video-decode" ];

      completion.web_history.exclude = [
        "*://duckduckgo.com/*"
        "*://twitter.com/*"
        "*://*.youtube.com/*"
        "*://*.reddit.com/r/*"
      ];

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
        position = "right";
      };

      downloads.position = "bottom";

      fonts.default_family = "Hack Nerd Font";

      colors = with colors.theme; {
        webpage.preferred_color_scheme = "dark";

        completion = {
          fg = "${lighterGrey}";
          odd.bg = "${background}";
          even.bg = "${background}";
          category = {
            fg = "${blue}";
            bg = "${background}";
            border.top = "${background}";
            border.bottom = "${background}";
          };
          item.selected = {
            fg = "${lighterGrey}";
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
          error.border = "${red}";
          warning.fg = "${background}";
          warning.bg = "${magenta}";
          warning.border = "${magenta}";
          info.fg = "${lighterGrey}";
          info.bg = "${background}";
          info.border = "${background}";
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

        webpage.bg = "${background}";
      };
    };
    keyBindings = {
      normal = {
        "gk" = "scroll-to-perc 0";
        "gj" = "scroll-to-perc 100";
        "<Ctrl-z>" = "config-cycle tabs.position right top";
        "+" = "zoom-in";
        "-" = "zoom-out";
      };
      insert = {
        "<Ctrl-E>" = "open-editor";
      };
    };
    extraConfig = ''
      c.statusbar.padding = {
        "bottom": 2,
        "left": 1,
        "right": 1,
        "top": 2
      }

      c.tabs.padding = {
        "bottom": 2,
        "left": 5,
        "right": 5,
        "top": 2
      }
    '';
  };
}
