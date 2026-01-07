{ config, ... }:
{
  programs.mcp = {
    inherit (config.sys.profiles.graphical) enable;
    servers = { };
  };
}
