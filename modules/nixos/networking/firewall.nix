{
  lib,
  config,
  ...
}:
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

        checkReversePath = lib.mkForce false;
      };
    };
  };
}
