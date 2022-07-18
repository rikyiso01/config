# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/common/pc/laptop/ssd>
      <nixos-hardware/common/pc/laptop>
      <nixos-hardware/common/pc/laptop/acpi_call.nix>
      <nixos-hardware/common/cpu/intel>
    ];

  boot.loader.systemd-boot.extraEntries = { "manjaro.conf" = ''
                                          title Manjaro
                                          efi /EFI/Manjaro/grubx64.efi
                                        ''; };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.utf8";
    LC_IDENTIFICATION = "it_IT.utf8";
    LC_MEASUREMENT = "it_IT.utf8";
    LC_MONETARY = "it_IT.utf8";
    LC_NAME = "it_IT.utf8";
    LC_NUMERIC = "it_IT.utf8";
    LC_PAPER = "it_IT.utf8";
    LC_TELEPHONE = "it_IT.utf8";
    LC_TIME = "it_IT.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "it";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.riky = {
    isNormalUser = true;
    description = "riky";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     micro
     lsof
     git
   ];

   environment.gnome.excludePackages = (with pkgs; [
     gnome-photos
   ]) ++ (with pkgs.gnome; [
     cheese # webcam tool
     gnome-music
     epiphany # web browser
     geary # email reader
     totem # video player
     tali # poker game
     iagno # go game
     hitori # sudoku game
     atomix # puzzle game
     gnome-contacts
     gnome-weather
     gnome-clocks
     gnome-maps
     gnome-calendar
     gnome-calculator
     simple-scan
   ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  users.defaultUserShell = pkgs.zsh;

  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.gnupg.agent.enable=true;
}
