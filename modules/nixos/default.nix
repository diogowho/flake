{ inputs, ... }:
{
  _class = "nixos";

  imports = [
    ../shared
    inputs.home-manager.nixosModules.home-manager
    ./headless.nix
    ./networking
    ./sudo.nix
    ./secrets.nix
    inputs.diogopkgs.nixosModules.default
    ./services
  ];

  nix = {
    gc.dates = "Mon *-*-* 04:00";

    optimise = {
      automatic = true;
      dates = [ "04:30" ];
    };
  };
}
