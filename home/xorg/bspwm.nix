{ config, pkgs, ... }:
let
  theme = import ../theme.nix { inherit pkgs; };
in
{
  home = {
    packages = with pkgs; [ xsel feh ];
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors-white";
      size = 16;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
    };
  };
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };
  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.bspwm = {
      enable = true;
      monitors = {
        # den monitors, unsure about haven compat
        DP-0 = [ "I" "II" "III" "IV" "V" "VI" ];
        HDMI-1 = [ "VII" "VIII" "IX" "X" ];
      };
      # Make sure the monitors are set in the right order for sxhkd
      # and disable both DPMS and the automatic screen saver
      extraConfig = ''
        ${pkgs.bspwm}/bin/bspc wm --reorder-monitors DP-0 HDMI-1
        ${pkgs.xorg.xset}/bin/xset s off -dpms
      '';
      settings = with theme.colors; {
        border_width = 3;
        window_gap = 10;
        focus_follows_pointer = true;

        # Colors
        focused_border_color = "${blue}";
        presel_feedback_color = "${blue}";
        normal_border_color = "${lighterBlack}";
        active_border_color = "${lighterBlack}";
      };
      rules = {
        "*:floating-terminal:*" = {
          state = "floating";
        };
        "Emacs" = {
          state = "tiled";
        };
        "discord" = {
          desktop = "^7";
        };
        "Spotify" = {
          desktop = "^7";
        };

        # Any Steam window except the main one should be floating
        "*:Steam:*" = {
          desktop = "^5";
          state = "floating";
          focus = false;
        };
        "*:Steam:Steam" = {
          state = "tiled";
        };
      };
      startupPrograms = [
        "${pkgs.picom}/bin/picom -b -c -C -G --shadow-exclude 'bounding_shaped && wmwin' --shadow-exclude 'class_g = 'Firefox' && (window_type = 'utility' || window_type = 'popup_menu') && argb' --experimental-backends"
        "${pkgs.unclutter}/bin/unclutter"
        "${pkgs.libsForQt5.kdeconnect-kde}/bin/kdeconnect-indicator"
        "${pkgs.writeShellScript "setwal" ''
          mkdir -p /tmp/wallpaper
          ${pkgs.feh}/bin/feh /tmp/wallpaper --bg-fill
          rm -f /tmp/wallpaper/*

          image=$(${pkgs.curl}/bin/curl -s -H "User-Agent: cli:bash:v0.0.0" \
            https://www.reddit.com/r/wallpapers/top/.json?t=week \
            | ${pkgs.jq}/bin/jq '.data.children[].data.url' \
            | sed '/.jpeg\|.jpg\|.png\|.webp/!d' \
            | head -1 \
            | tr -d \")

          ${pkgs.curl}/bin/curl -s --output-dir /tmp/wallpaper/ -O $image

          ${pkgs.feh}/bin/feh /tmp/wallpaper --bg-fill
          ${pkgs.betterlockscreen}/bin/betterlockscreen --fx blur -u "/tmp/wallpaper/"
      ''}"
      ];
    };
  };
  services.sxhkd = {
    enable = true;
    keybindings = {
      # Quit / restart BSPWM
      "super + alt + {q,r}" = "${pkgs.bspwm}/bin/bspc {quit,wm -r}";

      ## Node control

      # Shift focus to a directional node, or move node when holding shift
      "super + {_,shift + }{h,j,k,l}" = "${pkgs.bspwm}/bin/bspc node -{f,s} {west,south,north,east}";
      "super + {_,shift + }{n,e,i,o}" = "${pkgs.bspwm}/bin/bspc node -{f,s} {west,south,north,east}";
      "super + {_,shift + }{Left,Down,Up,Right}" = "${pkgs.bspwm}/bin/bspc node -{f,s} {west,south,north,east}";

      # Expand a node by moving one of its sides outward
      "super + ctrl + {h,j,k,l}" = "${pkgs.bspwm}/bin/bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + ctrl + {n,e,i,o}" = "${pkgs.bspwm}/bin/bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + ctrl + {Left,Down,Up,Right}" = "${pkgs.bspwm}/bin/bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

      # Contract a node by moving one of its sides inward
      "super + ctrl + shift + {h,j,k,l}" = "${pkgs.bspwm}/bin/bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      "super + ctrl + shift + {n,e,i,o}" = "${pkgs.bspwm}/bin/bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      "super + ctrl + shift + {Left,Down,Up,Right}" = "${pkgs.bspwm}/bin/bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

      # Focus latest floating node
      "super + shift + s" = "${pkgs.bspwm}/bin/bspc node -f newest.floating";

      # Move a floating node
      # "super + {Left,Down,Up,Right}" = "${pkgs.bspwm}/bin/bspc node -v {-20 0,0 20,0 -20,20 0}";

      # Preselect the ratio of the node split
      "super + alt + {h,j,k,l}" = "${pkgs.bspwm}/bin/bspc node -p {west,south,north,east}";
      "super + alt + {n,e,i,o}" = "${pkgs.bspwm}/bin/bspc node -p {west,south,north,east}";
      "super + alt + {Left,Down,Up,Right}" = "${pkgs.bspwm}/bin/bspc node -p {west,south,north,east}";

      # Preselect the workspace of the next node
      "super + ctrl + {1-9}" = "${pkgs.bspwm}/bin/bspc node -o 0.{1-9}";

      # Cancel the node preselect
      "super + alt + space" = "${pkgs.bspwm}/bin/bspc node -p cancel";

      # Send the newest marked node to the newest preselected node
      "super + y" = "${pkgs.bspwm}/bin/bspc node newest.marked.local -n newest.!automatic.local";

      # Set the state of the currently focused node
      "super + {t,shift + t,s,f}" = "${pkgs.bspwm}/bin/bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";

      # Set the flags of the currently focused node
      "super + ctrl + {m,x,y,z}" = "${pkgs.bspwm}/bin/bspc node -g {marked,locked,sticky,private}";

      # Close / kill node
      "super + {_,shift + }q" = "${pkgs.bspwm}/bin/bspc node -{c,k}";

      ## Monitors & Workspaces

      # focus or send node to the given desktop
      "super + {_,shift + }{1-9,0}" = "${pkgs.bspwm}/bin/bspc {desktop -f,node -d} '^{1-9,10}'";

      # focus the next/previous desktop in the current monitor
      "super + {comma,period}" = "${pkgs.bspwm}/bin/bspc desktop -f {prev,next}.local";

      # Alternate between tiled and monocle
      "super + m" = "${pkgs.bspwm}/bin/bspc desktop -l next";

      ## Apps

      # Terminal emulator
      "super + Return" = "${pkgs.alacritty}/bin/alacritty";

      # Emacs Client frame
      "super + shift + Return" = "${pkgs.emacsPgtkNativeComp}/bin/emacsclient -cne '(switch-to-buffer nil)'";

      # Emacs Client eshell frame
      "super + ctrl + Return" = "${pkgs.emacsPgtkNativeComp}/bin/emacsclient -cne '(eshell t)'";

      # Program launcher
      "super + @space" = "${pkgs.rofi}/bin/rofi -show drun";

      # Audio mixer
      "super + v" = "${pkgs.alacritty}/bin/alacritty --class floating-terminal -e ${pkgs.pulsemixer}/bin/pulsemixer";

      # Screen locker
      "super + shift + p" = "${pkgs.xorg.xset}/bin/xset s on +dpms; ${pkgs.betterlockscreen}/bin/betterlockscreen -l blur; ${pkgs.xorg.xset}/bin/xset s off -dpms";

      # Screenshotter
      "super + p" = "${pkgs.flameshot}/bin/flameshot gui";

      # Date and time
      "super + d" = "${pkgs.dunst}/bin/dunstify -h string:x-dunst-stack-tag:date -i preferences-system-time $(date +%D%n%T)";

      ## Media keys

      # Increase and decrease volume of current player
      "{XF86AudioRaiseVolume,XF86AudioLowerVolume}" = "${pkgs.playerctl}/bin/playerctl volume 0.03{+,-}";

      # Mute volume system-wide
      "XF86AudioMute" = "${pkgs.pulsemixer}/bin/pulsemixer --toggle-mute";

      # Play and pause player
      "XF86AudioPlay" = "${pkgs.playerctl}/bin/playerctl play-pause";

      # Next and previous track
      "{XF86AudioNext,XF86AudioPrev}" = "${pkgs.playerctl}/bin/playerctl {next,previous}";
    };
  };
}
