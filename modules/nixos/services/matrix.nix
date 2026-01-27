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
    sops.secrets = {
      matrix = {
        sopsFile = "${self}/secrets/services/matrix.yaml";
        owner = "matrix-synapse";
        group = "matrix-synapse";
      };
      matrix-oidc-secret = {
        sopsFile = "${self}/secrets/services/matrix.yaml";
        key = "oidc-secret";
        owner = "matrix-synapse";
        group = "matrix-synapse";
      };
    };

    services = {
      matrix-synapse = {
        enable = true;

        settings = {
          withJemalloc = true;
          server_name = config.networking.domain;
          public_baseurl = "https://${cfg.domain}";

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

          oidc_providers = [
            {
              idp_id = "pocket_id";
              idp_name = "AS207118 ID";
              issuer = "https://id.as207118.net";
              client_id = "a9b22dd5-7a9b-423c-9245-ecce9f2243d1";
              client_secret_path = config.sops.secrets.matrix-oidc-secret.path;
              scopes = [
                "openid"
                "profile"
              ];
              user_mapping_provider = {
                config = {
                  localpart_template = "{{ user.preferred_username }}";
                  display_name_template = "{{ user.name }}";
                };
              };
            }
          ];
        };

        extraConfigFiles = [ config.sops.secrets.matrix.path ];
      };

      postgresql = {
        ensureDatabases = [ "matrix-synapse" ];
        initdbArgs = [
          "--lc-collate=C"
          "--lc-ctype=C"
        ];
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
