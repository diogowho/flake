{ pkgs, ... }:
{
  sys.packages = {
    inherit (pkgs)
      # keep-sorted start
      age
      cargo
      inetutils
      iperf
      just
      mtr
      nil
      nixd
      nmap
      nodejs_24
      pnpm_9
      rustc
      rustfmt
      sops
      # keep-sorted end
      ;
  };
}
