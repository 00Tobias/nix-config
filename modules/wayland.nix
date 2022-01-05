{ config, lib, pkgs, ... }: {
  hardware.opengl.enable = true;
  programs.xwayland.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.makeBinPath [pkgs.greetd.tuigreet]}/tuigreet --asterisks --time --remember --remember-session --cmd sway";
        user = "greeter";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    swaylock # Has to be here instead of in home-manager
  ];
}
