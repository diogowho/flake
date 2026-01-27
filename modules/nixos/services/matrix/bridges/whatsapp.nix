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
          hostname = cfg.host;
          port = cfg.port;
          bot = {
            username = "whatsapp";
            displayname = "WhatsApp";
          };
          database = {
            type = "sqlite3-fk-wal";
            uri = "file:/var/lib/mautrix-whatsapp/mautrix-whatsapp.db?_txlock=immediate";
          };
        };

        bridge.permissions = {
          "@diogo:${config.networking.domain}" = "admin";
        };

        homeserver = {
          address = "https://matrix.${config.networking.domain}";
          domain = config.networking.domain;
        };

        network = {
          displayname_template = "{{or .BusinessName .PushName .Phone}} (WA)";
          history_sync = {
            request_full_sync = true;
          };
          identity_change_notices = true;
        };

        encryption = {
          allow = true;
          default = true;
        };
      };
    };
  };
}
