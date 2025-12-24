{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.sys.networking.netbird;
in
{
  options = {
    sys.networking.netbird.enable = mkEnableOption "NetBird";
  };

  config = mkIf cfg.enable {
    services.netbird.enable = true;
  };
}
