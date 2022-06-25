{ lib, pkgs, config, ... }:

# Adapted from https://github.com/danielphan2003/flk/blob/main/pkgs/applications/audio/spotify-spicetified/default.nix
# and https://github.com/NixOS/nixpkgs/pull/111946
# NOTE: Remove when pull request is merged

let
  # Spicetify settings
  theme = "Default";
  colorScheme = "Ocean";
  customApps = { };
  customExtensions = { };
  customThemes = { };
  enabledCustomApps = [ ];
  enabledExtensions = [ "shuffle+.js" ];
  injectCss = true;
  replaceColors = true;
  overwriteAssets = false;
  disableSentry = true;
  disableUiLogging = true;
  disableUpgradeCheck = true;
  exposeApis = true;
  removeRtlRule = true;
  commandLineArgs = "";
  extraConfig = "";

  spicetify-cli = pkgs.spicetify-cli.overrideAttrs (oldAttrs: rec {
    version = "unstable-2022-05-31";
    src = pkgs.fetchFromGitHub {
      owner = "khanhas";
      repo = "spicetify-cli";
      rev = "3fdd7594cd6dc5635e7636b41cc42dc5eb6d536a";
      sha256 = "0p4dvasz1a87shqir0a7mvpws4xjq17w2ygg91xgikcmga7i9d89";
    };
    postInstall = "cp -r ./jsHelper ./Themes ./Extensions ./CustomApps ./globals.d.ts ./css-map.json $out/bin";
  });

  spicetify-themes = pkgs.fetchFromGitHub {
    owner = "morpheusthewhite";
    repo = "spicetify-themes";
    rev = "dd7a7e13e0dc7a717cc06bba9ea04ed29d70a30e";
    sha256 = "05c93cckamdiqy9d8yqbl4laf44cj6x6702ldpxc50nqwm6r38mz";
    fetchSubmodules = true;
  };

  inherit (lib) optionalString escapeShellArg escape;

  # Helpers
  pipeConcat = lib.foldr (a: b: a + "|" + b) "";

  lineBreakConcat = lib.foldr (a: b: a + "\n" + b) "";

  boolToString = x:
    if x
    then "1"
    else "0";

  makeLnCommands = type:
    lib.mapAttrsToList (name: path: "ln -sf ${path} $SPICETIFY_CONFIG/${type}/${name}");
  makeSpicetifyCommands = type: value:
    lineBreakConcat (makeLnCommands type value);

  spicetifyLnCommands =
    makeSpicetifyCommands "Themes" customThemes
    + makeSpicetifyCommands "Extensions" customExtensions
    + makeSpicetifyCommands "CustomApps" customApps;

  extensionString = pipeConcat enabledExtensions;

  customAppsString = pipeConcat enabledCustomApps;

  optionalConfig = config: value:
    optionalString (value != "") ''${config} "${value}"'';

  extraConfigFile = pkgs.writeText "config.ini" extraConfig;

  spotify-spicified = pkgs.spotify-unwrapped.overrideAttrs (o: {
    inherit extraConfigFile;

    pname = "spotify-spicified";

    nativeBuildInputs = o.nativeBuildInputs ++ [ spicetify-cli ];

    # Setup spicetify
    SPICETIFY_CONFIG = ".";

    postInstall = ''
      touch $out/prefs
      mkdir -p Themes Extensions CustomApps
      find ${spicetify-themes}/ -maxdepth 1 -type d -exec ln -s {} Themes \;
      ${spicetifyLnCommands}
      cat <<EOT >> "$SPICETIFY_CONFIG/$(spicetify-cli -c)"
      [Setting]
      prefs_path = $out/prefs
      spotify_path = $out/share/spotify
      EOT
      spicetify-cli config \
        inject_css                      ${boolToString injectCss} \
        replace_colors                  ${boolToString replaceColors} \
        overwrite_assets                ${boolToString overwriteAssets} \
        disable_sentry                  ${boolToString disableSentry} \
        disable_ui_logging              ${boolToString disableUiLogging} \
        disable_upgrade_check           ${boolToString disableUpgradeCheck} \
        expose_apis                     ${boolToString exposeApis} \
        remove_rtl_rule                 ${boolToString removeRtlRule} \
        ${optionalConfig "current_theme" theme} \
        ${optionalConfig "color_scheme" colorScheme} \
        ${optionalConfig "custom_apps" customAppsString} \
        ${optionalConfig "extensions" extensionString}
      cat $extraConfigFile >> "$SPICETIFY_CONFIG/$(spicetify-cli -c)"
      spicetify-cli backup apply
      find CustomApps/ -maxdepth 1 -type d -exec cp -r {} $out/share/spotify/Apps \;
      ln -sf $out/prefs $out/share/spotify/prefs
      mkdir -p $out/.bin-wrapped
      mv $out/share/spotify/spotify $out/.bin-wrapped
      makeWrapper $out/.bin-wrapped/spotify $out/share/spotify/spotify \
        --add-flags ${escapeShellArg commandLineArgs}
    '';

    meta = pkgs.spotify-unwrapped.meta // {
      priority = (pkgs.spotify-unwrapped.meta.priority or 0) - 1;
    };
  });
in
{
  home.packages = [ spotify-spicified ];
}
