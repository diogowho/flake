{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sys.networking.openssh;
in
{
  options.sys.networking.openssh.enable = mkEnableOption "OpenSSH";

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
