{ pkgs, fetchFromGitHub }:
let buildKakounePlugin = pkgs.vimUtils.buildKakounePluginFrom2Nix;
in {
  active-window-kak = buildKakounePluginFrom2Nix {
    pname = "kakoune-wiki";
    version = "2020-09-21";
    src = fetchFromGitHub {
      owner = "TeddyDD";
      repo = "kakoune-wiki";
      rev = "910734f3eeeddb0eb7f608b81704ca353e328704";
      sha256 = "sha256-KDqP3W195BL+P7tIP+a3I3oa7k8ohE+a2XK34HQys8g=";
    };
    meta.homepage = "https://github.com/TeddyDD/kakoune-wiki";
  };
}
