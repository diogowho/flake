{
  lib,
  config,
  self,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.pocket-id;
in
{
  options.sys.services.pocket-id = mkServiceOption "Pocket ID" {
    port = 1411;
    domain = "id.as207118.net";
  };

  config = mkIf cfg.enable {
    sops.secrets.pocket-id = {
      sopsFile = "${self}/secrets/services/pocket-id.yaml";
      owner = "pocket-id";
      group = "pocket-id";
    };

    services = {
      pocket-id = {
        enable = true;

        settings = {
          # keep-sorted start
          ALLOW_USER_SIGNUPS = "disabled";
          ANALYTICS_DISABLED = true;
          APP_URL = "https://${cfg.domain}";
          EMAILS_VERIFIED = true;
          PORT = cfg.port;
          TRUST_PROXY = true;
          UI_CONFIG_DISABLED = true;
          # keep-sorted end
        };

        environmentFile = config.sops.secrets.pocket-id.path;
      };

      caddy.virtualHosts.${cfg.domain}.extraConfig =
        "reverse_proxy http://${cfg.host}:${toString cfg.port}";
    };
  };
}
