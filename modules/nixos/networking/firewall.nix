{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkForce;
in
{
  config = {
    networking = {
      nftables.enable = true;

      firewall = {
        enable = true;

        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];

        allowedTCPPortRanges = [ ];
        allowedUDPPortRanges = [ ];

        allowPing = config.sys.profiles.headless.enable;

        logReversePathDrops = true;
        logRefusedConnections = false;

        # checkReversePath = mkForce false;
      };
    };
  };
}
