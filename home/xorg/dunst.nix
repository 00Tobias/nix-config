{ config, pkgs, ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
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
        frame_width = 3;
        sort = true;
        font = "Cozette";
        word_wrap = true;
        markup = "full";
        show_indicators = true;
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;

        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
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
