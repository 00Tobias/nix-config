let
  theme = themes.onedark;
  themes = {
    onedark = {
      background = "#1e222a";
      foreground = "#d8dee9";
      black = "#1b1f27";
      lighterBlack = "#252931";
      darkerGrey = "#353b45";
      darkGrey = "#3e4451";
      grey = "#545862";
      lightGrey = "#565c64";
      lighterGrey = "#abb2bf";
      lightestGrey = "#b6bdca";
      cyan = "#a3b8ef";
      blue = "#61afef";
      teal = "#56b6c2";
      green = "#98c379";
      red = "#e06c75";
      deepRed = "#be5046";
      orange = "#d19a66";
      yellow = "#e5c07b";
      magenta = "#c678dd";
      pink = "#ff75a0";
    };
  };
in
{
  inherit theme;
}
