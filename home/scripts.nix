{ config, pkgs, ... }: {
  # TODO: Maybe change this to source files from a ./scripts dir?
  home = {
    packages = with pkgs; [
      wget
      jq
    ];
    file = {
      "${config.home.homeDirectory}/scripts/fetchwal.sh" = {
        executable = true;
        text = ''
          URL=$(wget -O - -q reddit.com/r/wallpaper/top/.json | jq '.data.children[] |.data.url' | head -1 | sed -e 's/^"//' -e 's/"$//')
          FILE="/tmp/wallpapers/$URL##*/"

          if [ ! -f "$FILE" ]; then
            rm /tmp/wallpapers/*
            wget -q -P /tmp/wallpapers/ $URL
          else
            false
          fi
        '';
      };
    };
  };
}
