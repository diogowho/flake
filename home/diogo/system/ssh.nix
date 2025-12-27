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
