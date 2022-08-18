# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.bootis.nixosModules.default
    ];

  # Boot options; bootis for Secure Boot :D
  boot = {
    loader = {
      bootis = {
        enable = true;

        extraConfig = {
          use_nvram = "false";

          resolution = "max";
          use_graphics_for = [ "linux" "windows" ];

          showtools = [ "memtest" "firmware" ];
          scanfor = [ "manual" "external" ];
        };

        extraEntries."Windows 11" = {
          loader = "/EFI/Microsoft/Boot/bootmgfw.efi";
        };
      };

      efi.canTouchEfiVariables = false;
      efi.efiSysMountPoint = "/boot/efi";
    };


    # initrd.secrets = {
    #   "/crypto_keyfile.bin" = /mnt/crypto_keyfile.bin;
    # };

    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "dm_snapshot" ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "acpi_osi=linux" "module_blacklist=hid_sensor_hub" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_5_18;

    initrd.luks.devices."luks-61a669ff-f7b4-4954-ab40-c59051fe23cc".device = "/dev/disk/by-uuid/61a669ff-f7b4-4954-ab40-c59051fe23cc";

    # # Enable swap on luks
    initrd.luks.devices."luks-91bbc690-f7b7-45f0-8ca6-c954df5d647d".device = "/dev/disk/by-uuid/91bbc690-f7b7-45f0-8ca6-c954df5d647d";
    # initrd.luks.devices."luks-91bbc690-f7b7-45f0-8ca6-c954df5d647d".keyFile = "/crypto_keyfile.bin";
    initrd.luks.reusePassphrases = true;
  };



  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4c600d55-1def-4ca8-9695-37c1fe69eeb1";
      fsType = "ext4";
    };


  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/35FF-1BA6";
      fsType = "vfat";
    };

  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
