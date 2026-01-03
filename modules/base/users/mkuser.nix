{
  lib,
  _class,
  ...
}:
let
  inherit (lib)
    mkDefault
    mergeAttrsList
    optionalAttrs
    ;
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
