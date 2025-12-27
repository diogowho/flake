{ lib, ... }:
let
  inherit (lib) mkForce;

  interface = "eth0";
  ipv4 = "85.9.220.204";
  gateway4 = "85.9.220.1";
  ipv6 = "2a04:3545:1000:720:d40a:b0ff:fe52:2527";
  gateway6 = "fe80::987e:ff:fe45:89";
in
{
  networking = {
    defaultGateway = {
      address = gateway4;
      interface = interface;
    };

    defaultGateway6 = {
      address = gateway6;
      interface = interface;
    };

    dhcpcd.enable = mkForce false;
    useDHCP = mkForce false;

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
            prefixLength = 128;
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

  };

  systemd.network.wait-online.enable = false;
}
