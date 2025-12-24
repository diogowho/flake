{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.sys.services.website;
in
{
  options.sys.services.website = mkServiceOption "website" { };

  config = mkIf cfg.enable {
    services.diogocastro-website.enable = true;
    # services.kowo.enable = true;
    services.ipw-rb.enable = true;
    services.chris-ipw.enable = true;
  };
}
