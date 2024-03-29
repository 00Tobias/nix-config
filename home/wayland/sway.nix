{ lib, config, pkgs, ... }:
let
  colors = import ../colors.nix;
in
{
  home.packages = with pkgs; [
    # SDL2 # Useful if you're overriding Steam's SDL, which itself hasn't proved very useful
    glib # I am peeved that gtk doesn't respect my config file on wayland >:(
    wl-clipboard
    imv
  ];

  # Use Wayland native rofi when using Sway
  programs.rofi = {
    package = pkgs.rofi-wayland;
    # rofi-wayland does not support the 'window' modi, therefore we need to override extraConfig
    extraConfig = {
      modi = "combi,drun,run";
      combi-modi = "drun,run";
      show-icons = true;
    };
  };

  wayland = {
    windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = with colors.theme; {
        input = {
          "type:keyboard" = {
            xkb_layout = "se";
          };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
          };
        };
        output = {
          HDMI-A-2 = { transform = "90"; position = "0 0"; };
        };
        seat = {
          "*" = {
            hide_cursor = "8000";
            xcursor_theme = "${pkgs.capitaine-cursors}/share/icons/capitaine-cursors-white";
          };
        };
        modifier = "Mod4";
        focus.mouseWarping = false;
        menu = "${pkgs.rofi-wayland}/bin/rofi -show combi";
        terminal = "${pkgs.foot}/bin/foot";

        defaultWorkspace = "workspace number 1";
        assigns = {
          "workspace number 7" = [{ class = "^Steam$"; }];
          "workspace number 6" = [{ class = "^Ripcord$"; } { class = "^discord$"; }];
        };
        floating.criteria = [
          { title = "floating-terminal"; }
          { class = "^Steam$"; title = "Friends List"; }
          { class = "^Steam$"; title = "Steam - News"; }
          { class = "^Steam$"; title = ".* - Chat"; } # Steam has changed the title of the class window, this no longer works
          { class = "^Steam$"; title = "^Settings$"; }
          { class = "^Steam$"; title = ".* - event started"; }
          { class = "^Steam$"; title = ".* CD key"; }
          { class = "^Steam$"; title = "^Steam - Self Updater$"; }
          { class = "^Steam$"; title = "^Screenshot Uploader$"; }
          { class = "^Steam$"; title = "^Steam Guard - Computer Authorization Required$"; }
          { title = "^Steam Keyboard$"; }
        ];

        # Disable built-in bar, since I use waybar
        bars = [ ];
        fonts = {
          names = [ "Hack" ];
          size = 11.0;
        };
        gaps.inner = 10;
        window.border = 2;
        colors = {
          focused = {
            text = "${foreground}";
            background = "${blue}";
            border = "${blue}";
            childBorder = "${blue}";
            indicator = "${blue}";
          };
          unfocused = {
            text = "${foreground}";
            background = "${background}";
            border = "${lighterBlack}";
            childBorder = "${lighterBlack}";
            indicator = "${lighterBlack}";
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

            # Media keys
            "XF86AudioRaiseVolume" = "exec ${pkgs.pulsemixer}/bin/pulsemixer --change-volume +1";
            "XF86AudioLowerVolume" = "exec ${pkgs.pulsemixer}/bin/pulsemixer --change-volume -1";
            "XF86AudioMute" = "exec ${pkgs.pulsemixer}/bin/pulsemixer --toggle-mute";
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl prev";

            "${modifier}+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
            # "${modifier}+Shift+q" = "exec swaylock -c ${lib.removePrefix "#" background}";
            "${modifier}+Shift+q" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+Shift+e" = "exec sway-nagbar -t warning -m 'Do you want to exit sway?' -b 'Yes' 'swaymsg exit'";
          };
        startup = [
          { command = "systemctl --user restart waybar"; always = true; }
          { command = "${pkgs.autotiling}"; always = true; }
          {
            command = "${pkgs.writeShellScript "setwal" ''
              mkdir -p /tmp/wallpaper
              ${pkgs.swaybg} -i /tmp/wallpaper/* -m fill
              rm -f /tmp/wallpaper/*

              image=$(${pkgs.curl}/bin/curl -s -H "User-Agent: cli:bash:v0.0.0" \
                https://www.reddit.com/r/wallpapers/top/.json?t=week \
                | ${pkgs.jq}/bin/jq '.data.children[].data.url' \
                | sed '/.jpeg\|.jpg\|.png\|.webp/!d' \
                | head -1 \
                | tr -d \")

              ${pkgs.curl}/bin/curl -s --output-dir /tmp/wallpaper/ -O $image

              ${pkgs.swaybg}/bin/swaybg -i /tmp/wallpaper/* -m fill
            ''}";
            always = true;
          }
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
          { command = "kdeconnect-cli -l"; }
        ];
      };
      extraOptions = [ "--unsupported-gpu" ]; # "--verbose" "--debug"
      extraSessionCommands = ''
        # Wayland Steam stuff, unstable is an understatement
        # export SDL_VIDEODRIVER=wayland
        # export SDL_DYNAMIC_API=${pkgs.SDL2}/lib/libSDL2-2.0.so.0

        # QT Wayland
        QT_QPA_PLATFORM=wayland-egl
        QT_WAYLAND_FORCE_DPI=physical

        export MOZ_ENABLE_WAYLAND=1
      '';
    };
  };
}
