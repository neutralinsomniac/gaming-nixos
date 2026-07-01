{ pkgs, ... }:
{
  config = {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
      openFirewall = true;
      package = pkgs.sunshine.override {
        cudaSupport = true;
        cudaPackages = pkgs.cudaPackages;
      };
    };

    users.users.jeremy = {
      extraGroups = [ "uinput" ];
    };
  };
}
