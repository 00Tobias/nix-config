{ config, pkgs, ... }:
let
  fun = pkgs.lua.pkgs.buildLuarocksPackage {
    pname = "fun";
    version = "scm-1";

    src = pkgs.fetchFromGitHub {
      owner = "luafun";
      repo = "luafun";
      rev = "cb6a7e25d4b55d9578fd371d1474b00e47bd29f3";
      sha256 = "0p7s6jj2d8c7h6jar89b94i3jbbd092vq1a5grhhqga7glz979cn";
    };
  };
  awesome-git = pkgs.awesome.overrideAttrs (old: {
    lua = pkgs.luajit;
    patches = [ ];
    src = pkgs.fetchFromGitHub {
      owner = "AwesomeWM";
      repo = "awesome";
      rev = "3a542219f3bf129546ae79eb20e384ea28fa9798";
      sha256 = "1qyy650rwxaakw4hmnvwv7lqxjz22xhbzq8vqlv6ry5g5gmg0gg3";
    };
  });
in
{
  home = {
    packages = with pkgs; [ (fennel.override { lua = pkgs.luajit; }) ];
  };
  xdg.configFile = {
    "awesome" = {
      recursive = true;
      source = pkgs.stdenv.mkDerivation {
        name = "awesome-config";
        src = ./config;
        buildInputs = [ (pkgs.fennel.override { lua = pkgs.luajit; }) ];
        buildCommand = ''
          mkdir -p $out
          # fennel -c $src/macros.fnl > $out/macros.lua
          # fennel -c $src/rc.fnl > $out/rc.lua
          fennel -c $src/config.fnl > $out/rc.lua

          # Check config syntax to make sure it's okay
          DISPLAY=:1 ${pkgs.xorg.xorgserver}/bin/Xephyr -screen 800x600 :1 & xephyr_pid=$!
          DISPLAY=:1 ${awesome-git}/bin/awesome -c $out/rc.lua & awesome_pid=$!
          sleep 3
          kill -KILL $awesome_pid
          kill -KILL $xephyr_pid
        '';
      };
    };

    # "awesome/rc.fnl" = {
    #   source = ./rc.fnl;
    #   onChange = ''
    #     fennel --compile ${config.xdg.configHome}/awesome/rc.fnl > ${config.xdg.configHome}/awesome/rc.lua
    #   '';
    # };
    # "awesome/macros.fnl" = {
    #   source = ./macros.fnl;
    #   onChange = ''
    #     fennel --compile ${config.xdg.configHome}/awesome/macros.fnl > ${config.xdg.configHome}/awesome/macros.lua
    #   '';
    # };

    # Modules
    "awesome/module/bling" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "BlingCorp";
        repo = "bling";
        rev = "6e4ecb334c3764483d04b4e6bfc15abf98043bef";
        sha256 = "1gpy60f22ak0ybqn9kg2aq4v9sjy3br9nwhvay74rd2qfk21l4ac";
      };
    };
  };
  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.awesome = {
      enable = true;
      package = awesome-git;
      #     pkgs.awesome.overrideAttrs (old: {
      #       lua = pkgs.luajit;
      #       patches = [ ];
      #       src = pkgs.fetchFromGitHub {
      #         owner = "AwesomeWM";
      #         repo = "awesome";
      #         rev = "3a542219f3bf129546ae79eb20e384ea28fa9798";
      #         sha256 = "1qyy650rwxaakw4hmnvwv7lqxjz22xhbzq8vqlv6ry5g5gmg0gg3";
      #       };
      #   });
      luaModules = with pkgs.luajitPackages; [
        fun
        vicious
      ];
    };
  };
}
