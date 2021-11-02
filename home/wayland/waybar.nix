{ config, pkgs, ... }:
let
  colors = import ../colors.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 37;
        # output = [
        #   "eDP-1"
        #   "HDMI-A-1"
        # ];
        modules-left = [ "custom/nixos" "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "cpu" "memory" "pulseaudio" "clock" ];
        modules = {
          "custom/nixos" = {
              format = " ";
            };
          "sway/workspaces" = {
            all-outputs = false;
            disable-scroll-wraparound = true;
            enable-bar-scroll = true;
          };
          "sway/window" = {
            max-length = 50;
            rewrite = {
              "(.*) - Mozilla Firefox" = " $1";
              "(.*) - foot" = " $1";
              "foot" = " ";
              "(.*) - Kakoune" = "Kakoune";
            };
          };
          "cpu" = {
            format = " {usage}%";
          };
          "memory" = {
            format = " {}%";
          };
          "clock" = {
            format = " {:%H:%M}";
          };
        };
      }
    ];
    style = with colors.theme; ''
      * {
        border: none;
        border-radius: 0;
        font-family: Hack Nerd Font;
        font-size: 13px;
      }

      window#waybar {
        background: ${black};
        border-bottom: 2px solid ${lighterBlack};
        color: ${blue};
      }

      #workspaces,
      #window,
      #cpu,
      #keyboard-state,
      #memory,
      #temperature,
      #clock,
      #pulseaudio,
      #backlight,
      #battery,
      #network {
        background-color: ${lighterBlack};
        padding: 0 10px;
        margin: 2px 4px 4px 4px;
        border: 3px solid rgba(0, 0, 0, 0);
        border-radius: 90px;
        background-clip: padding-box;
      }

      #custom-nixos {
        padding: 0 10px;
        font-size: 17px;
        color: ${blue};
      }

      #workspaces button {
        padding: 0 5px;
        min-width: 20px;
        color: ${foreground};
      }

      #workspaces button.focused {
        color: ${blue};
      }

      #cpu {
        color: ${blue};
      }

      #memory {
        color: ${magenta};
      }

      #clock {
        color: ${orange};
      }
    '';
  };
}
