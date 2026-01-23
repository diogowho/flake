{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
        "ext4"
      ];

      kernelModules = [ ];
    };

    tmp.cleanOnBoot = true;
  };

  swapDevices = [ ];

  zramSwap.enable = true;
}
