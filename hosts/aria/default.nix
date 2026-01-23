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
      # keep-sorted start
      caddy.enable = true;
      pocket-id.enable = true;
      uptime-kuma.enable = true;
      # keep-sorted end
    };
  };

  system.stateVersion = "25.11";
}
