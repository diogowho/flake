{ lib, pkgs, ... }:
{
  home.file.".hushlogin".text = "";

  imports = [
    # keep-sorted start
    ./catppuccin.nix
    ./programs
    ./system
    # keep-sorted end
  ];

  targets.darwin = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    copyApps = {
      enable = true;
      enableChecks = true;
    };

    linkApps.enable = false;
  };
}
