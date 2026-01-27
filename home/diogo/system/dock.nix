{
  config,
  pkgs,
  lib,
  ...
}:
let
  dockutil = pkgs.dockutil;
in
lib.mkIf (pkgs.stdenv.isDarwin && false) # disabled temporarily while swift isn't building
  {
    home.activation.configure-dock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -z "''${DRY_RUN:-}" ]; then
        ${dockutil}/bin/dockutil --no-restart --remove all
        ${dockutil}/bin/dockutil --no-restart --add "/Applications/Safari.app"
        ${dockutil}/bin/dockutil --no-restart --add "/System/Applications/Mail.app"
        ${dockutil}/bin/dockutil --no-restart --add "${config.home.homeDirectory}/Applications/Home Manager Apps/Ghostty.app"
        ${dockutil}/bin/dockutil --no-restart --add "/System/Applications/Music.app"
        ${dockutil}/bin/dockutil --no-restart --add "/Applications/Discord.app"
        ${dockutil}/bin/dockutil --no-restart --add "/System/Applications/System Settings.app"
        /usr/bin/killall Dock || true
      fi
    '';
  }
