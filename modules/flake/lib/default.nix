{ lib, ... }:
let
  sysLib = lib.fixedPoints.makeExtensible (final: {
    services = import ./services.nix { inherit lib; };

    inherit (final.services) mkServiceOption;
  });
in
{
  flake.lib = sysLib;
}
