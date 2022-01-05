{ lib, config, pkgs, ... }:
let
  colors = import ../colors.nix;
in
{
  home.packages = [ (pkgs.nerdfonts.override { fonts = [ "Hack" ]; }) ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 37;
        modules-left = [ "custom/nixos" "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "cpu" "memory" "network" "battery" "backlight" "pulseaudio" "clock" ];
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
            max-length = 60;
            rewrite = {
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
          "network" = {
            format-wifi = "直 {essid}";
            format-ethernet = " {ifname}";
            format-disconnected = " Disconnected";
            tooltip-format = "{ipaddr}";
          };
          "battery" = {
            format = "ﮣ{icon} {capacity}%";
            format-discharging = "{icon} {capacity}%";
            states = {
              warning = "30";
              critical = "15";
            };
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-source-muted = "婢";
            format-icons = {
              headphone = " ";
              headset = " ";
              hdmi = "﴿";
              default = [
                "奄"
                "奔"
                "墳"
              ];
            };
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
      #memory,
      #battery,
      #temperature,
      #clock,
      #backlight,
      #pulseaudio,
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

      #battery {
          color: ${green};
      }

      #battery.warning {
          color: ${orange};
      }

      #battery.critical {
          color: ${red};
      }

      #clock {
        color: ${orange};
      }
    '';
  };
}
