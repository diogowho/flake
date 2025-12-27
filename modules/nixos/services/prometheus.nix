{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.prometheus;
in
{
  options.sys.services.prometheus = mkServiceOption "prometheus" {
    port = 9090;
    domain = "prometheus.${config.networking.domain}";
    scrapeTargets = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of targets to scrape (host:port)";
    };
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      listenAddress = cfg.host;
      port = cfg.port;
      webExternalUrl = "https://${cfg.domain}";

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "localhost:9100" ] ++ cfg.scrapeTargets;
            }
          ];
        }
      ];
    };

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy ${cfg.host}:${toString cfg.port}
    '';
  };
}
