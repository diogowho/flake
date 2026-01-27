{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = with pkgs; [
          # keep-sorted start
          deadnix
          keep-sorted
          nixfmt
          shfmt
          stylua
          # keep-sorted end
        ];

        settings = {
          on-unmatched = "info";
          tree-root-file = "flake.nix";
          excludes = [ "secrets/*" ];

          formatter = {
            # keep-sorted start block=yes newline_separated=yes
            deadnix = {
              command = "deadnix";
              options = [ "--edit" ];
              includes = [ "*.nix" ];
            };

            keep-sorted = {
              command = "keep-sorted";
              includes = [ "*" ];
            };

            nixfmt = {
              command = "nixfmt";
              includes = [ "*.nix" ];
            };

            shfmt = {
              command = "shfmt";
              options = [
                "-s"
                "-w"
                "-i"
                "2"
              ];
              includes = [
                "*.sh"
                "*.envrc"
              ];
            };

            stylua = {
              command = "stylua";
              includes = [ "*.lua" ];
            };
            # keep-sorted end
          };
        };
      };
    };
}
