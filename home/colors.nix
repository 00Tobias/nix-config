let
  theme = themes.onedark;
  themes = {
    onedark = {
      background = "#1e222a";
      foreground = "#d8dee9";
      black = "#1b1f27";
      darkGrey = "#2c313a"; # "#282c34"
      lightGrey = "#42464e";
      cyan = "#a3b8ef";
      blue = "#61afef";
      teal = "#56b6c2";
      green = "#98c379";
      red = "#e06c75";
      orange = "#d19a66";
      yellow = "#ebcb8b";
      magenta = "#c678dd";
      pink = "#ff75a0";
    };
  };
in
{
  inherit theme;
}
