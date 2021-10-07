(module plugins.formatter
  {autoload {nvim aniseed.nvim
             util util
             formatter formatter}})

;; This is slightly more clumsy in Fennel as
;; you can't have a table with a single member
(formatter.setup {:filetype
                           {:nix {1 (fn []
                                     {:exe "nixpkgs-fmt"
                                      :stdin true})}
                            :lua {1 (fn []
                                      {:exe "lua-format"
                                       :args {1 "--indent-width" 2 4}
                                       :stdin true})}
                            :rust {1 (fn []
                                      {:exe "rustfmt"
                                       :args {1 "--emit=stdout"}
                                       :stdin true})}
                            :sh {1 (fn []
                                    {:exe "shfmt"
                                     :args {1 "-i" 2 2}
                                     :stdin true})}
                            :zig {1 (fn []
                                     {:exe "zig fmt"
                                      :args {1 "--stid"}
                                      :stdin true})}}})
