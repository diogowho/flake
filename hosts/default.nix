{ self, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
    perClass = class: {
      modules = [ "${self}/modules/${class}" ];
    };

    hosts = {
      # keep-sorted start block=yes newline_separated=yes
      dahlia = {
        modules = [ inputs.disko.nixosModules.disko ];
      };

      lotus = {
        modules = [ inputs.disko.nixosModules.disko ];
      };

      violet = {
        arch = "aarch64";
        class = "darwin";
      };
      # keep-sorted end
    };
  };
}
