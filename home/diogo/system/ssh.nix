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
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        identityAgent = lib.mkIf config.sys.profiles.graphical.enable ''"~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"'';
      };

      # keep-sorted start block=yes newline_separated=yes
      "codeberg.org" = {
        user = "git";
        hostname = "codeberg.org";
      };

      "github.com" = {
        user = "git";
        hostname = "github.com";
      };
      # keep-sorted end
    };
  };

  home.file.".ssh/id_ed25519.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMT6iIuLEVTZh0XgYxD5pqAthx1JuiE8M7SwQo+wFBC+
  '';
}
