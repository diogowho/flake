{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = mkDefault false;
    execWheelOnly = true;
  };
}
