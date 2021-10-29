{ config, pkgs, ... }: {
  programs.dconf.enable = true;
  nix = {
    binaryCaches = [
      "https://nixpkgs-wayland.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [ cachix ];

  fonts = {
    fonts = with pkgs; [
      cozette
      hack-font
    ];
    enableDefaultFonts = true;
    fontconfig = {
      allowBitmaps = true;
      defaultFonts = {
        monospace = [ "Hack" ];
      };
    };
  };
}
