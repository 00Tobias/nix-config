{ config, pkgs, ... }: {

  programs = {
    kakoune = {
      enable = true;
      config = {
        hooks = [
          {
            name = "WinCreate";
            option = ".*";
            commands = "add-highlighter -override global/line-numbers number-lines -relative -hlcursor";
          }
          {
            name = "ModeChange";
            option = "push:.*:insert";
            commands = "add-highlighter -override global/line-numbers number-lines -hlcursor";
          }
          {
            name = "ModeChange";
            option = "pop:insert:.*";
            commands = "add-highlighter -override global/line-numbers number-lines -relative -hlcursor";
          }
          {
            name = "InsertCompletionShow";
            option = ".*";
            commands = "try %{ map window insert <tab> <c-n>\n map window insert <s-tab> <c-p> }";
          }
          {
            name = "InsertCompletionHide";
            option = ".*";
            commands = "unmap window insert <tab> <c-n>\n unmap window insert <s-tab> <c-p>";
          }
          {
            name = "WinDisplay";
            option = ".*";
            commands = "update-status";
          }
          {
            name = "BufSetOption";
            option = "lsp_diagnostic_error_count=.*";
            commands = "update-status";
          }
          {
            name = "BufSetOption";
            option = "lsp_diagnostic_warning_count=.*";
            commands = "update-status";
          }
          {
            name = "BufSetOption";
            group = "format";
            option = "filetype=nix";
            commands = ''set-option buffer formatcmd "nixpkgs-fmt"'';
          }
          {
            name = "WinSetOption";
            option = "filetype=nix";
            commands = "set-option window indentwidth 2";
          }
          {
            name = "WinSetOption";
            option = "filetype=(clojure|lisp|scheme|racket)";
            commands = "parinfer-enable-window -smart";
          }
          {
            name = "WinSetOption";
            option = "filetype=git-commit";
            commands = "%{ set window autowrap_column 72\n autowrap-enable }";
          }
        ];
        keyMappings = [
          {
            mode = "normal";
            key = "q";
            effect = "<a-i>";
          }
          {
            mode = "normal";
            key = "<c-q>";
            effect = "q";
          }
          {
            mode = "normal";
            key = "<c-s>";
            effect = ": fzf-mode<ret>";
          }
          {
            docstring = "copy to system clipboard";
            mode = "user";
            key = "y";
            effect = "<a-|>xsel -b -i<ret>:<space>echo -markup %{{Information}yanked selection to system clipboard}<ret>";
          }
          {
            docstring = "cut to system clipboard";
            mode = "user";
            key = "d";
            effect = "|xsel -b -i<ret>";
          }
          {
            docstring = "cut to system clipboard, enter insert mode";
            mode = "user";
            key = "c";
            effect = "|xsel -b -i<ret>i";
          }
          {
            docstring = "paste from system clipboard after cursor";
            mode = "user";
            key = "p";
            effect = "<a-!>xsel --output --clipboard<ret>";
          }
          {
            docstring = "paste from system clipboard before cursor";
            mode = "user";
            key = "P";
            effect = "!xsel --output --clipboard<ret>";
          }
        ];
        ui = {
          enableMouse = true;
          assistant = "cat";
          setTitle = true;
        };
        scrollOff = {
          columns = 4;
          lines = 4;
        };
      };
      extraConfig = ''
        # Extra config
        # Statusbar
        define-command update-status %{ evaluate-commands %sh{
            printf %s 'set-option buffer modelinefmt %{'
                if [ "$kak_opt_lsp_diagnostic_error_count" -ne 0 ]; then printf %s '{red+b}*%opt{lsp_diagnostic_error_count}{default} '; fi
                if [ "$kak_opt_lsp_diagnostic_warning_count" -ne 0 ]; then printf %s '{yellow+b}!%opt{lsp_diagnostic_warning_count} {Whitespace}│{default} '; fi
                printf %s ' {Whitespace}[{default}%sh{pwd | sed "s|^$HOME|~|"}{Whitespace}]{default}'
                printf %s ' {Whitespace}[{default}%val{bufname}{comment}(%opt{filetype}){default}'
                if [ -f "$kak_buffile" ] && [ ! -w "$kak_buffile" ]; then printf %s '{red}[]{default}'; fi
                printf %s ' %val{cursor_line}{comment}:{default}%val{cursor_char_column}/%val{buf_line_count} {{context_info}} {{mode_info}}{Whitespace}]{default}'
                printf %s " {Whitespace}[{default}{meta}$kak_client{comment}@{attribute}$kak_session{Whitespace}]{default}"
            printf %s '}'
        }}

        # Highlight TODO faces
        add-highlighter global/ regex \b(TODO|FIXME|NOTE)\b 0:default+rb

        # Plugin manager, sadly still needed
        evaluate-commands %sh{
            plugins="$kak_config/plugins"
            mkdir -p "$plugins"
            [ ! -e "$plugins/plug.kak" ] && \
                git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
            printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
        }
        plug "andreyorst/plug.kak" noload

        plug 'listentolist/kakoune-fandt' config %{
            require-module fandt
        }

        plug 'delapouite/kakoune-user-modes' %{
            map global user a ': enter-user-mode anchor<ret>'   -docstring 'anchor mode'
            # map global user e ': enter-user-mode echo<ret>'     -docstring 'echo mode'
            map global user f ': enter-user-mode format<ret>'   -docstring 'format mode'
            map global user i ': enter-user-mode enter<ret>'    -docstring 'enter mode'
            map global user k ': enter-user-mode keep<ret>'     -docstring 'keep mode'
            map global user l ': enter-user-mode lint<ret>'     -docstring 'lint mode'
            map global user r ': enter-user-mode rotation<ret>' -docstring 'rotation mode'
            map global user t ': enter-user-mode trim<ret>'     -docstring 'trim mode'
            map global user / ': enter-user-mode search<ret>'   -docstring 'search mode'
        }

        plug chambln/kakoune-kit config %{
            map global user g ': git status -bs<ret>' -docstring 'git status'
            hook global WinSetOption filetype=git-status %{
                map window normal c ': git commit --verbose '
                map window normal l ': git log --oneline --graph<ret>'
                map window normal d ': -- %val{selections}<a-!><home> git diff '
                map window normal D ': -- %val{selections}<a-!><home> git diff --cached '
                map window normal a ': -- %val{selections}<a-!><home> git add '
                map window normal A ': -- %val{selections}<a-!><home> repl git add -p '
                map window normal r ': -- %val{selections}<a-!><home> git reset '
                map window normal R ': -- %val{selections}<a-!><home> repl git reset -p '
                map window normal o ': -- %val{selections}<a-!><home> git checkout '
            }
            hook global WinSetOption filetype=git-log %{
                map window normal d     ': %val{selections}<a-!><home> git diff '
                map window normal <ret> ': %val{selections}<a-!><home> git show '
                map window normal r     ': %val{selections}<a-!><home> git reset '
                map window normal R     ': %val{selections}<a-!><home> repl git reset -p '
                map window normal o     ': %val{selections}<a-!><home> git checkout '
            }
        }

        plug "h-youhei/kakoune-surround" config %{
            declare-user-mode surround
            map global user s ': enter-user-mode surround<ret>' -docstring 'surround'
            map global surround s ':surround<ret>' -docstring 'surround'
            map global surround c ':change-surround<ret>' -docstring 'change'
            map global surround d ':delete-surround<ret>' -docstring 'delete'
            map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
        }

        plug "occivink/kakoune-expand" config %{
            map -docstring "expand" global user e ': expand<ret>'
        }

        plug "TeddyDD/kakoune-wiki"

        # kak-lsp

        # Start kak-lsp based on filetype
        eval %sh{kak-lsp --kakoune -s $kak_session}
        hook global WinSetOption filetype=(c|cpp|rust|python|go|lua|nix|zig) %{
            set-option window lsp_auto_highlight_references true
            set-option window lsp_hover_anchor false
            lsp-auto-hover-enable
            echo -debug "Enabling LSP for filtetype %opt{filetype}"
            lsp-enable-window
        }

        # Semantic tokens
        hook global WinSetOption filetype=rust %{
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

        # Enter lsp-mode
        map global normal <c-l> ': enter-user-mode lsp<ret>'

        # Exit kak-lsp on leave
        hook global KakEnd .* lsp-exit

        # Colorscheme
        plug "raiguard/one.kak" theme %{ colorscheme one-darker }
      '';
      plugins = with pkgs.kakounePlugins; [
        fzf-kak
        parinfer-rust
      ];
    };
  };
  home.packages = with pkgs; [
    kak-lsp
    rnix-lsp
    luajitPackages.lua-lsp
    cmake-language-server
    zls
  ];
}

