{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.grafana;
in
{
  options.sys.services.grafana = mkServiceOption "grafana" {
    domain = "metrics.${config.networking.domain}";
    port = 3003;
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "grafana/database_host" = {
        sopsFile = "${self}/secrets/services/grafana.yaml";
        owner = "grafana";
        group = "grafana";
      };
      "grafana/database_user" = {
        sopsFile = "${self}/secrets/services/grafana.yaml";
        owner = "grafana";
        group = "grafana";
      };
      "grafana/database_password" = {
        sopsFile = "${self}/secrets/services/grafana.yaml";
        owner = "grafana";
        group = "grafana";
      };
    };

    services = {
      grafana = {
        enable = true;

        settings = {
          server = {
            root_url = "https://${cfg.domain}";
            domain = cfg.domain;
            http_port = cfg.port;
            http_addr = cfg.host;
            enforce_domain = true;
            enable_gzip = true;
          };

          database = {
            type = "postgres";
            host = "$__file{${config.sops.secrets."grafana/database_host".path}}";
            name = "grafana";
            user = "$__file{${config.sops.secrets."grafana/database_user".path}}";
            password = "$__file{${config.sops.secrets."grafana/database_password".path}}";
            ssl_mode = "require";
          };

          security.disable_gravatar = true;

          auth.oauth_allow_insecure_email_lookup = true;

          # "auth.basic".enabled = false;
          # "auth".disable_login_form = true;

          # "auth.generic_oauth" = {
          #   enabled = true;
          #   name = "Pocket ID";
          #   client_id = "$__file{${config.sops.secrets."grafana/client_id".path}}";
          #   client_secret = "$__file{${config.sops.secrets."grafana/client_secret".path}}";
          #   scopes = "openid profile email";
          #   auth_url = "https://id.diogocastro.net/authorize";
          #   token_url = "https://id.diogocastro.net/api/oidc/token";
          #   api_url = "";
          #   signout_redirect_url = "";
          #   allow_sign_up = false;
          #   auto_login = false;
          #   email_attribute_name = "email:primary";
          #   skip_org_role_sync = true;
          # };
        };

        provision.datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "https://${config.sys.services.prometheus.domain}";
            isDefault = true;
          }
        ];
      };

      caddy.virtualHosts.${cfg.domain}.extraConfig = ''
        reverse_proxy ${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
