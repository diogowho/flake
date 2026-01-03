{
  self,
  inputs,
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
        inputs
        ;
    };

    users.diogo = {
      imports = [ ./diogo ];
    };

    sharedModules = [ (self + /modules/home/default.nix) ];
  };
}
