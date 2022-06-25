{ config, pkgs, ... }: {
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
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
      size = 8;
    };
    gtk3.extraConfig = {
      gtk-decoration-layout = "menu";
      gtk-application-prefer-dark-theme = true;
    };
  };
}
