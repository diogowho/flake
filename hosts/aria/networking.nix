{ lib, ... }:
let
  inherit (lib) mkForce;

  interface = "eth0";
  ipv4 = "91.98.172.30";
  gateway4 = "172.31.1.1";
  ipv6 = "2a01:4f8:1c1b:e1dd::1";
  gateway6 = "fe80::1";
in
{
  networking = {
    timeServers = [
      "ntp1.hetzner.de"
      "ntp2.hetzner.com"
      "ntp3.hetzner.net"
    ];

    defaultGateway = {
      address = gateway4;
      interface = interface;
    };

    defaultGateway6 = {
      address = gateway6;
      interface = interface;
    };

    dhcpcd.enable = mkForce false;
    usePredictableInterfaceNames = mkForce false;

    interfaces.${interface} = {
      ipv4 = {
        addresses = [
          {
            address = ipv4;
            prefixLength = 32;
          }
        ];

        routes = [
          {
            address = gateway4;
            prefixLength = 32;
          }
        ];
      };

      ipv6 = {
        addresses = [
          {
            address = ipv6;
            prefixLength = 64;
          }
          {
            address = "fe80::9000:7ff:fe0b:20a0";
            prefixLength = 64;
          }
        ];

        routes = [
          {
            address = gateway6;
            prefixLength = 128;
          }
        ];
      };
    };

    sits = {
      "207118" = {
        remote = "118.91.186.15";
        local = ipv4;
        ttl = 255;
      };
    };
  };
}
