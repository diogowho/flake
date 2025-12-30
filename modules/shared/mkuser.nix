{
  lib,
  _class,
  ...
}:
let
  inherit (lib) mkDefault mergeAttrsList optionalAttrs;
in
{
  users.users.diogo = mergeAttrsList [
    {
      shell = "/etc/profiles/per-user/diogo/bin/zsh";
    }

    (optionalAttrs (_class == "darwin") {
      home = "/Users/diogo";
    })

    (optionalAttrs (_class == "nixos") {
      hashedPassword = "$6$h/hPw1aKAbw/WKxy$IEnxYGD/esK890EjR5i4TlrDj6ph4DfZpiUdQ2FZp/LqXAkNzSN2BXUlmL4QQWJHsvjlbzIvULeLigfATRzyC.";
      home = "/home/diogo";
      uid = mkDefault 1000;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "nix"
      ];
    })
  ];
}
