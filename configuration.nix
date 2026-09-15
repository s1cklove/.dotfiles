# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    modules/happ/happ-module.nix

    inputs.noctalia-greeter.nixosModules.default
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
 
  networking.networkmanager.enable = true;  # nmcli/nmtui

  time.timeZone = "Europe/Moscow";

  services = {
    pipewire.enable = true;
    pipewire.pulse.enable = true;
    libinput.enable = true;  # touchpad support
    tuned.enable = true;
    happ.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    upower.enable = true;
    udisks2.enable = true;
    desktopManager.plasma6.enable = true;  # for cisco
  };
  
  security = {
    rtkit.enable = true;  # audio no-lag
    polkit.enable = true;  # root for apps
    pam.services.login.enableGnomeKeyring = true;

    sudo.extraRules = [{
      users = ["romanzinin"];
      commands = [{ command = "ALL";
        options = ["NOPASSWD"];
      }];
    }];
  };

  virtualisation = {
    podman.enable = true;
    libvirtd.enable = false;
    containers.enable = true;

    podman = {
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  boot.kernelModules = [ "kvm-intel" ];
  boot.supportedFilesystems = [ "ntfs" ];  # ability to mount windows
  boot.kernelParams = [ "pcie_asp=off" ];

  users.users.romanzinin = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "podman"
    ];
    shell = pkgs.zsh;
  };

  programs = {
    niri.enable = true;
    zsh.enable = true;
    noctalia-greeter.enable = true;
    nix-ld.enable = true;
    obs-studio.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # cli utils
    nano
    wget
    btop
    tree
    zip
    mc
    starship
    fuzzel

    # wayland problems
    xwayland-satellite
    kdePackages.polkit-kde-agent-1
    qt6Packages.qt6ct # qt-compatibility for apps like happ
    wev

    # nixos bicycles
    alsa-utils  # fixing sound issues on monitor connection
    pkg-config
    noctalia-shell
    blueman  # aka bluetooth manager
    brightnessctl
    jq

    # apps
    google-chrome  # chromium fallback
    telegram-desktop
    vscode
    qbittorrent


    # media + text ui
    gnome-text-editor
    nautilus
    eog
    vlc
    mpv

    # kubernetes
    kubectl
    kubelogin-oidc
    kubernetes-helm
    k9s

    # lectory utils
    alembic
    ffmpeg
    kdePackages.kdenlive

    # utilities
    claude-code
    docker-compose
    python3
    openssl
    duckdb
    sqlite
    gcc
    openconnect  # for job vpn
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      };
    };
  };

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.noctalia-greeter = {
    greeter-args = "";
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
      keyboard = {
        layout = "us";
      };
    };
  };

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    icu
    # add more here if you hit further "cannot open shared object file" errors
  ];

  services.nginx = {
    enable = true;
    appendHttpConfig = ''
      include /etc/nginx/sites-enabled/*;
    '';
  };

  environment.etc."nginx/sites-available/lectory".text = ''
    server {
        listen 443 ssl;
        server_name localhost;

        ssl_certificate /etc/nginx/ssl/localhost.crt;
        ssl_certificate_key /etc/nginx/ssl/localhost.key;

        location /ws/ {
            proxy_pass http://localhost:8000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_read_timeout 86400;
        }

        location / {
            proxy_pass http://localhost:8000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
  '';

  environment.etc."nginx/sites-enabled/lectory".source =
    config.environment.etc."nginx/sites-available/lectory".source;

  system.stateVersion = "26.05"; # Don't change
}
