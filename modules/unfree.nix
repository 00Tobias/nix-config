{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    spotify
  ];
}
