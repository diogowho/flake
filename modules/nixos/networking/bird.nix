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
    networking.firewall = {
      allowedTCPPorts = [ 179 ];
      checkReversePath = "loose";
    };

    services.bird = {
      enable = true;
      package = pkgs.bird2;

      config = ''
        define ASN_SELF = 207118;
        define SELF_PREFIXES = [ 2a14:6f44:f00d::/48 ];
        define IP4_HOST = 118.91.186.15;
        define IP6_HOST = 2a0c:9a40:1036:101::1943;

        define TIER1_ASNS = [ 174, 209, 701, 702, 1239, 1299, 2914, 3257, 3320, 3356, 3491, 3549, 3561, 4134, 5511, 6453, 6461, 6762, 6830, 7018 ];
        define BOGON_ASNS = [ 0, 23456, 64496..64511, 64512..65534, 65535, 65536..65551, 65552..131071, 4200000000..4294967294, 4294967295 ];
        define BOGON_PREFIXES_V6 = [ 3ffe::/16+, 2001:db8::/32+, 2001::/33+, 2002::/17+, 0000::/8+, fe00::/8+, ::/128-, ::/0{0,15}, ::/0{64,128} ];

        define ASN_IFOG = 34927;
        define IP6_IFOG = 2a0c:9a40:1036:101::1;

        define ASN_FOGIXP = 47498;
        define IP6_FOGIXP = 2001:7f8:ca:1:0:20:7118:1;

        router id IP4_HOST;
        log syslog all;

        filter export_own {
          if net ~ SELF_PREFIXES then accept;
          reject;
        }

        filter standard_import {
          if bgp_path.len > 24 then reject;

          if (net.len < 16) || (net.len > 48) then reject;

          if bgp_path ~ BOGON_ASNS then reject;

          if bgp_path ~ TIER1_ASNS then reject;

          if net ~ BOGON_PREFIXES_V6 then reject;

          accept;
        }

        filter ixp_import {
          if (net.len < 16) || (net.len > 48) then reject;
          if bgp_path.len > 24 then reject;
          if bgp_path ~ BOGON_ASNS then reject;
          if net ~ BOGON_PREFIXES_V6 then reject;

          if bgp_path.first ~ TIER1_ASNS then reject;

          bgp_local_pref = 400;

          accept;
        }

        template bgp bgp6 {
          local as ASN_SELF;

          graceful restart on;
        }

        template bgp peer6 from bgp6 {
          source address IP6_HOST;

          local role peer;

          hold time 600;
        }

        protocol device {
          scan time 5;
        }

        protocol direct {
          ipv6;
          interface "eth0";
        }

        protocol kernel {
          scan time 15;
          ipv6 {
            import all;
            export filter {
              krt_prefsrc = 2a14:6f44:f00d::1;
              accept;
            };
          };
          learn on;
          persist;
        }

        protocol static r6_export {
          ipv6;
          route 2a14:6f44:f00d::/48 blackhole;
        }

        protocol bgp ifog_peer from peer6 {
          neighbor IP6_IFOG as ASN_IFOG;
          
          ipv6 {
            import all;
            export filter export_own;
          };
        }

        template bgp fog6 from peer6 {
          source address IP6_FOGIXP;
          interface "eth-fogixp";
        }

        protocol bgp fogixp_r1 from fog6 {
          neighbor 2001:7f8:ca:1::111 as ASN_FOGIXP;
          
          ipv6 {
            import filter ixp_import;
            export filter export_own;
          };

          default bgp_local_pref 400;
        }

        protocol bgp fogixp_r2 from fog6 {
          neighbor 2001:7f8:ca:1::222 as ASN_FOGIXP;

          ipv6 {
            import filter ixp_import;
            export filter export_own;
          };

          default bgp_local_pref 400;
        }
      '';
    };
  };
}
