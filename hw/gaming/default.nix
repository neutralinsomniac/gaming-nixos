{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.nvidia.modesetting.enable = true;
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;
  };
}
