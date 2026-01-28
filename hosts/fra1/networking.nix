{ lib, ... }:
let
  inherit (lib) mkForce;

  interface = "eth0";
  ipv4 = "118.91.186.15";
  gateway4 = "118.91.186.1";
  ipv6 = "2a0c:9a40:1036:101::1943";
  gateway6 = "2a0c:9a40:1036:101::1";
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
    usePredictableInterfaceNames = mkForce false;

    interfaces = {
      ${interface} = {
        ipv4 = {
          addresses = [
            {
              address = ipv4;
              prefixLength = 25;
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
              address = "2a14:6f44:f00d::1";
              prefixLength = 48;
            }
          ];
        };
      };
    };
  };
}
