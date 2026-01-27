{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.mautrix-discord;
in
{
  options.sys.services.matrix-bridges.discord = mkServiceOption "Mautrix Discord Bridge" {
    port = 29334;
  };

  config = mkIf cfg.enable {
    services.mautrix-discord = {
      enable = true;

      registerToSynapse = true;

      settings = {
        appservice = {
          address = "http://${cfg.host}:${toString cfg.port}";
          hostname = cfg.host;
          port = cfg.port;
          bot = {
            username = "discord";
            displayname = "Discord";
          };
        };

        homeserver.address = "https://matrix.${config.networking.domain}";
      };
    };
  };
}
