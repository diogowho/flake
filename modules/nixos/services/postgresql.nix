{
  self,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.postgresql;
in
{
  options.sys.services.postgresql = mkServiceOption "postgresql" {
    port = 5432;
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_18;

      ensureUsers = [
        {
          name = "postgres";
          ensureClauses = {
            superuser = true;
            login = true;
            createrole = true;
            createdb = true;
            replication = true;
          };
        }
      ];

      checkConfig = true;
      enableTCPIP = false;

      authentication = ''
        local all all peer
        host all all 127.0.0.1/32 md5
        host all all ::1/128 md5

        host all all 100.100.10.0/24 md5
      '';

      # https://pgconfigurator.cybertec.at/
      settings = {
        port = cfg.port;
        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
        log_destination = lib.mkForce "syslog";
      };
    };
  };
}
