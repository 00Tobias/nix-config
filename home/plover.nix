{ config, pkgs, ... }: {
  home.packages = with pkgs; [ plover.dev ];
  xdg = {
    configFile = {
      "plover/plover-emacs.json".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/excalamus/plover-emacs/b7ae6289533619e7e6d6382509bf062b19eca6f0/plover-emacs.json";
        sha256 = "1vdn6231wgjnhvwh5x3ih41bbkq992nlx7z9z36rr3q4n6a5nbnd";
      };
      "plover/plover-use.json".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/didoesdigital/steno-dictionaries/eae7dba926bd4db903f7675a16c5c1a1f442f31f/dictionaries/plover-use.json";
        sha256 = "0kg0ba02rqv20lr11n4vf0jmc3agr130phbpzrjpbglrzlh3hlh5";
      };
    };
    desktopEntries = {
      plover = {
        name = "Plover";
        icon = "plover";
        exec = "plover";
        categories = [ "Utility" "Accessibility" ];
        comment = "Stenographic input and translation";
      };
    };
  };
}
