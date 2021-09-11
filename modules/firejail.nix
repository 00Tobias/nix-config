{ config, lib, pkgs, ... }: {
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      firefox = {
        executable = "${lib.getBin pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };
      qutebrowser = {
        executable = "${lib.getBin pkgs.firefox}/bin/qutebrowser";
        profile = "${pkgs.firejail}/etc/firejail/qutebrowser.profile";
      };
      steam = {
        executable = "${lib.getBin pkgs.discord}/bin/steam";
        profile = "${pkgs.firejail}/etc/firejail/steam.profile";
      };
      discord = {
        executable = "${lib.getBin pkgs.discord}/bin/discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      };
      spotify = {
        executable = "${lib.getBin pkgs.discord}/bin/spotify";
        profile = "${pkgs.firejail}/etc/firejail/spotify.profile";
      };
    };
  };
}
