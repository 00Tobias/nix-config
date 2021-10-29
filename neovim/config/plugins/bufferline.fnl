(module plugins.bufferline
  {autoload {nvim aniseed.nvim
             util util
             colors colors
             bufferline bufferline}})

(bufferline.setup {:options {:offsets [{:filetype :NvimTree
                                        :text ""
                                        :padding 1}]
                             :buffer_close_icon ""
                             :modified_icon ""
                             :close_icon ""
                             :show_close_icon true
                             :left_trunc_marker ""
                             :right_trunc_marker ""
                             :max_name_length 14
                             :max_prefix_length 13
                             :tab_size 20
                             :show_tab_indicators true
                             :enforce_regular_tabs false
                             :view :multiwindow
                             :show_buffer_close_icons true
                             :separator_style :thin
                             :always_show_bufferline true
                             :diagnostics :nvim_lsp}
                   :highlights {:background {:guifg colors.lightGrey
                                             :guibg colors.lighterBlack}
                                :buffer_selected {:guifg colors.foreground
                                                  :guibg colors.background
                                                  :gui :bold}
                                :buffer_visible {:guifg colors.lighterGrey
                                                 :guibg colors.lighterBlack}
                                :error {:guifg colors.lighterGrey
                                        :guibg colors.lighterBlack}
                                :error_diagnostic {:guifg colors.lighterGrey
                                                   :guibg colors.lighterBlack}
                                :close_button {:guifg colors.lighterGrey
                                               :guibg colors.lighterBlack}
                                :close_button_visible {:guifg colors.lighterGrey
                                                       :guibg colors.lighterBlack}
                                :close_button_selected {:guifg colors.red
                                                        :guibg colors.background}
                                :fill {:guifg colors.lightGrey
                                       :guibg colors.lighterBlack}
                                :indicator_selected {:guifg colors.background
                                                     :guibg colors.background}
                                :modified {:guifg colors.red
                                           :guibg colors.lighterBlack}
                                :modified_visible {:guifg colors.red
                                                   :guibg colors.lighterBlack}
                                :modified_selected {:guifg colors.green
                                                    :guibg colors.background}
                                :separator {:guifg colors.lighterBlack
                                            :guibg colors.lighterBlack}
                                :separator_visible {:guifg colors.lighterBlack
                                                    :guibg colors.lighterBlack}
                                :separator_selected {:guifg colors.lighterBlack
                                                     :guibg colors.lighterBlack}
                                :tab {:guifg colors.lighterGrey
                                      :guibg colors.darkerGrey}
                                :tab_selected {:guifg colors.lighterBlack
                                               :guibg colors.blue}
                                :tab_close {:guifg colors.red
                                            :guibg colors.background}}})
