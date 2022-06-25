{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (pkgs.nyxt.overrideAttrs
        (drv: {
          src = drv.src.overrideAttrs
            (drv: {
              src = pkgs.fetchFromGitHub {
                repo = "nyxt";
                owner = "atlas-engineer";
                rev = "a89215106a054b531313f42bac45fe9756670fca"; # Pinned until cl-gopher is fixed
                sha256 = "sha256-ZyFfd7LxF3EzPMY0lmHTx6pAn9bpmUSRxXg24DzncWE=";
              };
              propagatedBuildInputs = drv.propagatedBuildInputs ++ [ pkg-config ];
            });
        }))
    ];
  };
  xdg.configFile."nyxt/init.lisp" = {
    source = ./init.lisp;
  };
}
