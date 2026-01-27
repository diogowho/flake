{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.uptime-kuma;
in
{
  options.sys.services.uptime-kuma = mkServiceOption "Uptime Kuma" {
    port = 4000;
    domain = "status.as207118.net";
  };

  config = mkIf cfg.enable {
    services = {
      uptime-kuma = {
        enable = true;

        settings = {
          HOST = "127.0.0.1";
          PORT = toString cfg.port;
        };
      };

      caddy.virtualHosts.${cfg.domain}.extraConfig =
        "reverse_proxy http://${cfg.host}:${toString cfg.port}";
    };
  };
}
