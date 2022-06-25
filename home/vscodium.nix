{ config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      betterthantomorrow.calva
      jnoortheen.nix-ide
      mskelton.one-dark-theme
      # gregoire.dance
      # betterthantomorrow.joyride
    ];

    userSettings = {
      editor = {
        fontFamily = "Hack";
        fontSize = 15;
      };
      workbench = {
        colorTheme = "One Dark";
      };

      # Extensions
      dance.modes = {
        normal = {
          cursorStyle = "block";
          selectionBehavior = "character";
        };
      };
      nix.enableLanguageServer = true;
    };
  };
}
