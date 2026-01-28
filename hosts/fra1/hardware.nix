{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    kernelParams = [
      "console=ttyS0,115200"
      "console=tty1"
    ];

    tmp.cleanOnBoot = true;
  };

  swapDevices = [ ];

  zramSwap.enable = true;
}
