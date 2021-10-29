{ lib, config, pkgs, ... }:
let
  colors = import ./colors.nix;
in
{
  home.sessionVariables = {
    EDITOR = "kcr edit";
    VISUAL = "kcr edit";
  };
  programs = {
    zsh.shellAliases = { k = "$EDITOR"; };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };
    kakoune = {
      enable = true;
      config = {
        colorScheme = "one-dark";
        ui = {
          enableMouse = true;
          assistant = "cat";
        };
        scrollOff = {
          columns = 4;
          lines = 4;
        };
        hooks = [
          # Relative line numbers based on mode
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

          # Tab to complete in insert mode
          {
            name = "InsertCompletionShow";
            option = ".*";
            commands = "try %{ map window insert <tab> <c-n>
            map window insert <s-tab> <c-p> }";
          }
          {
            name = "InsertCompletionHide";
            option = ".*";
            commands = "unmap window insert <tab> <c-n>
            unmap window insert <s-tab> <c-p>";
          }

          # Modeline
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

          # Language / buffer hooks
          {
            name = "WinSetOption";
            option = "filetype=(clojure|lisp|scheme|racket|fennel)";
            commands = "parinfer-enable-window -smart";
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
            name = "BufSetOption";
            group = "format";
            option = "filetype=nix";
            commands = ''set-option buffer formatcmd "nixpkgs-fmt"'';
          }
          {
            name = "WinSetOption";
            option = "filetype=git-commit";
            commands = "%{ set window autowrap_column 72
            autowrap-enable }";
          }

          # wayland terminal
          {
            name = "ModuleLoaded";
            option = "wayland";
            commands = "set-option global termcmd 'foot sh -c'";
          }

          # fzf-kak
          {
            name = "ModuleLoaded";
            option = "fzf";
            commands = ''set-option global fzf_terminal_command 'floating-terminal kak -c %val{session} -e "%arg{@}"' '';
          }

          # kak-lsp
          {
            name = "KakEnd";
            option = ".*";
            commands = "lsp-exit";
          }

          # auto-pairs-kak
          {
            name = "WinCreate";
            option = ".*";
            commands = "auto-pairs-enable";
          }

          # kakboard
          {
            name = "WinCreate";
            option = ".*";
            commands = "kakboard-enable";
          }
        ];

        keyMappings = [
          # I don't really use macros in kakoune
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

          # Easier way to comment out code
          {
            docstring = "comment-line";
            mode = "user";
            key = "c";
            effect = ": comment-line<ret>";
          }

          # kak-lsp
          {
            docstring = "lsp";
            mode = "user";
            key = "l";
            effect = ": enter-user-mode lsp<ret>";
          }

          # fzf-kak
          {
            docstring = "fzf";
            mode = "user";
            key = "f";
            effect = ": fzf-mode<ret>";
          }

          # kakoune-surround
          {
            docstring = "surround";
            mode = "user";
            key = "s";
            effect = ": enter-user-mode surround<ret>";
          }
          {
            docstring = "surround";
            mode = "surround";
            key = "s";
            effect = ":surround<ret>";
          }
          {
            docstring = "change";
            mode = "surround";
            key = "c";
            effect = ":change-surround<ret>";
          }
          {
            docstring = "delete";
            mode = "surround";
            key = "d";
            effect = ":delete-surround<ret>";
          }
          {
            docstring = "select tag";
            mode = "surround";
            key = "t";
            effect = ":select-surrounding-tag<ret>";
          }
        ];
      };
      extraConfig = with colors.theme; ''
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

        # Use connect.kak
        # require-module connect

        # Use kakoune-fandt's bindings
        require-module fandt

        # Require auto-pairs-kak module, probably deprecated when the plugin updates in nixpkgs
        require-module auto-pairs

        # My one-dark background
        face global Default default,rgb:${lib.removePrefix "#" background}

        # Add a command for spawning a floating terminal, as decided by my sway/i3 rules
        define-command floating-terminal -params .. %{
          nop %sh{
            nohup foot -T "floating-terminal" "$@" < /dev/null > /dev/null 2>&1 &
          }
        }

        # kakoune-cr
        evaluate-commands %sh{
          kcr init kakoune
        }

        # kak-lsp

        # Start kak-lsp based on filetype
        eval %sh{kak-lsp --kakoune -s $kak_session}
        hook global WinSetOption filetype=(c|cpp|racket|rust|python|go|lua|zig) %{
          set-option window lsp_auto_highlight_references true
          set-option window lsp_hover_anchor false
          lsp-auto-hover-enable
          echo -debug "Enabling LSP for filtetype %opt{filetype}"
          lsp-enable-window
        }

        # FIXME: This is temporary
        hook global WinSetOption filetype=nix %{
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
      '';
      plugins = with pkgs.kakounePlugins; [
        prelude-kak
        connect-kak
        fzf-kak
        parinfer-rust
        kakoune-rainbow
        auto-pairs-kak
        kakboard
        pkgs.nur.repos.toxic-nur.kakounePlugins.kakoune-fandt
        pkgs.nur.repos.toxic-nur.kakounePlugins.kakoune-surround
        pkgs.nur.repos.toxic-nur.kakounePlugins.kakoune-wiki
        pkgs.nur.repos.toxic-nur.kakounePlugins.one-kak
      ];
    };
  };
  home.packages = with pkgs; [
    # TODO: Change this into a seperate file like I did with colors.nix?
    # So I can just include this in any editor and I don't need to add stuff more than one

    # Kakoune dependencies
    pkgs.nur.repos.toxic-nur.kakoune-cr
    kak-lsp
    guile
    git
    tig
    ranger

    # Nix
    rnix-lsp
    nixpkgs-fmt

    # Racket
    racket-minimal

    # Zig
    zig
    zls
  ];
}
