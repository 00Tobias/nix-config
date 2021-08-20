{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    autotiling
  ];

  xsession = {
    windowManager.i3 = {
      enable = true;
      config = {
        gaps = {
          inner = 5;
          outer = 5;
        };
        menu = "rofi -show run"; # combi
        modifier = "Mod4";
        startup = [
          { command = "exec_always --no-startup-id autotiling"; }
        ];
        terminal = "alacritty";
      };
    };
  };
}
