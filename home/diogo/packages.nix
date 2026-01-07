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
      nodejs_24
      pnpm_9
      # keep-sorted end
      ;
  };
}
