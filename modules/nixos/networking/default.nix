{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkDefault mkForce;
in
{
  imports = [
    # keep-sorted start
    ./fail2ban.nix
    ./firewall.nix
    ./openssh.nix
    # keep-sorted end
  ];

  networking = {
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    usePredictableInterfaceNames = mkDefault true;

    nameservers = [
      "9.9.9.9"
      "1.1.1.2"
      "149.112.112.112"
      "1.0.0.2"
      "2620:fe::fe"
      "2606:4700:4700::1112"
      "2620:fe::9"
      "2606:4700:4700::1002"
    ];

    enableIPv6 = true;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      unmanaged = [ "type:bridge" ];
    };
  };

  services.resolved.enable = true;

  systemd = {
    network.wait-online.enable = false;

    services = {
      NetworkManager-wait-online.enable = false;

      systemd-networkd.stopIfChanged = false;
      systemd-resolved.stopIfChanged = false;
    };
  };
}
