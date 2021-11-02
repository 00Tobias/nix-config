{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    lutris
    dwarf-fortress-packages.dwarf-fortress-full
  ];
}
