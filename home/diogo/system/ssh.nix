{
  lib,
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        hashKnownHosts = true;
        compression = true;
        identityAgent = lib.mkIf config.sys.profiles.graphical.enable ''"~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"'';
      };

      "daisy".hostname = "85.9.220.204";
      "lotus".hostname = "51.75.255.245";

      "codeberg.org" = {
        user = "git";
        hostname = "codeberg.org";
      };

      "github.com" = {
        user = "git";
        hostname = "github.com";
      };
    };
  };
}
