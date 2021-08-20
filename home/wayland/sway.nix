{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    autotiling
  ];

  wayland = {
    windowManager.sway = {
      enable = true;
      config = {
        gaps = {
          inner = 5;
          outer = 5;
        };
        # menu = "";
        modifier = "Mod4";
        startup = [
          { autotiling = "exec autotiling"; }
        ];
        terminal = "alacritty";
      };
      extraOptions = [ "--verbose" "--debug" "--unsupported-gpu" "--my-next-gpu-wont-be-nvidia" ];
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        # export QT_QPA_PLATFORM=wayland
        # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export MOZ_ENABLE_WAYLAND=1
      '';
    };
  };
}