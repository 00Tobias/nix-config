{ lib, config, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      wezterm
      (fennel.override { lua = pkgs.luajit; })
    ];
  };
  xdg.configFile = {
    "wezterm/colors.lua" = {
      text = import ./colors.nix { inherit lib; };
    };
    "wezterm/wezterm.lua" = {
      source = pkgs.stdenv.mkDerivation {
        name = "wezterm.lua";
        src = ./wezterm.fnl;
        buildInputs = [ (pkgs.fennel.override { lua = pkgs.luajit; }) ];
        buildCommand = ''
          fennel -c $src > $out
        '';
      };
    };
  };
}
