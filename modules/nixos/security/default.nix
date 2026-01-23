{
  imports = [
    # keep-sorted start
    ./sudo.nix
    # keep-sorted end
  ];

  security.loginDefs.settings.ENCRYPT_METHOD = "SHA512";
}
