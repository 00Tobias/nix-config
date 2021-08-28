{ config, pkgs, ... }: {
  programs = {
    gpg.enable = true;
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_CLIP_TIME = "30";
      };
    };
  };
}
