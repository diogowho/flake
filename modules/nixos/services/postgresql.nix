{
  lib,
  self,
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
  options.sys.services.postgresql = mkServiceOption "PostgreSQL" {
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

      # TODO: http://pgconfigurator.cybertec.at/
      settings = { };
    };
  };
}
