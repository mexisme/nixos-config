{ pkgs, config, ... }:
{
  nixpkgs.config = {

    packageOverrides = pkgs: rec {
      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-10_x; };

      rofi-launcher = pkgs.callPackage ./rofi {};

      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          ghc865 = pkgs.haskell.packages.ghc865.override {
            overrides = self: super: {
              beans = self.callPackage ./beans.nix {};
              # dhall = self.callPackage ./dhall.nix {};
              # dhall-json = self.callPackage ./dhall-json.nix {};
            };
          };
        };
      };
      haskellPackages = haskell.packages.ghc865;

      html2text = pkgs.html2text.overrideAttrs (oldAttrs: rec {
        patches = [
          ./html2text/100-fix-makefile.patch
          ./html2text/200-close-files-inside-main-loop.patch
          ./html2text/400-remove-builtin-http-support.patch
          ./html2text/500-utf8-support.patch
          ./html2text/510-disable-backspaces.patch
          ./html2text/550-skip-numbers-in-html-tag-attributes.patch
          ./html2text/600-multiple-meta-tags.patch
          ./html2text/611-recognize-input-encoding.patch
          ./html2text/630-recode-output-to-locale-charset.patch
          ./html2text/800-replace-zeroes-with-null.patch
          ./html2text/810-fix-deprecated-conversion-warnings.patch
          ./html2text/900-complete-utf8-entities-table.patch
          ./html2text/950-validate-width-parameter.patch
          ./html2text/960-fix-utf8-mode-quadratic-runtime.patch
        ];
      });
    };
  };

  services.geoclue2.enable = true;
  services.localtime.enable = true;
  services.redshift.enable = true;
  services.redshift.provider = "geoclue2";

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hie-nix.cachix.org"
      "https://nixcache.reflex-frp.org"
    ];
    binaryCachePublicKeys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    ];
    trustedUsers = [ "root" "silvio" ];
  };

  # nix.useSandbox = true;

  nixpkgs.config.firefox = {
    enableAdobeFlash = true;
    jre = true;
  };

  documentation.dev.enable = true;

  programs.browserpass.enable = true;
  hardware.brightnessctl.enable = true;

  programs.ssh.startAgent = true;
  programs.gnupg.agent.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-qt
    alacritty
    ansible
    arandr
    beancount
    brightnessctl
    chromium
    compton
    darktable
    digikam
    dhall
    dhall-json
    direnv
    docker_compose
    dunst
    emacs
    evince
    firefox
    fdupes
    git-review
    gradle
    gthumb
    # gnome-podcasts
    gnome3.polari
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
    gnome3.nautilus
    gnome3.geary
    gnome3.gnome-screenshot
    # gnome3.gnome-terminal
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gnumake
    hplip
    html2text
    icedtea8_web
    imagemagick7
    ispell
    isync
    jetbrains.idea-ultimate
    libreoffice
    libressl
    libxml2
    macchanger
    manpages
    meld
    mu
    nix-index
    nodejs-10_x
    nodePackages.node2nix
    pavucontrol
    pandoc
    pinentry
    playerctl
    python3
    # qt5.full
    # libsForQt5.qtstyleplugins
    # libsForQt5.libkipi
    racket
    rofi
    rofi-launcher
    rubber
    sbcl
    shared_mime_info
    spotify
    stack
    (texlive.combine {
      inherit (texlive) scheme-medium moderncv cmbright wrapfig capt-of;
    })
    thunderbird
    exiftool
    tabula
    # tor-browser-bundle-bin
    udiskie
    vanilla-dmz
    vlc
    xiccd
    w3m
    yarn
    xss-lock
    zip
  ]
    ++ (with pkgs.haskellPackages; [
      beans
      cabal-install
      apply-refact
      cabal2nix
      # hasktags
      hindent
      # hlint
      hpack
      # stylish-haskell
    ]);

  hardware.pulseaudio.enable = true;

  services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set 5%- -n 1";
        }
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        }
      ];
    };


  services.udisks2.enable = true;
  services.gnome3.gvfs.enable = true;
  services.gnome3.gnome-disks.enable = true;

  powerManagement.enable = true;

  services.xserver = {
    enable = true;
    # desktopManager.gnome3.enable = true;
    desktopManager.xterm.enable = false;

    layout = "us(altgr-intl)";
    xkbModel = "pc104";
    xkbOptions = "ctrl:swapcaps,compose:ralt,terminate:ctrl_alt_bksp";
    libinput = {
      enable = true;
      naturalScrolling = true;
    };
    displayManager = {
      # gdm.enable = true;
      sessionCommands = ''
        xset s 600 0
        xset r rate 440 50
        systemctl --user import-environment DISPLAY SSH_AUTH_SOCK
      '';
    };
    windowManager.i3 = {
      extraSessionCommands = ''
        systemctl --user restart emacs.service &
      '';
      enable = true;
      package = pkgs.i3;
      extraPackages = with pkgs; [
        dmenu
        rofi
        networkmanagerapplet
        blueman
        i3status
        i3status-rust
        i3lock ];
    };
  };

  hardware.bluetooth.enable = true;

  services.emacs = {
    install = true;
    enable = true;
    defaultEditor = true;
  };

  services.tor = {
    enable = true;
    client = {
      enable = true;
    };
  };

  networking.extraHosts = ''
    127.0.0.1	portal.truewealth.test
    127.0.0.1	truewealth.test
    127.0.0.1 s3mock
  '';

  fonts = {
    # fontconfig.ultimate.enable = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
      emojione
      dejavu_fonts
      source-code-pro
      google-fonts
      font-awesome
      liberation_ttf
      # nerdfonts
      carlito
      inconsolata
    ];
  };

  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
  };

  services.colord = {
    enable = true;
  };
}
