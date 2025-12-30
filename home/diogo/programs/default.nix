{ pkgs, ... }:
{
  imports = [
    # keep-sorted start
    ./btop.nix
    ./fastfetch
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./neovim
    ./ohmyposh
    ./ripgrep.nix
    ./tmux.nix
    ./zsh.nix
    # keep-sorted end
  ];

  sys.packages = {
    inherit (pkgs)
      # keep-sorted start
      age
      just
      nil
      nixd
      sops
      # keep-sorted end
      ;
  };
}
