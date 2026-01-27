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
      # keep-sorted start block=yes

      caddy.enable = true;
      matrix-bridges = {
        discord.enable = true;
        whatsapp.enable = true;
      };
      matrix.enable = true;
      pocket-id.enable = true;
      postgresql.enable = true;
      uptime-kuma.enable = true;
      # keep-sorted end
    };

    networking.bird.enable = true;
  };

  system.stateVersion = "25.11";
}
