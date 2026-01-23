{ inputs, ... }:
{
  _class = "nixos";

  imports = [
    inputs.home-manager.nixosModules.home-manager
    # keep-sorted start prefix_order=../../,./
    ./headless.nix
    ./networking
    ./nix.nix
    ./secrets.nix
    ./security
    ./services
    ./users
    ../base
    # keep-sorted end
  ];
}
