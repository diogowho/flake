{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    banner = ''
      Hiya!
    '';

    settings = {
      PermitRootLogin = "no";

      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
      UsePAM = false;

      UseDns = false;
      X11Forwarding = false;

      ClientAliveCountMax = 5;
      ClientAliveInterval = 60;
    };

    openFirewall = true;
    ports = [ 22 ];
  };
}
