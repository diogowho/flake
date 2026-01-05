{ config, ... }:
{
  programs.opencode = {
    inherit (config.sys.profiles.graphical) enable;
  };
}
