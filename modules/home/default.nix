{
  _class = "homeManager";

  imports = [
    # keep-sorted start
    ../base/packages.nix
    ../base/profiles.nix
    ./home.nix
    ./profiles.nix
    ./secrets.nix
    ./shell.nix
    # keep-sorted end
  ];
}
