{ config, pkgs, ... }:

{
  # Define a user account.
  users.users.kwin = {
    isNormalUser = true;
    description = "kwin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };
  
  programs.zsh.enable = true;
}
