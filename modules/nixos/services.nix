{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Power Management
  services.upower.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  
  # Docker
  virtualisation.docker.enable = true;

  services.nginx = {
    enable = true;
    package = pkgs.openresty;
    user = "nginx";
    group = "nginx";

    # Adapt User's nginx.conf preferences
    eventsConfig = ''
      worker_connections 11768;
    '';

    appendHttpConfig = ''
      sendfile on;
      tcp_nopush on;
      
      ssl_prefer_server_ciphers on;
      
      access_log /var/log/nginx/access.log;
      error_log /var/log/nginx/error.log;
      
      gzip on;
      
      # Support for user managed configs
      include /etc/nginx/conf.d/*.conf;
      include /etc/nginx/sites-enabled/*;
    '';
  };
  
  # Create directories requested by user config
  systemd.tmpfiles.rules = [
    "d /var/log/nginx 0750 nginx nginx -"
    "d /etc/nginx/conf.d 0750 nginx nginx -"
    "d /etc/nginx/sites-enabled 0750 nginx nginx -"
  ];
  
  security.wrappers.mihomo = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin+eip";
    source = "${pkgs.mihomo}/bin/mihomo";
  };
}
