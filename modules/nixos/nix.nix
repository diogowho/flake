{
  nix = {
    gc.dates = "Mon *-*-* 05:00";

    optimise = {
      automatic = true;
      dates = [ "06:00" ];
    };
  };
}
