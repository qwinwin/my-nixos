{ config, pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Open ports for LocalSend
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
    checkReversePath = "loose";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };
}
