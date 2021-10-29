(module plugins.formatter
  {autoload {nvim aniseed.nvim
             util util
             formatter formatter}})

(formatter.setup {:filetype
                           {:nix [(fn []
                                   {:exe "nixpkgs-fmt"
                                    :stdin true})]
                            :lua [(fn []
                                    {:exe "lua-format"
                                     :args ["--indent-width" 4]
                                     :stdin true})]
                            :rust [(fn []
                                    {:exe "rustfmt"
                                     :args ["--emit=stdout"]
                                     :stdin true})]
                            :sh [(fn []
                                  {:exe "shfmt"
                                   :args ["-i" 2]
                                   :stdin true})]
                            :zig [(fn []
                                   {:exe "zig fmt"
                                    :args ["--stid"]
                                    :stdin true})]}})
