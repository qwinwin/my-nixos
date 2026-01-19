{ antigravity-nix, ... }:

{
  imports = [
    ./shell.nix
    ./desktop.nix
    ./apps.nix
    ./input.nix
  ];

  home.username = "kwin";
  home.homeDirectory = "/home/kwin";

  # This checks system state compatibility (not the exact home-manager version)
  home.stateVersion = "24.11"; 
  
  # Allow home-manager to manage itself
  programs.home-manager.enable = true;
}
