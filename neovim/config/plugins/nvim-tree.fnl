(module plugins.nvim-tree
  {autoload {nvim aniseed.nvim
             nvim-tree nvim-tree}})

(set vim.g.nvim_tree_git_hl 0)
(set vim.g.nvim_tree_highlight_opened_files 1)
;; (set vim.g.nvim_tree_root_folder_modifier
;;      (table.concat {1 ":t:gs?$?/.." 2 (string.rep " " 1000) 3 "?:gs?^??"}))
(set vim.g.nvim_tree_show_icons {:folders 1 :files 1 :git 1})
(set vim.g.nvim_tree_icons {:default ""
                            :symlink ""
                            :git {:deleted ""
                                  :ignored "◌"
                                  :renamed "➜"
                                  :staged "✓"
                                  :unmerged ""
                                  :unstaged "✗"
                                  :untracked "★"}
                            :folder {:default ""
                                     :empty ""
                                     :empty_open ""
                                     :open ""}})

(nvim-tree.setup {:hijack_cursor true
                  :update_cwd true
                  :diagnostics {:enable true
                                :icons {:hint "" :info "" :warning "" :error ""}}
                  :update_focused_file {:enable true}})
