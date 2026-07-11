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
    docker.enable = true;
    libvirtd.enable = false;
  };

  boot.kernelModules = [ "kvm-intel" ];
  boot.supportedFilesystems = [ "ntfs" ];  # ability to mount windows

  users.users.romanzinin = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  programs = {
    niri.enable = true;
    zsh.enable = true;
    noctalia-greeter.enable = true;
    nix-ld.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    nano
    wget
    fuzzel
    tree
    xwayland-satellite
    telegram-desktop
    kdePackages.polkit-kde-agent-1
    nautilus
    vscode
    blueman
    noctalia-shell
    brightnessctl
    wev
    obsidian
    qt6Packages.qt6ct
    jq
    starship
    btop
    eog
    claude-code
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

  system.stateVersion = "26.05"; # Don't change
}
