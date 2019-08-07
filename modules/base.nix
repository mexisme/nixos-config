{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ../home/base.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    buildCores = 0;
    autoOptimiseStore = true;
    nixPath = [
      "/nix"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
  };

  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_5_2;
    kernelParams = [ "usb-storage.quirks=152d:0578:u,0dc4:0210:u" ];
    extraModprobeConfig = ''
      options usb-storage quirks=152d:0578:u,0dc4:0210:u
    '';
  };

  hardware = {
    enableAllFirmware = true;
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    ack
    bind
    borgbackup
    direnv
    exfat
    file
    gnupg
    gptfdisk
    gopass
    htop
    hdparm
    iotop
    jnettop
    gnumake
    ncftp
    nix-prefetch-scripts
    neovim
    nvme-cli
    (pass.withExtensions (e: [e.pass-otp]))
    patchelf
    pciutils
    pinentry
    powertop
    psmisc
    python
    rclone
    restic
    samba
    silver-searcher
    smartmontools
    speedtest-cli
    stow
    sysstat
    termite.terminfo
    tmux
    tree
    unzip
    upower
    wget
    # stable.haskellPackages.git-annex
  ] ++ (with gitAndTools; [
    git-annex
    git-annex-remote-b2
    git-annex-remote-rclone
    gitFull
  ]);

  virtualisation.docker.enable = true;

  time.timeZone = "Europe/Zurich";

  services.geoclue2.enable = true;

  services.btrfs = {
    autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
  };

  programs.zsh.enable = true;

  services.fwupd.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
        AddKeysToAgent yes
      '';
  };



  services.fstrim.enable = true;

  services.timesyncd.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
    ipv6 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      hinfo = true;
      workstation = true;
    };
  };

  users = {
    users = {
      silvio = {
        shell = pkgs.zsh;
        home = "/home/silvio";
        description = "Silvio Böhler";
        isNormalUser = true;
        extraGroups = ["wheel" "docker" "libvirtd" "audio" "video" "transmission" "networkmanager" "cdrom"];
        uid = 1000;
        openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFqXLmL2FVGAkSlndgqaEDx0teA6Ai1wLu21KSdcBnV6XldetAHZ8AAeodgEqIYD/sO69xCm9Kwa3DbktdMO28MO6A7poQ4jvDVHray7mpsm3z5xgc1HAadjNUBvlPjPBbCvZkhcI2/MSvVknl5uFXeH58AqaIq6Ump4gIC27Mj9vLMuw7S5MoR6vJgxKK/h52yuKXs8bisBvrHYngBgxA0wpg/v3G04iplPtTtyIY3uqkgPv3VfMSEyOuZ+TLujFg36FxU5I7Ok0Bjf8f+/OdE41MYYUH1VPIHFtxNs8MPCcz2Sv0baxEhAiEBpnWsQx8mBhxmQ/cK4Ih2EOLqPKR"];
      };
      root = {
        openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFqXLmL2FVGAkSlndgqaEDx0teA6Ai1wLu21KSdcBnV6XldetAHZ8AAeodgEqIYD/sO69xCm9Kwa3DbktdMO28MO6A7poQ4jvDVHray7mpsm3z5xgc1HAadjNUBvlPjPBbCvZkhcI2/MSvVknl5uFXeH58AqaIq6Ump4gIC27Mj9vLMuw7S5MoR6vJgxKK/h52yuKXs8bisBvrHYngBgxA0wpg/v3G04iplPtTtyIY3uqkgPv3VfMSEyOuZ+TLujFg36FxU5I7Ok0Bjf8f+/OdE41MYYUH1VPIHFtxNs8MPCcz2Sv0baxEhAiEBpnWsQx8mBhxmQ/cK4Ih2EOLqPKR silvio"];
      };
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  system.stateVersion = "19.09";
}
