{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.matrix-bridges.discord;
in
{
  options.sys.services.matrix-bridges.discord = mkServiceOption "Mautrix Discord Bridge" {
    port = 29334;
  };

  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [ "olm-3.2.16" ];

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
          database = {
            type = "sqlite3";
            uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
            max_open_conns = 20;
            max_idle_conns = 2;
            max_conn_idle_time = null;
            max_conn_lifetime = null;
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
