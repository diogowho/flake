{
  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "ehci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "virtio_blk"
        "virtio_net"
        "sd_mod"
        "sr_mod"
        "ahci"
      ];

      kernelModules = [ ];
    };

    tmp.cleanOnBoot = true;
  };

  zramSwap.enable = true;
}
