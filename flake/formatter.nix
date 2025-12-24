{
  perSystem =
    { pkgs, config, ... }:
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = with pkgs; [
          nixfmt
          shfmt
          keep-sorted
        ];

        settings = {
          on-unmatched = "info";
          tree-root-file = "flake.nix";

          formatter = {
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
              ];
            };

            keep-sorted = {
              command = "keep-sorted";
              includes = [ "*" ];
            };
          };
        };
      };
    };
}
