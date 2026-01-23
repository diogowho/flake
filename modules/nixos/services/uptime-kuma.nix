{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) port str;

  cfg = config.sys.services.uptime-kuma;
in
{
  options.sys.services.uptime-kuma = {
    enable = mkEnableOption "Uptime Kuma";

    port = mkOption {
      type = port;
      default = 4000;
      description = "Port for Uptime Kuma";
    };

    domain = mkOption {
      type = str;
      default = "status.as207118.net";
      description = "Domain name for Uptime Kuma";
    };
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
        "reverse_proxy http://127.0.0.1:${toString cfg.port}";
    };
  };
}
