{
  imports = [
    # keep-sorted start
    ./diogo.nix
    # keep-sorted end
  ];

  config = {
    users.mutableUsers = false;
  };
}
