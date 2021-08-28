{ config, pkgs, ... }: {

  home = {
    file."${config.home.homeDirectory}/.xinitrc" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # From NixOS wiki, fixes dbus issues without a display manager
        if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
          eval $(dbus-launch --exit-with-session --sh-syntax)
        fi
        systemctl --user import-environment DISPLAY XAUTHORITY

        if command -v dbus-update-activation-environment >/dev/null 2>&1; then
                dbus-update-activation-environment DISPLAY XAUTHORITY
        fi

        exec i3
      '';
    };
    packages = with pkgs; [
      autotiling
    ];
  };

  xsession = {
    windowManager.i3 = {
      enable = true;
      config = {
        terminal = "alacritty";
        gaps.inner = 10;
        menu = "rofi -show run"; # combi
        modifier = "Mod4";

        assigns = {
          "5" = [{ class = "^Steam$"; }];
          "6" = [{ class = "^discord$"; }];
        };

        floating.criteria = [
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

        keybindings =
          let
            modifier = config.xsession.windowManager.i3.config.modifier;
            menu = config.xsession.windowManager.i3.config.menu;
            terminal = config.xsession.windowManager.i3.config.terminal;
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
            "${modifier}+e" = "layout toggle split"; # NOTE: Fit for removal?

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
            "${modifier}+Shift+q" = "kill";
            "${modifier}+space" = "exec ${menu}";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
          };
        startup = [
          { command = "autotiling"; always = true; notification = false; }
          { command = "${config.home.homeDirectory}/scripts/setwal.sh"; always = true; notification = false; }
          { command = "systemctl --user restart picom"; always = true; notification = false; }
          { command = "systemctl --user restart dunst"; always = true; notification = false; }
          { command = "$kdeconnect-indicator"; always = true; notification = false; }
          { command = "discordcanary"; }
        ];
      };
    };
  };
}
