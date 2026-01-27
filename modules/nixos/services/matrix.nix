{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.matrix;
in
{
  options.sys.services.matrix = mkServiceOption "Matrix Homeserver" {
    port = 8448;
    domain = "matrix.${config.networking.domain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.matrix = {
      sopsFile = "${self}/secrets/services/matrix.yaml";
      owner = "matrix-synapse";
      group = "matrix-synapse";
    };

    services = {
      matrix-synapse = {
        enable = true;

        settings = {
          withJemalloc = true;
          server_name = config.networking.domain;

          bcrypt_rounds = 14;

          enable_registration = false;

          database = {
            name = "psycopg2";
            args = {
              host = "/run/postgresql";
              user = "matrix-synapse";
              database = "matrix-synapse";
            };
          };

          listeners = [
            {
              inherit (cfg) port;
              bind_addresses = [ "::1" ];
              resources = [
                {
                  names = [
                    "client"
                    "federation"
                  ];
                  compress = true;
                }
              ];
              tls = false;
              type = "http";
              x_forwarded = true;
            }
          ];
        };

        extraConfigFiles = [ config.sops.secrets.matrix.path ];
      };

      postgresql = {
        ensureDatabases = [ "matrix-synapse" ];
        ensureUsers = lib.singleton {
          name = "matrix-synapse";
          ensureDBOwnership = true;
        };
      };

      caddy.virtualHosts.${cfg.domain}.extraConfig = ''
        reverse_proxy /_matrix/* http://::1:${toString cfg.port}
        reverse_proxy /_synapse/client/* http://::1:${toString cfg.port}
      '';
    };
  };
}
