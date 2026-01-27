{ lib }:
let
  inherit (lib) types;
  inherit (lib.options) mkOption mkEnableOption;

  mkServiceOption =
    name:
    {
      port ? 0,
      host ? "127.0.0.1",
      domain ? "",
    }:
    {
      enable = mkEnableOption "Enable the ${name} service";

      host = mkOption {
        type = types.str;
        default = host;
        description = "Host for the ${name} service";
      };

      port = mkOption {
        type = types.port;
        default = port;
        description = "Port for the ${name} service";
      };

      domain = mkOption {
        type = types.str;
        default = domain;
        defaultText = "networking.domain";
        description = "Domain name for the ${name} service";
      };
    };
in
{
  inherit mkServiceOption;
}
