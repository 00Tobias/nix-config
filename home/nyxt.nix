{ config, pkgs, ... }: {
  # I'll get started on this once nyxt gets updates in nixpkgs
  home = {
    packages = with pkgs; [
      nyxt
    ];
  };
}
