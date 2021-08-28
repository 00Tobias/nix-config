{ config, pkgs, ... }: {
  # Might not be necessary
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  # security.pam.yubico = {
  #   enable = true;
  #   debug = true;
  #   mode = "challenge-response"; # is not of type Path, strange error
  # };

  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-manager-qt
  ];
}
