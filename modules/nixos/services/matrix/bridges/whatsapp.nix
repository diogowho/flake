{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.matrix-bridges.whatsapp;
in
{
  options.sys.services.matrix-bridges.whatsapp = mkServiceOption "Mautrix WhatsApp Bridge" {
    port = 29335;
  };

  config = mkIf cfg.enable {
    services.mautrix-whatsapp = {
      enable = true;

      registerToSynapse = true;

      settings = {
        appservice = {
          address = "http://${cfg.host}:${toString cfg.port}";
          hostname = cfg.host;
          port = cfg.port;
          bot = {
            username = "whatsapp";
            displayname = "WhatsApp";
          };
          database = {
            type = "sqlite3-fk-wal";
            uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-whatsapp.db?_txlock=immediate";
          };
        };

        bridge.permissions = {
          "@diogo:${config.networking.domain}" = "admin";
        };

        homeserver = {
          address = "https://matrix.${config.networking.domain}";
          domain = config.networking.domain;
        };
      };
    };
  };
}
