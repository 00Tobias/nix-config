{}:
let
  colors = import ../home/colors.nix;
in
with colors.theme; ''
  (module colors)

  (let [colors {:background "${background}"
                :foreground "${foreground}"
                :black "${black}"
                :lighterBlack "${lighterBlack}"
                :darkerGrey "${darkerGrey}"
                :darkGrey "${darkGrey}"
                :grey "${grey}"
                :lightGrey "${lightGrey}"
                :lighterGrey "${lighterGrey}"
                :lightestGrey "${lightestGrey}"
                :cyan "${cyan}"
                :blue "${blue}"
                :teal "${teal}"
                :green "${green}"
                :red "${red}"
                :deepRed "${deepRed}"
                :orange "${orange}"
                :yellow "${yellow}"
                :magenta "${magenta}"
                :pink "${pink}"}]
        colors)
''
