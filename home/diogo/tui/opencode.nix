{ config, ... }:
{
  programs.opencode = {
    inherit (config.sys.profiles.graphical) enable;
    settings = {
      theme = "catppuccin";
    };
    enableMcpIntegration = true;
  };
}
