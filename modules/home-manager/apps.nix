{ config, pkgs, antigravity-nix, ... }:

{
  home.packages = [
    antigravity-nix.packages.x86_64-linux.default
    pkgs.quickshell
    pkgs.zsh-completions
    pkgs.swww
    pkgs.mihomo
    pkgs.flclash
    pkgs.gnome-control-center
    pkgs.wev
  ];

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      sponsorblock
    ];
    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
    };
  };

  systemd.user.services.mihomo = {
    Unit = {
      Description = "Mihomo Service";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "/run/wrappers/bin/mihomo -f /home/kwin/.config/w";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
