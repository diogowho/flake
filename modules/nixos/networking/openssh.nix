{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    banner = ''
      Heya!
    '';

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AuthenticationMethods = "publickey";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
      UsePAM = false;

      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
        "diffie-hellman-group-exchange-sha256"
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
      ];

      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];

      ClientAliveCountMax = 5;
      ClientAliveInterval = 60;
    };

    openFirewall = true;
    ports = [ 22 ];
  };

  users.users.diogo.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCTbCHJ0avif6MQ7izXlHHaubNsOhU2xf9lMvXKLyUQ"
  ];
}
