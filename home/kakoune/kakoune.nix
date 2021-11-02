{ lib, config, pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "kak";
    VISUAL = "kak";
  };

  # Colorscheme based on my system colors
  xdg.configFile."kak/colors/colors.kak" = {
    text = import ./colors.nix { inherit lib; };
  };

  programs = {
    zsh.shellAliases = { k = "eval $EDITOR"; };
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
        colorScheme = "colors";
        # Commented out until home-manager gets with the times
        # ui = {
        #   enableMouse = true;
        #   assistant = "cat";
        # };
        autoReload = "ask";
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

          # Language / buffer hooks
          {
            name = "WinSetOption";
            option = "filetype=(clojure|lisp|scheme|racket|fennel)";
            commands = "parinfer-enable-window -smart";
          }
          {
            name = "BufSetOption";
            group = "format";
            option = "filetype=zig";
            commands = ''set-option buffer formatcmd "zig fmt"'';
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
          # FIXME: Doesn't work lol
          # {
          #   name = "WinCreate";
          #   option = ".*";
          #   commands = "auto-pairs-enable";
          # }

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
            key = "Q";
            effect = "<a-a>";
          }
          {
            mode = "normal";
            key = "<c-q>";
            effect = "q";
          }
          {
            mode = "normal";
            key = "<c-Q>";
            effect = "Q";
          }

          # Use <tab> for indenting with spaces
          {
            mode = "insert";
            key = "<tab>";
            effect = "<a-;><a-gt>";
          }
          {
            mode = "insert";
            key = "<s-tab>";
            effect = "<a-;><a-lt>";
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
        ];
      };
      extraConfig = ''
        # Manually do what home-manager should
        set-option global ui_options terminal_set_title=true terminal_status_on_top=true terminal_assistant=cat terminal_enable_mouse=true

        # Highlight TODO faces
        add-highlighter global/ regex \b(TODO|FIXME|NOTE)\b 0:default+rb

        # Use connect.kak
        require-module connect

        # Require auto-pairs-kak module, probably deprecated when the plugin updates in nixpkgs
        require-module auto-pairs

        # Add a command for spawning a floating terminal, as decided by my sway/i3 rules
        define-command floating-terminal -params .. %{
          nop %sh{
            nohup foot -T "floating-terminal" "$@" < /dev/null > /dev/null 2>&1 &
          }
        }

        # kak-lsp

        # The kak-lsp wiki says this isn't needed, but it seems to be in my case
        eval %sh{kak-lsp  --kakoune -s $kak_session}

        # Start kak-lsp based on filetype
        hook global WinSetOption filetype=(c|cpp|clojure|racket|rust|python|lua|zig) %{
          set-option window lsp_auto_highlight_references true
          set-option window lsp_hover_anchor false
          lsp-auto-hover-enable
          echo -debug "Enabling LSP for filtetype %opt{filetype}"
          lsp-enable-window
        }

        # rnix-lsp doesn't support textDocument/hover
        hook global WinSetOption filetype=nix %{
          lsp-auto-hover-disable
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

        # Waybar as a statusline replacement

        define-command mode-fifo %{ evaluate-commands %sh{
            fifo=/tmp/kakoune/kak_mode
            mkfifo "$fifo"
            echo "{{mode_info}}" > "$fifo"
          }
        }
      '';
      plugins = with pkgs.kakounePlugins; [
        prelude-kak
        connect-kak
        fzf-kak
        parinfer-rust
        kakoune-rainbow
        auto-pairs-kak
        kakboard
      ];
    };
  };
  # Kakoune dependencies
  home.packages = with pkgs; [
    kak-lsp
    guile # kakoune-rainbow
    git
    tig
    ranger
  ];

  # kak-lsp config
  xdg.configFile."kak-lsp/kak-lsp.toml" = {
    # TODO: 'toToml' an option here?
    text = ''
      snippet_support = false
      verbosity = 2

      [server]
      timeout = 1800 # seconds = 30 minutes

      [language.c_cpp]
      filetypes = ["c", "cpp"]
      roots = ["compile_commands.json", ".clangd", ".git", ".hg"]
      command = "clangd"
      offset_encoding = "utf-8"

      [language.clojure]
      filetypes = ["clojure"]
      roots = ["project.clj", "deps.edn", ".git", ".hg"]
      command = "clojure-lsp"

      [language.lua]
      filetypes = ["lua"]
      roots = [".git", ".hg"]
      command = "lua-language-server"
      [language.lua.settings.Lua]
      # See https://github.com/sumneko/vscode-lua/blob/master/setting/schema.json
      # diagnostics.enable = true

      [language.nix]
      filetypes = ["nix"]
      roots = ["flake.nix", "shell.nix", ".git", ".hg"]
      command = "rnix-lsp"

      [language.python]
      filetypes = ["python"]
      roots = ["requirements.txt", "setup.py", ".git", ".hg"]
      command = "python-language-server"

      # Install using 'raco pkg install racket-langserver'
      [language.racket]
      filetypes = ["racket", "scheme"]
      roots = [".git", ".hg"]
      command = "racket"
      args = ["--lib", "racket-langserver"]

      [language.rust]
      filetypes = ["rust"]
      roots = ["Cargo.toml"]
      command = "rust-analyzer"
      # command = "sh"
      # args = [
      #     "-c",
      #     """
      #         if path=$(rustup which rust-analyzer 2>/dev/null); then
      #             "$path"
      #         else
      #             rust-analyzer
      #         fi
      #     """,
      # ]

      settings_section = "rust-analyzer"
      [language.rust.settings.rust-analyzer]
      hoverActions.enable = false # kak-lsp doesn't support this at the moment
      # cargo.features = []
      # See https://rust-analyzer.github.io/manual.html#configuration
      # If you get 'unresolved proc macro' warnings, you have two options
      # 1. The safe choice is two disable the warning:
      # diagnostics.disabled = ["unresolved-proc-macro"]
      # 2. Or you can opt-in for proc macro support
      procMacro.enable = true
      cargo.loadOutDirsFromCheck = true
      # See https://github.com/rust-analyzer/rust-analyzer/issues/6448

      [language.zig]
      filetypes = ["zig"]
      roots = ["build.zig"]
      command = "zls"

      # Semantic tokens
      [[semantic_tokens]]
      token = "comment"
      face = "documentation"
      modifiers = ["documentation"]

      [[semantic_tokens]]
      token = "comment"
      face = "comment"

      [[semantic_tokens]]
      token = "function"
      face = "function"

      [[semantic_tokens]]
      token = "keyword"
      face = "keyword"

      [[semantic_tokens]]
      token = "namespace"
      face = "module"

      [[semantic_tokens]]
      token = "operator"
      face = "operator"

      [[semantic_tokens]]
      token = "string"
      face = "string"

      [[semantic_tokens]]
      token = "type"
      face = "type"

      [[semantic_tokens]]
      token = "variable"
      face = "default+d"
      modifiers = ["readonly"]

      [[semantic_tokens]]
      token = "variable"
      face = "default+d"
      modifiers = ["constant"]

      [[semantic_tokens]]
      token = "variable"
      face = "variable"
    '';
  };
}
