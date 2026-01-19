{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: Roboto, Helvetica, Arial, sans-serif;
          font-size: 13px;
          min-height: 0;
      }
      window#waybar {
          background-color: rgba(43, 48, 59, 0.5);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
      }
      window#waybar.hidden {
          opacity: 0.2;
      }
      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
      }
      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
          box-shadow: inherit;
          text-shadow: inherit;
      }
      #workspaces button.focused {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
          padding: 0 10px;
          color: #ffffff;
      }
      #window,
      #workspaces {
          margin: 0 4px;
      }
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }
      #clock {
          background-color: #64727D;
      }
      #battery {
          background-color: #ffffff;
          color: #000000;
      }
      #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
      }
      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }
      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      label:focus {
          background-color: #000000;
      }
      #network {
          background-color: #2980b9;
      }
      #network.disconnected {
          background-color: #f53c3c;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "cpu" "memory" "battery" "tray" ];
        
        "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
                active = "";
                default = "";
            };
        };

        "clock" = {
            format = "{:%Y-%m-%d %H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "battery" = {
            states = {
                warning = 30;
                critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = ["" "" "" "" ""];
        };
        
        "network" = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "niri/window" = {
            format = "{}";
            separate-outputs = true;
        };
      };
    };
  };

  programs.fuzzel.enable = true;

  # Override Gnome Settings to run with GNOME environment
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "System Settings";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
    categories = [ "GNOME" "GTK" "Settings" ];
    terminal = false;
  };

  # Niri Configuration
  xdg.configFile."niri/config.kdl".text = ''
    include "dms/outputs.kdl"
    spawn-at-startup "dms" "run"
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "fcitx5" "-d"
    spawn-at-startup "swww-daemon"

    input {
      keyboard {
        xkb {
          layout "us"
        }
      }
      touchpad {
        tap
        natural-scroll
      }
    }

    layout {
      gaps 16
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 4
        active-color "#7fc8ff"
        inactive-color "#505050"
      }
    }

    binds {
      Mod+Shift+Slash { show-hotkey-overlay; }

      Mod+Return { spawn "alacritty"; }
      Mod+D { spawn "fuzzel"; }
      // Mod+Super { spawn "fuzzel"; }

      Mod+Q { close-window; }
      Mod+O { toggle-overview; }

      Mod+Left  { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+Right { focus-column-right; }

      Mod+Shift+Left  { move-column-left; }
      Mod+Shift+Down  { move-window-down; }
      Mod+Shift+Up    { move-window-up; }
      Mod+Shift+Right { move-column-right; }

      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }

      Mod+Page_Down      { focus-workspace-down; }
      Mod+Page_Up        { focus-workspace-up; }
      Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }

      Mod+Shift+Page_Down { move-workspace-down; }
      Mod+Shift+Page_Up   { move-workspace-up; }

      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

      Mod+WheelScrollRight      { focus-column-right; }
      Mod+WheelScrollLeft       { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft  { move-column-left; }

      Mod+Shift+WheelScrollDown      { focus-column-right; }
      Mod+Shift+WheelScrollUp        { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

      Mod+TouchpadScrollDown      { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
      Mod+TouchpadScrollUp        { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "s" "+10%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "s" "10%-"; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+Ctrl+1 { move-column-to-workspace 1; }
      Mod+Ctrl+2 { move-column-to-workspace 2; }
      Mod+Ctrl+3 { move-column-to-workspace 3; }
      Mod+Ctrl+4 { move-column-to-workspace 4; }
      Mod+Ctrl+5 { move-column-to-workspace 5; }
      Mod+Ctrl+6 { move-column-to-workspace 6; }
      Mod+Ctrl+7 { move-column-to-workspace 7; }
      Mod+Ctrl+8 { move-column-to-workspace 8; }
      Mod+Ctrl+9 { move-column-to-workspace 9; }

      Mod+Comma  { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }

      Mod+BracketLeft  { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }

      Mod+R { switch-preset-column-width; }
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+C { center-column; }

      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }

      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }

      Mod+V { toggle-window-floating; }
      Mod+Shift+V { switch-focus-between-floating-and-tiling; }

      Mod+Shift+E { quit; }

      XF86Tools { spawn "env" "XDG_CURRENT_DESKTOP=GNOME" "gnome-control-center"; }
      Mod+I { spawn "env" "XDG_CURRENT_DESKTOP=GNOME" "gnome-control-center"; }

      XF86ScreenSaver { spawn "loginctl" "lock-session"; }
      Mod+L { spawn "loginctl" "lock-session"; }
    }
  '';
  
  # Random Wallpaper Script & Service
  systemd.user.services.random-wallpaper = {
    Unit = {
      Description = "Random Wallpaper Service";
      After = [ "swww-daemon.service" "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "set-random-wallpaper" ''
        # Find all jpg/png files in the wallpapers dir
        WALLPAPER=$(${pkgs.findutils}/bin/find ${../../wallpapers} -type f \( -name "*.jpg" -o -name "*.png" \) | ${pkgs.coreutils}/bin/shuf -n 1)
        
        # Apply the wallpaper if found
        if [ -n "$WALLPAPER" ]; then
          ${pkgs.swww}/bin/swww img "$WALLPAPER" --transition-type grow --transition-pos 0.5,0.5 --transition-fps 60
        fi
      ''}";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.timers.random-wallpaper = {
    Unit = {
      Description = "Rotate wallpaper every 30 minutes";
    };
    Timer = {
      OnUnitActiveSec = "30m";
      OnBootSec = "1m";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
