{ config, pkgs, dms, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    parsify
    wget
    docker
    htop
    rsync
    moreutils
    brightnessctl
    python3
    go
    google-chrome
    telegram-desktop
    go-musicfox
    git
    dms.packages.${pkgs.stdenv.hostPlatform.system}.default
    alacritty
    fuzzel
    xwayland-satellite

    localsend
    grim
    slurp
    nexttrace
    nmap
    netcat
    iperf3
    dnsutils

    wechat-uos
    qq
    joplin-desktop
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.dolphin
  ];
  
  # Install firefox.
  programs.firefox.enable = true;
  
  programs.nix-ld.enable = true;
}
