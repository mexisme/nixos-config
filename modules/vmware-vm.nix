{ config, pkgs, ... }:
let
  sources = import ../nix/sources.nix;
in
{
  imports =
    [
      <home-manager/nixos>
      ./base.nix
      ./home/base.nix
      ./home/xorg.nix
    ];

  config = {
    nixpkgs = {
      config = {
        packageOverrides = pkgs: rec {
        };
      };
    };

    fonts = {
      fonts = with pkgs; [
        source-code-pro
      ];
    };

    environment.systemPackages = with pkgs; [
      cabal2nix
      firefox
      niv
      racket
      tcpdump
      open-vm-tools
    ];

    services = {
      dbus.packages = [
        pkgs.gnome3.dconf
      ];

      samba = {
        enable = true;
        extraConfig = ''
        follow symlinks = yes
         '';
        # extraConfig = ''
        # workgroup = WORKGROUP
        # server string = "SURFACE-NIXOS"
        # netbios name = "SURFACE-NIXOS"
        #   guest account = nobody
        #   map to guest = bad user
        #   follow symlinks = yes
        # '';
        shares = {
          silvio = {
            comment = "Silvio's home";
            path = "/home/silvio";
            "valid users" = ["silvio"];
            public = "no";
            writable = "yes";
            browseable = "yes";
            printable = "no";
          };
        };
      };

      xserver = {
        enable = true;
	desktopManager.xterm.enable = true;
      };
    };

    networking = {
      enableIPv6 = true;
      firewall = {
        enable = false;
        allowedTCPPorts = [
          22  # ssh
          137 # netbios
          139 # netbios
          445 # smb
          3389 # Microsoft RDP
        ];
        allowedUDPPorts = [
          137 # netbios
          139 # netbios
        ];
      };
      useDHCP = false;
      interfaces = {
        ens33 = {
	  useDHCP = true;
        };
      };
    };

    users.users.silvio.openssh.authorizedKeys.keyFiles = [ ./id_rsa.pub.vm ];

    boot = {
      loader = {
        grub = {
	  enable = true;
	  version = 2;
	  device = "/dev/sda";
	};
      };
      initrd = {
        availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
      };
      kernelModules = [ ];
      extraModulePackages = [ ];
    };

    virtualisation = {
      vmware = {
        guest = {
          enable = true;
	};
      };
    };

    programs = {
      fuse = {
        userAllowOther = true;
      };
    };

    fileSystems."/home/silvio/winhome" = {
      device = ".host:/silvio";
      fsType = "fuse.vmhgfs-fuse";
      options = ["nofail,allow_other"];
    };

    #fileSystems."/home/silvio/winhome" = {
    #  device = "//172.21.21.1/silvio";
    #  fsType = "cifs";
    #  options = [
    #    "uid=1000"
    #    "gid=100"
    #    "credentials=/home/silvio/secrets/samba"
    #    "noauto"
    #    "x-systemd.idle-timeout=60"
    #    "x-systemd.device-timeout=5s"
    #    "x-systemd.mount-timeout=5s"
    #    "x-systemd.automount"
    #  ];
    #};
  };
}
