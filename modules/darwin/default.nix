{
  inputs,
  lib,
  config,
  ...
}:
{
  _class = "darwin";

  imports = [
    inputs.home-manager.darwinModules.home-manager
    # keep-sorted start
    ../base
    ./homebrew
    ./networking
    ./preferences
    ./services
    # keep-sorted end
  ];

  system.defaults.CustomUserPreferences."com.apple.AdLib".allowApplePersonalizedAdvertising = false;

  system = {
    stateVersion = 6;
    primaryUser = "diogo";
  };

  power = lib.mkIf config.sys.profiles.workstation.enable {
    restartAfterFreeze = true;
    restartAfterPowerFailure = true;
    sleep = {
      computer = "never";
      display = 5;
    };
  };
}
