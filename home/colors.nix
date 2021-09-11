let
  theme = themes.onedark;
  themes = {
    onedark = {
      background = "#1e222a";
      foreground = "#d8dee9";
      black = "#1b1f27";
      darkGrey = "#2c313a";
      lightGrey = "#42464e";
      cyan = "#a3b8ef";
      blue = "#61afef";
      teal = "#519ABA";
      green = "#A3BE8C";
      vibrantGreen = "#7eca9c";
      red = "#e06c75";
      orange = "#caaa6a";
      yellow = "#ebcb8b";
      magenta = "#c678dd";
      pink = "#ff75a0";
    };
  };
in
{
  inherit theme;
}
