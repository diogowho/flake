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
      nodejs_24
      pnpm_9
      rustc
      rustfmt
      sops
      # keep-sorted end
      ;
  };
}
