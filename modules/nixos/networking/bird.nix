{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.sys.networking.bird;
in
{
  options.sys.networking.bird.enable = mkEnableOption "BIRD";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 179 ];

    services.bird = {
      enable = true;
      package = pkgs.bird2;

      config = ''
        router id 91.98.172.30;

        protocol device {
          scan time 10;
        }

        protocol kernel {
          ipv6 {
            import all;
            export all;
          };
        }

        protocol static {
          ipv6;
          route 2a14:6f44:f00d::/48 blackhole;
        }

        protocol bgp ifog_peer {
          local as 207118;
          neighbor 2a14:6f44:f00d::1 as 34927;

          ipv6 {
            import all;
            export filter {
              if net = 2a14:6f44:f00d::/48 then accept;
              reject;
            };
          };

          hold time 30;
          keepalive time 10;
        }
      '';
    };
  };
}
