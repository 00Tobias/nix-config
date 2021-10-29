(module plugins.treesitter
  {autoload {nvim aniseed.nvim
             colors colors
             treesitter nvim-treesitter.configs}})

(treesitter.setup {:indent {:enable true}
                   :highlight {:enable true
                               :additional_vim_regex_highlighting false}}
                  ;; nvim-ts-rainbow
                  {:rainbow
                   {:colors [colors.red
                             colors.orange
                             colors.yellow
                             colors.green
                             colors.teal
                             colors.blue
                             colors.magenta]}})
                  
