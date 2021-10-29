{ lib, config, pkgs, ... }:
let
  colors = import ../colors.nix;
in
{

  home.packages = with pkgs; [
    # SDL2 # Useful if you're overriding Steam's SDL, which itself hasn't proved very useful
    glib # I am peeved that gtk doesn't respect my config file on wayland >:(
    capitaine-cursors # Cursor theme

    # DIY Wayland dmenu
    j4-dmenu-desktop
    fzf

    wl-clipboard
    sway-contrib.grimshot
    swaylock-fancy
    autotiling
  ];

  wayland = {
    windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = with colors.theme; {
        input = {
          "*" = {
            xkb_layout = "se";
          };
        };
        output = {
          "*" = {
            bg = "/tmp/wallpapers/* fill";
          };
          HDMI-A-2 = { transform = "90"; };
        };
        seat = {
          "*" = {
            hide_cursor = "8000";
          };
          "seat0" = {
            xcursor_theme = "capitaine-cursors";
          };
        };
        modifier = "Mod4";
        focus.mouseWarping = false;
        # The 'bash -c' is kinda strange, but that's how it is
        menu = ''${pkgs.foot}/bin/foot -T "floating-terminal" bash -c '${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --dmenu="${pkgs.fzf}/bin/fzf" --term="foot" --no-exec | ${pkgs.findutils}/bin/xargs swaymsg exec --' '';
        terminal = "foot";

        defaultWorkspace = "workspace number 1";
        assigns = {
          "workspace number 7" = [{ class = "^Steam$"; }];
          "workspace number 6" = [{ class = "^Ripcord$"; } { class = "^discord$"; }];
        };
        floating.criteria = [
          { title = "floating-terminal"; }
          { class = "^Steam$"; title = "^Friends$"; }
          { class = "^Steam$"; title = "Steam - News"; }
          { class = "^Steam$"; title = ".* - Chat"; }
          { class = "^Steam$"; title = "^Settings$"; }
          { class = "^Steam$"; title = ".* - event started"; }
          { class = "^Steam$"; title = ".* CD key"; }
          { class = "^Steam$"; title = "^Steam - Self Updater$"; }
          { class = "^Steam$"; title = "^Screenshot Uploader$"; }
          { class = "^Steam$"; title = "^Steam Guard - Computer Authorization Required$"; }
          { title = "^Steam Keyboard$"; }
        ];

        fonts = {
          names = [ "Hack" ];
          size = 12.0;
        };
        gaps.inner = 10;
        window.border = 2;
        colors = {
          focused = {
            text = "${foreground}";
            background = "${background}";
            border = "${blue}";
            childBorder = "${blue}";
            indicator = "${blue}";
          };
          unfocused = {
            text = "${foreground}";
            background = "${background}";
            border = "${darkGrey}";
            childBorder = "${darkGrey}";
            indicator = "${darkGrey}";
          };
        };

        modes = { }; # I use another method of resizing
        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
            menu = config.wayland.windowManager.sway.config.menu;
            terminal = config.wayland.windowManager.sway.config.terminal;
          in
          {
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";

            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";

            "${modifier}+Control+h" = "resize grow left 10 px";
            "${modifier}+Control+j" = "resize grow down 10 px";
            "${modifier}+Control+k" = "resize grow up 10 px";
            "${modifier}+Control+l" = "resize grow right 10 px";

            "${modifier}+Control+Shift+h" = "resize shrink right 10 px";
            "${modifier}+Control+Shift+j" = "resize shrink up 10 px";
            "${modifier}+Control+Shift+k" = "resize shrink down 10 px";
            "${modifier}+Control+Shift+l" = "resize shrink left 10 px";

            "${modifier}+o" = "split h";
            "${modifier}+u" = "split v";
            "${modifier}+f" = "fullscreen toggle";

            "${modifier}+t" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            "${modifier}+Shift+s" = "floating toggle";
            "${modifier}+s" = "focus mode_toggle";

            "${modifier}+a" = "focus parent";

            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+minus" = "scratchpad show";

            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";

            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+w" = "kill";
            "${modifier}+space" = "exec ${menu}";

            "${modifier}+p" = "exec grimshot copy area";
            # "${modifier}+Shift+q" = "exec swaylock -c ${lib.removePrefix "#" background}";
            "${modifier}+Shift+q" = "exec swaylock-fancy";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+Shift+e" = "exec sway-nagbar -t warning -m 'Do you want to exit sway?' -b 'Yes' 'swaymsg exit'";
          };
        startup = [
          { command = "autotiling"; always = true; }
          # Only fetches the wallpaper, I can't tell if this is scuffed or not
          { command = "${config.home.homeDirectory}/scripts/setwal.sh"; always = true; }
          {
            # This is stupid
            command = "${pkgs.writeShellScript "gtk-config-import" ''
              config="${config.xdg.configHome}/gtk-3.0/settings.ini"
              if [ ! -f "$config" ];
              then exit 1; fi

              gnome_schema = "org.gnome.desktop.interface"
              gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
              icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
              cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
              font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
              gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
              gsettings set "$gnome_schema" icon-theme "$icon_theme"
              gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
              gsettings set "$gnome_schema" font-name "$font_name"
            ''}";
          }
        ];
      };
      extraOptions = [ "--unsupported-gpu" ]; # "--verbose" "--debug"
      extraSessionCommands = ''
        # Wayland Steam stuff, unstable is an understatement
        # export SDL_VIDEODRIVER=wayland
        # export SDL_DYNAMIC_API=${pkgs.SDL2}/lib/libSDL2-2.0.so.0

        export MOZ_ENABLE_WAYLAND=1
      '';
    };
  };
}
