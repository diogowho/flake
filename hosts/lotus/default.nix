{
  imports = [
    ./disko.nix
    ./hardware.nix
    ./networking.nix
  ];

  sys = {
    profiles.headless.enable = true;

    services = {
      # keep-sorted start
      caddy.enable = true;
      website.enable = true;
      # keep-sorted end
    };

    networking.netbird.enable = true;
  };

  system.stateVersion = "25.11";
}
