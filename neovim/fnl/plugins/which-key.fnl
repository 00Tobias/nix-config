(module dotfiles.plugin.telescope
  {autoload {nvim aniseed.nvim
             util dotfiles.util
             which-key which-key}})

(which-key.setup
  {:plugins {:marks true
             :registers true
             :spelling {:enabled false
                        :suggestions 20}
             :presets {:operators true
                       :motions true
                       :text_objects true
                       :windows true
                       :nav true
                       :z true
                       :g true}}}
   :window {:border "single"
            :position "bottom"
            :margin [ 1 0 1 0 ]
            :padding [ 2 2 2 2 ]})

;; (which-key.register
