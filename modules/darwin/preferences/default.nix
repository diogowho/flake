{ config, ... }:
{
  imports = [
    # keep-sorted start
    ./dock.nix
    ./finder.nix
    ./keyboard.nix
    ./safari.nix
    # keep-sorted end
  ];

  system.defaults = {
    # keep-sorted start block=yes newline_separated=yes
    NSGlobalDomain = {
      AppleShowScrollBars = "WhenScrolling";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSScrollAnimationEnabled = true;
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
    };

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
      AirDrop = false;
    };

    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
    };

    magicmouse.MouseButtonMode = "TwoButton";

    screensaver = {
      askForPassword = !config.sys.profiles.workstation.enable;
      askForPasswordDelay = 0;
    };

    trackpad.ActuateDetents = true;
    # keep-sorted end
  };

  system.activationScripts.postActivate.text = ''
    #!/usr/bin/env bash
    set -e

    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  '';
}
