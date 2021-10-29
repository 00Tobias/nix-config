{ config, pkgs, ... }: {
  home.packages = [ pkgs.capitaine-cursors ];
  gtk = {
    enable = true;
    theme = {
      package = pkgs.materia-theme;
      name = "Materia-dark";
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Liberation Sans";
      size = 10;
    };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "capitaine-cursors";
      gtk-decoration-layout = "menu";
    };
  };
}
