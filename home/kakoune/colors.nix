# based on https://github.com/raiguard/one.kak/blob/main/colors/one-dark.kak

{ lib }:
let
  colors = import ../colors.nix;
in
with colors.theme; ''
  decl str cursoralpha "80"
  decl str selectionalpha "40"

  # CODE

  face global value "rgb:${lib.removePrefix "#" orange}"
  face global type "rgb:${lib.removePrefix "#" yellow}"
  face global variable "rgb:${lib.removePrefix "#" red}"
  face global module "rgb:${lib.removePrefix "#" yellow}"
  face global function "rgb:${lib.removePrefix "#" blue}"
  face global string "rgb:${lib.removePrefix "#" green}"
  face global keyword "rgb:${lib.removePrefix "#" magenta}"
  face global operator "rgb:${lib.removePrefix "#" foreground}"
  face global attribute "rgb:${lib.removePrefix "#" magenta}"
  face global comment "rgb:${lib.removePrefix "#" lightGrey}"
  face global documentation "rgb:${lib.removePrefix "#" darkGrey}"
  face global meta "rgb:${lib.removePrefix "#" foreground}"
  face global builtin "rgb:${lib.removePrefix "#" yellow}"

  # MARKUP

  face global title "rgb:${lib.removePrefix "#" orange}"
  face global header "rgb:${lib.removePrefix "#" green}"
  face global mono "rgb:${lib.removePrefix "#" teal}"
  face global block "rgb:${lib.removePrefix "#" magenta}"
  face global link "rgb:${lib.removePrefix "#" blue}"
  face global bullet "rgb:${lib.removePrefix "#" yellow}"
  face global list "rgb:${lib.removePrefix "#" foreground}"

  # BUILTIN

  face global Default "rgb:${lib.removePrefix "#" foreground},rgb:${lib.removePrefix "#" background}"
  face global PrimarySelection "default,rgba:${lib.removePrefix "#" blue}%opt{selectionalpha}"
  face global SecondarySelection "default,rgba:${lib.removePrefix "#" green}%opt{selectionalpha}"
  face global PrimaryCursor "default,rgba:${lib.removePrefix "#" blue}%opt{cursoralpha}"
  face global SecondaryCursor "default,rgba:${lib.removePrefix "#" green}%opt{cursoralpha}"
  face global PrimaryCursorEol "default,rgba:${lib.removePrefix "#" red}%opt{cursoralpha}"
  face global SecondaryCursorEol "default,rgba:${lib.removePrefix "#" orange}%opt{cursoralpha}"
  face global LineNumbers "rgb:${lib.removePrefix "#" lightGrey}"
  face global LineNumberCursor "rgb:${lib.removePrefix "#" orange}"
  face global LineNumbersWrapped "rgb:${lib.removePrefix "#" background},rgb:${lib.removePrefix "#" background}"
  face global MenuForeground "rgb:${lib.removePrefix "#" foreground},rgb:${lib.removePrefix "#" lighterBlack}"
  face global MenuBackground "rgb:${lib.removePrefix "#" foreground},rgb:${lib.removePrefix "#" lighterBlack}"
  face global MenuInfo "rgb:${lib.removePrefix "#" green}"
  face global Information "rgb:${lib.removePrefix "#" foreground},rgb:${lib.removePrefix "#" lighterBlack}"
  face global Error "rgb:${lib.removePrefix "#" red}"
  face global StatusLine "rgb:${lib.removePrefix "#" foreground},rgb:${lib.removePrefix "#" background}"
  face global StatusLineMode "rgb:${lib.removePrefix "#" orange}"
  face global StatusLineInfo "rgb:${lib.removePrefix "#" blue}"
  face global StatusLineValue "rgb:${lib.removePrefix "#" foreground}"
  face global StatusCursor "default,rgba:${lib.removePrefix "#" blue}%opt{cursoralpha}"
  face global Prompt "rgb:${lib.removePrefix "#" blue}"
  face global MatchingChar "default,rgb:${lib.removePrefix "#" lighterBlack}"
  face global BufferPadding "rgb:${lib.removePrefix "#" background},rgb:${lib.removePrefix "#" background}"
  face global Whitespace "rgb:${lib.removePrefix "#" lightGrey}"

  # PLUGINS

  # kak-lsp
  face global InlayHint "rgb:${lib.removePrefix "#" darkGrey}"
  face global parameter "rgb:${lib.removePrefix "#" red}+i"
  face global enum "rgb:${lib.removePrefix "#" teal}"
  face global InlayDiagnosticError "rgb:${lib.removePrefix "#" red}"
  face global InlayDiagnosticWarning "rgb:${lib.removePrefix "#" yellow}"
  face global InlayDiagnosticInfo "rgb:${lib.removePrefix "#" blue}"
  face global InlayDiagnosticHint "rgb:${lib.removePrefix "#" teal}"
  face global LineFlagError "rgb:${lib.removePrefix "#" red}"
  face global LineFlagWarning "rgb:${lib.removePrefix "#" yellow}"
  face global LineFlagInfo "rgb:${lib.removePrefix "#" blue}"
  face global LineFlagHint "rgb:${lib.removePrefix "#" teal}"
  # Not all terminals support curly underlines, so use regular ones by default
  face global DiagnosticError "default+u"
  face global DiagnosticWarning "default+u"
  face global DiagnosticInfo "default+u"
  face global DiagnosticHint "default+u"
  def -override one-enable-fancy-underlines %{
      face global DiagnosticError ",,rgb:${lib.removePrefix "#" red}+c"
      face global DiagnosticWarning ",,rgb:${lib.removePrefix "#" yellow}+c"
      face global DiagnosticInfo ",,rgb:${lib.removePrefix "#" blue}+c"
      face global DiagnosticHint ",,rgb:${lib.removePrefix "#" teal}+u"
  }
  # Infobox faces
  face global InfoDefault Information
  face global InfoBlock block
  face global InfoBlockQuote block
  face global InfoBullet bullet
  face global InfoHeader header
  face global InfoLink link
  face global InfoLinkMono header
  face global InfoMono mono
  face global InfoRule comment
  face global InfoDiagnosticError InlayDiagnosticError
  face global InfoDiagnosticHint InlayDiagnosticHint
  face global InfoDiagnosticInformation InlayDiagnosticInfo
  face global InfoDiagnosticWarning InlayDiagnosticWarning

  # phantom.kak
  face global Phantom "default,rgba:${lib.removePrefix "#" magenta}%opt{selectionalpha}"

  # kak-rainbow
  set-option global rainbow_colors rgb:${lib.removePrefix "#" foreground} rgb:${lib.removePrefix "#" red} rgb:${lib.removePrefix "#" orange} rgb:${lib.removePrefix "#" yellow} rgb:${lib.removePrefix "#" green} rgb:${lib.removePrefix "#" cyan} rgb:${lib.removePrefix "#" blue} rgb:${lib.removePrefix "#" magenta}
''
