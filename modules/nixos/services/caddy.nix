{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.caddy;
in
{
  options.sys.services.caddy = mkServiceOption "Caddy" {
    domain = "diogocastro.net";
  };

  config = mkIf cfg.enable {
    sops.secrets.cloudflare = {
      sopsFile = "${self}/secrets/services/cloudflare.yaml";
      owner = "caddy";
      group = "caddy";
    };

    networking = {
      inherit (cfg) domain;

      firewall.allowedTCPPorts = [
        80
        443
      ];
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "hello@${cfg.domain}";
      certs.${cfg.domain} = {
        extraDomainNames = [ "*.${cfg.domain}" ];
        dnsProvider = "cloudflare";
        credentialsFile = config.sops.secrets.cloudflare.path;
      };
    };

    users.users.caddy.extraGroups = [ "acme" ];

    services.caddy.enable = true;
  };
}
