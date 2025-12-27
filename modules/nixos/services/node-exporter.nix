{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.node-exporter;
in
{
  options.sys.services.node-exporter = mkServiceOption "node-exporter" {
    port = 9100;
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = cfg.port;
      listenAddress = cfg.host;
      enabledCollectors = [ "systemd" ];
    };
  };
}
