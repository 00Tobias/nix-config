{}:
let
  colors = import ../../home/colors.nix;
in
with colors.theme; ''
  require("colorbuddy").setup()

  local Color = require("colorbuddy").Color

  Color.new("background", "${background}")
  Color.new("white",      "${foreground}")
  Color.new("red",        "${red}")
  Color.new("pink",       "${pink}")
  Color.new("green",      "${green}")
  Color.new("yellow",     "${yellow}")
  Color.new("blue",       "${blue}")
  Color.new("aqua",       "${green}")
  Color.new("cyan",       "${teal}")
  Color.new("purple",     "${magenta}")
  -- Color.new("violet",     "#b294bb")
  Color.new("orange",     "${orange}")
  -- Color.new("brown",      "#a3685a")

  -- Color.new("seagreen",   "#698b69")
  -- Color.new("turquoise",  "#698b69")

  local onedarker = {}

  vim.g.colors_name = 'onedarker'

  require('colorbuddy').colorscheme('onedarker')
  
  return onedarkers
''
