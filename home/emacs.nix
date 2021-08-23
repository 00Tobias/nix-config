{ config, pkgs, ... }: {

  home = {
    sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin/" ];

    file.".doom.d" = {
      source = ../doom.d;
      recursive = true;
      onChange = ''
        if [ ! -d "${config.home.homeDirectory}/.emacs.d" ]; then
            git clone --depth 1 https://github.com/hlissner/doom-emacs.git ${config.home.homeDirectory}/.emacs.d
            ${config.home.homeDirectory}/.emacs.d/bin/doom -y install
        fi

        ${config.home.homeDirectory}/.emacs.d/bin/doom sync -u

        systemctl --user restart emacs
      '';
    };

    packages = with pkgs; [
      # Explicitly installed doom dependencies
      (ripgrep.override { withPCRE2 = true; })
      libvterm
      fd
      sqlite
      editorconfig-core-c
      emacs-all-the-icons-fonts
      hack-font

      # Language servers
      zls
      rust-analyzer
      python-language-server
    ];
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
  };

  services = {
    emacs = {
      enable = true;
      client = {
        enable = true;
        arguments = [ "-c" "-n" ];
      };
    };
  };
}
