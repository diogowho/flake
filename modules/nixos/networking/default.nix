{ lib, config, ... }:
let
  inherit (lib) mkForce mkDefault;
in
{
  imports = [
    # keep-sorted start
    ./fail2ban.nix
    ./firewall.nix
    ./netbird.nix
    ./openssh.nix
    # keep-sorted end
  ];

  networking = {
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      unmanaged = [ "type:bridge" ];
    };

    usePredictableInterfaceNames = mkDefault true;

    nameservers = [
      "9.9.9.9"
      "1.1.1.1"
      "2620:fe::fe"
      "2606:4700:4700::1111"
    ];

    enableIPv6 = true;
  };
}
