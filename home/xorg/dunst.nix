{ config, pkgs, ... }: 
let
  colors = import ../colors.nix;
in
{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    settings = with colors.theme; {
      global = {
        monitor = 0;
        follow = "none";
        geometry = "300x5-20+44";

        progress_bar = true;
        indicate_hidden = true;
        stack_duplicates = true;
        hide_duplicate_count = false;
        separator_height = 0;
        padding = 8;
        horizontal_padding = 8;
        shrink = false;
        frame_width = 2;
        sort = true;

        font = "Hack";
        word_wrap = true;
        markup = "full";

        show_indicators = true;
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;

        background = "${background}";
        frame_color = "${darkGrey}";

        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        fullscreen = "delay";
      };

      urgency_normal = {
        fullscreen = "delay";
      };

      urgency_critical = {
        fullscreen = "show";
        background = "${red}";
      };

      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
    };
  };
}
