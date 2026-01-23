{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.sys.profiles.headless.enable {
    environment.variables.BROWSER = "echo";

    systemd = {
      enableEmergencyMode = false;

      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
      '';
    };
  };
}
