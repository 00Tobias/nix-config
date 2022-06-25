{ lib, config, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      river
      babashka
    ];
  };
  xdg.configFile = {
    # "river/colors.clj" = {
    #   text = import ./colors.nix { inherit lib; };
    # };
    "river/init" = {
      source = ./init.clj;
      executable = true;
    };
  };
}
