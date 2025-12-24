{ inputs, ... }:
{
  _class = "darwin";

  system.defaults.CustomUserPreferences."com.apple.AdLib".allowApplePersonalizedAdvertising = false;

  imports = [
    ../shared
    inputs.home-manager.darwinModules.home-manager
    ./preferences
    ./networking.nix
    ./homebrew.nix
    ./services
  ];

  system = {
    stateVersion = 6;
    primaryUser = "diogo";
  };
}
