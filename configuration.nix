{ config, pkgs, ... }:
let
  unstable = import (import ./nixpkgs-src.nix).unstable { config = {allowUnfree = true; }; };
  #my_steam = (pkgs.steam.override { nativeOnly = true; });
  my_steam = unstable.steam;
  steam_autostart = (pkgs.makeAutostartItem { name = "steam"; package = my_steam; });
in
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "gamer"; # Define your hostname.
  networking.networkmanager.enable = true;

  # open ports for steam stream and some games
  networking.firewall.allowedTCPPorts = with pkgs.lib; [ 27036 27037 ] ++ (range 27015 27030);
  networking.firewall.allowedUDPPorts = with pkgs.lib; [ 4380 27036 ] ++ (range 27000 27031);
  networking.firewall.allowPing = true;
  
  environment.systemPackages = with pkgs; [
    wget vim htop
    # GAMING
    my_steam
    steam_autostart
    steam-run
  ];

  # enable ssh
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Xbox controller
  boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

  # Gaming 32bit
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm = {
    enable = true;
    autoLogin = {
      enable = true;
      user = "gamer";
    };
  };
  services.xserver.desktopManager.plasma5.enable = true;

  # Users
  users = {
    mutableUsers = false;
    users = {
      gamer = {
        password = "";
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enables ‘sudo’ for the user.
      };
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDuhpzDHBPvn8nv8RH1MRomDOaXyP4GziQm7r3MZ1Syk" 
      ];
    };
  };

  # In case nix builds are executed from that machine.
  nix.maxJobs = 20;

  # timezone
  time.timeZone = "Asia/Bangkok";

  systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  boot.kernelPackages = pkgs.linuxPackages_latest;
}

