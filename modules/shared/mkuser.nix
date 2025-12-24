{
  lib,
  config,
  _class,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  users.users.diogo = (
    if _class == "darwin" then
      {
        home = "/Users/diogo";
      }
    else
      {
        hashedPassword = "$6$h/hPw1aKAbw/WKxy$IEnxYGD/esK890EjR5i4TlrDj6ph4DfZpiUdQ2FZp/LqXAkNzSN2BXUlmL4QQWJHsvjlbzIvULeLigfATRzyC.";
        home = "/home/diogo";
        uid = mkDefault 1000;
        isNormalUser = true;
        extraGroups = [ "wheel" ] ++ (if config.sys.services.docker.enable then [ "docker" ] else [ ]);
      }
  );
}
