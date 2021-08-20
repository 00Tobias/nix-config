{ config, pkgs, ... }: {
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

      # Dark theme
      colors.webpage.preferred_color_scheme = "dark";
      colors.webpage.bg = "black";

      # Adblock
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

      # Tabs
      tabs = {
        indicator.width = 0;
        # padding = ''{ "bottom": 2, "left": 5, "right": 5, "top": 2 }''; # this needs to be in extraConfig, that's dumb
        title.format = "{audio}{current_title} {private}"; # {index}:
        background = true;
        show = "multiple";
        position = "right";
      };

      # Statusbar
      # statusbar.padding = ''{ "bottom": 2 "left": 1, "right": 1, "top": 2}''; # Same with this

      # Downloads
      downloads.position = "bottom";

      # Fonts
      fonts.default_family = "Cozette";
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
    extraConfig = builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/theova/base16-qutebrowser/main/themes/minimal/base16-onedark.config.py";
      sha256 = "sha256:320a51aa400c0524ec307b2721be1267afb4fb6445e878eabcac435d879e3968";
    });
  };
}
