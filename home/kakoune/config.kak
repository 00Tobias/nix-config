# Main config file

# Set colorscheme from colors.nix
colorscheme colors

# Always reload on any external change of the file
set-option global autoreload yes

# Increase scrolloff
set-option global scrolloff 4,4

# Set UI options
set-option global ui_options terminal_assistant=none terminal_set_title=true terminal_status_on_top=true

# Highlight TODO faces
add-highlighter global/ regex \b(TODO|FIXME|NOTE)\b 0:default+rb

# Bindings

# Replace the macro key with something more personally useful
map global normal q '<a-i>'
map global normal Q '<a-a>'
map global normal <c-q> 'q'
map global normal <c-Q> 'Q'

# Use <tab> for indenting with spaces
map global insert <tab> '<a-;><a-gt>'
map global insert <s-tab> '<a-;><a-lt>'

# User mode bindings

# Comment out selection
map global user c ': comment-line<ret>' -docstring 'comment'

# lazygit in a floating terminal
map global user g ': floating-terminal lazygit<ret>' -docstring 'git'

# ranger in a floating terminal
map global user r ': floating-terminal ranger<ret>' -docstring 'ranger'

# Simply open a floating terminal
map global user t ': floating-terminal fish<ret>' -docstring 'floating term'

# kak-lsp functions
map global user l ': enter-user-mode lsp<ret>' -docstring 'lsp'

# fzf-mode bindings
map global user f ': fzf-mode<ret>' -docstring 'fzf'

# rep user mode
map global user e ': enter-user-mode rep<ret>' -docstring 'eval (repl)'

# Hooks

# Relative line numbers based on mode
hook global WinCreate .* %{
    add-highlighter -override global/line-numbers number-lines -relative -hlcursor
}
hook global ModeChange push:.*:insert %{
    add-highlighter -override global/line-numbers number-lines -hlcursor
}
hook global ModeChange pop:insert:.* %{
    add-highlighter -override global/line-numbers number-lines -relative -hlcursor
}

# Tab to complete in insert mode
hook global InsertCompletionShow .* %{ try %{
    map window insert <tab> <c-n>
    map window insert <s-tab> <c-p>
}}
hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}

# Wayland terminal integration
hook global ModuleLoaded wayland %{
    set-option global termcmd 'foot sh -c'

    # Spawn a floating terminal as decided by my Sway window rules
    define-command floating-terminal -params .. %{ nop %sh{
        nohup foot -T "floating-terminal" "$@" < /dev/null > /dev/null 2>&1 &
    }}
}

# Xorg terminal integration
hook global ModuleLoaded x11 %{
    set-option global termcmd 'alacritty -e sh -c'

    # Spawn a floating terminal as decided by my bspwm window rules
    define-command floating-terminal -params .. %{ nop %sh{
        nohup alacritty --class "floating-terminal" -e "$@" < /dev/null > /dev/null 2>&1 &
    }}
}

hook global ModuleLoaded fzf %{
    set-option global fzf_terminal_command 'floating-terminal kak -c %val{session} -e "%arg{@}"'
    set-option global fzf_highlight_command 'bat'
}

# System clipboard integration
hook global WinCreate .* %{
    kakboard-enable
}

# Auto pair characters
hook global WinCreate .* %{
    enable-auto-pairs
}

# Language/buffer specific hooks

# Lisp
hook global WinSetOption filetype=(clojure|lisp|scheme|racket|fennel) %{
    disable-auto-pairs
    parinfer-enable-window -smart
    rainbow-enable-window
}

# Zig
hook -group format global BufSetOption filetype=zig %{
    set-option buffer formatcmd "zig fmt"
}

# Nix
hook -group format global BufSetOption filetype=nix %{
    set-option buffer formatcmd "nixpkgs-fmt"
    set-option buffer lintcmd "statix check -o errfmt"
}
hook global WinSetOption filetype=nix %{
    set-option window indentwidth 2
}

# Git
hook global WinSetOption filetype=git-commit %{
    set window autowrap_column 72
    autowrap-enable
}

# kak-lsp

# The kak-lsp wiki says this isn't needed, but it seems to be in my case
eval %sh{kak-lsp  --kakoune -s $kak_session}

# Start kak-lsp based on filetype
hook global WinSetOption filetype=(c|cpp|clojure|racket|rust|python|lua|zig) %{
    set-option window lsp_auto_highlight_references true
    set-option window lsp_hover_anchor false
    lsp-auto-hover-enable
    lsp-inlay-diagnostics-enable window
    echo -debug "Enabling LSP for filtetype %opt{filetype}"
    lsp-enable-window
}

# rnix-lsp doesn't support textDocument/hover
hook global WinSetOption filetype=nix %{
    lsp-auto-hover-disable
    lsp-inlay-diagnostics-enable window
    echo -debug "Enabling LSP for filtetype %opt{filetype}"
    lsp-enable-window
}

# Semantic tokens
hook global WinSetOption filetype=(clojure|rust|zig) %{
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
  }
}

define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }

set-option global lsp_diagnostic_line_error_sign '║'
set-option global lsp_diagnostic_line_warning_sign '┊'

# The max height of the lsp hover window
set global lsp_hover_max_lines 20

hook global KakEnd .* %{
    lsp-exit
}
