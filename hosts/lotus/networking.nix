{ lib, ... }:
let
  inherit (lib) mkForce;

  interface = "ens3";
  ipv4 = "51.75.255.245";
  gateway4 = "51.75.248.1";
  ipv6 = "2001:41d0:305:2100::7785";
  gateway6 = "2001:41d0:305:2100::1";
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
}
