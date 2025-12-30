{ _class, ... }:
let
  sudoers = if (_class == "nixos") then "@wheel" else "@admin";
in
{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      allowed-users = [ sudoers ];
      trusted-users = [ sudoers ];

      accept-flake-config = false;

      use-xdg-base-directories = true;

      warn-dirty = false;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
