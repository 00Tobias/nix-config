{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    lunar-client
    lutris
    dwarf-fortress-packages.dwarf-fortress-full
  ];
}
