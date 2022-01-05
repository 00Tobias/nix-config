{ config, pkgs, ... }: {
  home = {
    sessionVariables = {
      # This should supposedly not be neccesary after 2.2.3
      # https://github.com/atlas-engineer/nyxt/issues/1840
      # but it still seems to be so uhhh
      WEBKIT_FORCE_SANDBOX = "0";
    };
    packages = with pkgs; [
      nyxt
    ];
  };
  xdg.configFile."nyxt/init.lisp" = {
    source = ./init.lisp;
  };
}
