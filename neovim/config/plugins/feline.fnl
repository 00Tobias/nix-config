(module plugins.feline
  {autoload {nvim aniseed.nvim
             colors colors
             feline feline
             lsp feline.providers.lsp
             vi-mode-utils feline.providers.vi_mode}})

(local components {:active {} :inactive {}})

(local force-inactive {:filetypes {} :buftypes {} :bufnames {}})

(local disable {:filetypes {} :buftypes {} :bufnames {}})

(set disable.filetypes [:NvimTree])

(set force-inactive.filetypes [:dbui
                               :packer
                               :help
                               :startify
                               :NeogitStatus
                               :fugitive
                               :fugitiveblame])

(set force-inactive.buftypes [:terminal])

(tset components.active 1
      [{:provider "▊ " :hl {:fg :skyblue}}
       {:provider :vi_mode
        :hl (fn []
              {:name (vi-mode-utils.get_mode_highlight_name)
               :fg (vi-mode-utils.get_mode_color)
               :style :bold})
        :right_sep " "}
       {:provider :file_info
        :hl {:fg :white :bg :oceanblue :style :bold}
        :left_sep [" "
                   :slant_left_2
                   {:str " " :hl {:bg :oceanblue :fg :NONE}}]
        :right_sep [:slant_right_2 " "]}
       {:provider :file_size
        :right_sep [" " {:str :slant_left_2_thin :hl {:fg :fg :bg :bg}}]}
       {:provider :position
        :left_sep " "
        :right_sep [" " {:str :slant_right_2_thin :hl {:fg :fg :bg :bg}}]}
       {:provider :diagnostic_errors :hl {:fg :red}}
       {:provider :diagnostic_warnings :hl {:fg :yellow}}
       {:provider :diagnostic_hints :hl {:fg :cyan}}
       {:provider :diagnostic_info :hl {:fg :skyblue}}])

(tset components.active 2
      [{:provider :git_branch
        :hl {:fg :white :bg :black :style :bold}
        :right_sep {:str " " :hl {:fg :NONE :bg :black}}}
       {:provider :git_diff_added :hl {:fg :green :bg :black}}
       {:provider :git_diff_changed :hl {:fg :orange :bg :black}}
       {:provider :git_diff_removed
        :hl {:fg :red :bg :black}
        :right_sep {:str " " :hl {:fg :NONE :bg :black}}}
       {:provider :line_percentage
        :hl {:style :bold}
        :left_sep "  "
        :right_sep " "}
       {:provider :scroll_bar :hl {:fg :skyblue :style :bold}}])

;; Simple underline for inactive statusbars
(local inactive-status-hl {:fg colors.lighterBlack
                           :bg colors.background
                           :style :underline})

(tset components.inactive 1 [{:provider " "
                              :hl inactive-status-hl}])

(feline.setup {:colors
               {:bg colors.lighterBlack
                :fg colors.foreground}
               : components
               : force-inactive
               : disable})
