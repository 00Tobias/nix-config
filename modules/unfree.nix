{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    freetube # Inherently impure
    ripcord
    discord # For backup
    spotify
    lunar-client # Minecraft :D
  ];
}
