{
  description = "diogo's dotfiles";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # keep-sorted start block=yes newline_separated=yes
    catppuccin = {
      type = "github";
      owner = "catppuccin";
      repo = "nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      type = "github";
      owner = "nix-darwin";
      repo = "nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    easy-hosts = {
      type = "github";
      owner = "tgirlcloud";
      repo = "easy-hosts";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew = {
      type = "github";
      owner = "zhaofengli";
      repo = "nix-homebrew";
    };

    sops = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end
  };

  outputs =
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./modules/flake ]; };
}
