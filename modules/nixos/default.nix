{ inputs, ... }:
{
  _class = "nixos";

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.diogopkgs.nixosModules.default
    # keep-sorted start
    ../shared
    ./headless.nix
    ./networking
    ./secrets.nix
    ./services
    ./sudo.nix
    # keep-sorted end
  ];

  users.mutableUsers = false;

  nix = {
    gc.dates = "Mon *-*-* 04:00";

    optimise = {
      automatic = true;
      dates = [ "04:30" ];
    };
  };
}
