(local wezterm (require :wezterm))
(require :colors)

{:font (wezterm.font "Hack")
 :colors {:foreground foreground
          :background background
          :cursor_bg foreground
          :cursor_fg background
          :cursor_border "#52ad70"
          :selection_fg background
          :selection_bg foreground
          :scrollbar_thumb "#222222"
          :split "#444444"
          :ansi [black
                 red
                 green
                 yellow
                 blue
                 magenta
                 cyan
                 foreground]
          :brights [black
                    red
                    green
                    yellow
                    blue
                    magenta
                    cyan
                    foreground]
          :indexed {136 "#af8700"}
          :compose_cursor blue}}
