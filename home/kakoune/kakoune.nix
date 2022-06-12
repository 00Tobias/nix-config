{ lib, config, pkgs, ... }:
let
  # Script to automatically start a kakoune daemon for the CWD
  # and connect to it.
  # I use this for project management
  k = pkgs.writeShellScriptBin "k" ''
    server_name=$(basename `pwd`)
    socket_file=$(kak -l | grep $server_name)

    if [[ $socket_file == "" ]]; then
      setsid kak -d -s $server_name &
      sleep 0.05
    fi

    kak -c $server_name $@
  '';

  # More recently updated plugins, plus some not in nixpkgs
  auto-pairs-kak = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "auto-pairs-kak";
    version = "unstable-2022-03-13";
    src = pkgs.fetchFromGitHub {
      owner = "alexherbo2";
      repo = "auto-pairs.kak";
      rev = "bfdcb8566076f653ec707f86207f83ea75173ce9";
      sha256 = "0vx9msk8wlj8p9qf6yiv9gzrbanb5w245cidnx5cppgld2w842ij";
    };
  };
  fzf-kak = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "fzf-kak";
    version = "unstable-2022-05-10";
    src = pkgs.fetchFromGitHub {
      owner = "andreyorst";
      repo = "fzf.kak";
      rev = "cb07538a88dd51b1c03800d6c451d2d71e7b80a5";
      sha256 = "0qk3spn2062lvikpy3cwwinl486pa19175402bpnh27ss0xaw7x5";
    };
  };
  kakboard = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kakboard";
    version = "unstable-2022-04-02";
    src = pkgs.fetchFromGitHub {
      owner = "lePerdu";
      repo = "kakboard";
      rev = "5759dcc5af593ff88a7faecc41a8f549ec440771";
      sha256 = "0g8q0rkdnzsfvlibjd1zfcapngfli5aa3qrgmkgdi24n9ad8wzvh";
    };
  };
  kakoune-snippets = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kakoune-snippets";
    version = "unstable-2021-07-18";
    src = pkgs.fetchFromGitHub {
      owner = "occivink";
      repo = "kakoune-snippets";
      rev = "c0c39eda2e8f9608cbc0372583bf76441a24afd9";
      sha256 = "12q32ahxvmi82f8jlx24xpd61vlnqf14y78ahj1381rv61a386mv";
    };
  };
  kakoune-snippet-collection = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kakoune-snippet-collection";
    version = "unstable-2021-10-15";
    src = pkgs.fetchFromGitHub {
      owner = "andreyorst";
      repo = "kakoune-snippet-collection";
      rev = "8cd0329f3f93d30d0507564eaf311b433a404213";
      sha256 = "0h3cc0aq5yv8c26jxmnfcg0pib01qbwxv1sb0dlq3zgwafpvbmjy";
    };
  };
  kak-rainbow = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kak-rainbow";
    version = "unstable-2020-08-31";
    src = pkgs.fetchFromGitHub {
      owner = "Bodhizafa";
      repo = "kak-rainbow";
      rev = "9c3d0aa62514134ee5cb86e80855d9712c4e8c4b";
      sha256 = "0mqghysiwi1h0hx96c7bq0a16yrxh65f3v8bqqn5bh9x1zh2l9mg";
    };
  };
in
{
  home.sessionVariables = {
    EDITOR = "kak";
    VISUAL = "kak";
  };

  # Kakoune dependencies
  home.packages = with pkgs; [
    kak-lsp
    perl # kakoune-snippets

    # User modes
    fzf
    bat
    git
    lazygit
    ranger

    k # Project management script
  ];

  # Colorscheme based on my system colors
  xdg.configFile = {
    "kak/colors/colors.kak" = {
      text = import ./colors.nix { inherit lib; };
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    kakoune = {
      enable = true;
      extraConfig = builtins.readFile ./config.kak;
      plugins = with pkgs.kakounePlugins; [
        parinfer-rust
        rep # From rep flake

        # Personally defined plugins
        auto-pairs-kak
        fzf-kak
        kakboard
        kakoune-snippets
        kakoune-snippet-collection
        kak-rainbow
      ];
    };
  };

  # Append to default kak-lsp config
  xdg.configFile."kak-lsp/kak-lsp.toml" = {
    text = ''
      ${builtins.readFile (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/kak-lsp/kak-lsp/a2339d0a43041ce10b71bf9c017031c858779c84/kak-lsp.toml";
          sha256 = "01jlcdr7gykp9g9p8d9zm42f2zkp7fz7881kcnq73z56g83mg6ci";
      })}
      [language.clojure]
      filetypes = ["clojure"]
      roots = ["project.clj", "deps.edn", ".git", ".hg"]
      command = "clojure-lsp"
    '';
  };
}
