{
  imports = [
    # keep-sorted start
    ./disko.nix
    ./hardware.nix
    ./networking.nix
    # keep-sorted end
  ];

  sys = {
    profiles.headless.enable = true;

    services = {
      caddy.enable = true;
      uptime-kuma.enable = true;
    };
  };

  system.stateVersion = "25.11";
}
