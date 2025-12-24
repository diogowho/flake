{
  self,
  self',
  inputs,
  inputs',
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    extraSpecialArgs = {
      inherit
        self
        self'
        inputs
        inputs'
        ;
    };

    users.diogo = {
      imports = [ ./diogo ];
    };

    sharedModules = [ (self + /modules/home/default.nix) ];
  };
}
