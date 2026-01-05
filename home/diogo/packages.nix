{ pkgs, ... }:
{
  sys.packages = {
    inherit (pkgs)
      # keep-sorted start
      age
      cargo
      just
      nil
      nixd
      rustc
      rustfmt
      sops
      # keep-sorted end
      ;
  };
}
