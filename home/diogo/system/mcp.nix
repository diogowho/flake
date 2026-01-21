{ config, ... }:
{
  programs.mcp = {
    inherit (config.sys.profiles.graphical) enable;
    servers = {
      context7 = {
        url = "https://mcp.context7.com/mcp";
      };

      opensrc = {
        command = "npx";
        args = [
          "-y"
          "opensrc-mcp"
        ];
      };
    };
  };
}
