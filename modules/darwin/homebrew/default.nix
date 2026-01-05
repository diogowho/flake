{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) optionals optionalAttrs;
in
{
  imports = [
    inputs.homebrew.darwinModules.nix-homebrew
    ./environment.nix
  ];

  config = {
    nix-homebrew = {
      enable = true;
      user = "diogo";
      autoMigrate = true;
    };

    homebrew = {
      enable = true;

      global.autoUpdate = true;

      onActivation = {
        upgrade = true;
        cleanup = "zap";
      };

      taps = [ ];

      masApps = {
        # keep-sorted start
        "Bitwarden" = 1352778147;
        "Kagi" = 1622835804;
        "SponsorBlock" = 1573461917;
        "Userscripts" = 1463298887;
        "WhatsApp" = 310633997;
        "uBlock Origin Lite" = 6745342698;
        # keep-sorted end
      }
      // optionalAttrs (config.sys.profiles.workstation.enable) {
        # keep-sorted start
        "Xcode" = 497799835;
        # keep-sorted end
      };

      brews = [
        # keep-sorted start
        "bitwarden-cli"
        "colima"
        "docker"
        "docker-compose"
        "mas"
        # keep-sorted end
      ];

      casks = [
        # keep-sorted start
        "discord"
        "element"
        "font-maple-mono"
        "sketch@beta"
        "steam"
        # keep-sorted end
      ]
      ++ optionals config.sys.profiles.gaming.enable [
        # keep-sorted start
        "crossover"
        "nvidia-geforce-now"
        "prismlauncher"
        # keep-sorted end
      ];
    };
  };
}
