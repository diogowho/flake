{
  sys = {
    profiles.graphical.enable = true;

    services.yabai.enable = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
