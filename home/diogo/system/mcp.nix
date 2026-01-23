{ config, ... }:
{
  programs.mcp = {
    inherit (config.sys.profiles.graphical) enable;
    servers = {
      context7 = {
        url = "https://mcp.context7.com/mcp";
      };

      astro = {
        url = "https://mcp.docs.astro.build/mcp";
      };

      cloudflare = {
        url = "https://docs.mcp.cloudflare.com/mcp";
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
