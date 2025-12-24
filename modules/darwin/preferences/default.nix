{
  imports = [
    ./dock.nix
    ./keyboard.nix
    ./safari.nix
  ];

  system.defaults = {
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

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    finder = {
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXRemoveOldTrashItems = true;
      ShowHardDrivesOnDesktop = true;
    };

    CustomUserPreferences."com.apple.finder" = {
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      _FXSortFoldersFirst = true;
      FXDefaultSearchScope = "SCcf";
      WarnOnEmptyTrash = false;
    };

    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
    };

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };
  };

  system.activationScripts.postActivate.text = ''
    #!/usr/bin/env bash
    set -e

    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  '';
}
