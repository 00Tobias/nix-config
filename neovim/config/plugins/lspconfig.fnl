(module plugins.lspconfig
  {autoload {util util
             nvim aniseed.nvim
             lsp lspconfig}})

;; C
(lsp.clangd.setup {})

;; Lua
(lsp.sumneko_lua.setup {:cmd {1 :lua-language-server}
                        :settings
                        {:Lua {:runtime {:version :LuaJIT
                                         :path (vim.split package.path ";")}
                               :diagnostics {:globals {1 :vim}}
                               :workspace {:library (vim.api.nvim_get_runtime_file "" true)}
                               :telemetry {:enable false}}}})

;; Nix
(lsp.rnix.setup {})

;; Python
(lsp.pylsp.setup {})

;; Rust
(lsp.rust_analyzer.setup {})

;; Zig
(lsp.zls.setup {})
