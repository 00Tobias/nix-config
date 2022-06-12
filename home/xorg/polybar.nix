{ config, pkgs, ... }:
let
  colors = import ../colors.nix;
in
{
  home.packages = [ pkgs.cozette ];
  services.polybar = with colors.theme; {
    enable = true;
    script = ''
      polybar main &
      polybar secondary &
    '';
    settings = {
      "bar/main" = {
        monitor = "DP-0";
        width = "100%";
        height = "35";
        padding = "5";

        font = [ "Cozette" ];
        foreground = "${foreground}";
        background = "${background}";

        scroll-up = "bspwm.prev";
        scroll-down = "bspwm.next";
        modules-left = "bspwm";
        modules-center = "title";
        modules-right = "date";
      };

      "bar/secondary" = {
        "inherit" = "bar/main";
        monitor = "HDMI-1";
      };

      "module/bspwm" = {
        type = "internal/bspwm";
      };

      "module/title" = {
        type = "internal/xwindow";
      };

      "module/date" = {
        type = "internal/date";
        date = "%Y-%m-%d%";
      };
    };
  };
}
