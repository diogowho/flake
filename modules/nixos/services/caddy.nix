{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.sys.services.caddy;
in
{
  options.sys.services.caddy = {
    enable = mkEnableOption "Caddy";

    domain = mkOption {
      type = str;
      default = "diogocastro.net";
      description = "Domain for Caddy";
    };
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
