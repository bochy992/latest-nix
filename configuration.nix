# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "acpi_rev_override=2"
  ];

  environment.sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    # __VK_LAYER_NV_optimus = "NVIDIA_only";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GRUB_CMDLINE_LINUX_DEFAULT = "";
    GRUB_CMDLINE_LINUX = "";
    DRI_PRIME = "pci-0000_01_00_0";
    # GDK_BACKEND = "wayland";
    # SDL_VIDEODRIVER = "wayland";
    # CLUTTER_BACKEND = "wayland";
    # MOZ_ENABLE_WAYLAND = "1";
    # _JAVA_AWT_WM_NONREPARENTING = "1";
    # QT_QPA_PLATFORM = "wayland";
    # LIBVA_DRIVER_NAME = "nvidia";
    # GBM_BACKEND = "nvidia-drm";
    # __NV_PRIME_RENDER_OFFLOAD = "1";
    # PROTON_ENABLE_NGX_UPDATER = "1";
    # NVD_BACKEND = "direct";
    # __GL_GSYNC_ALLOWED = "1";
    # __GL_VRR_ALLOWED = "1";
    # WLR_DRM_NO_ATOMIC = "1";
    # WLR_USE_LIBINPUT = "1";
    # __GL_MaxFramesAllowed = "1";
    # WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  networking.hostName = "anvil"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Default packages to get rid of
  services.xserver.excludePackages = with pkgs; [ xterm ];

  # Emacs
  services.emacs.enable = true;
  services.emacs.package = pkgs.emacs29-pgtk;
  # Power
  services.thermald.enable = true;
  hardware.system76.power-daemon.enable = true;
  services.power-profiles-daemon.enable = false;


  
  services.xserver.videoDrivers = [
    "nvidia"
    "intel"
  ];

  # Enable Gnome
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
  programs.dconf.enable = true;
  services.sysprof.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (
        gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (
            old: {
              src = pkgs.fetchgit {
                url = "https://gitlab.gnome.org/vanvugt/mutter.git";
                # GNOME 45: triple-buffering-v4-45
                rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
                sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
              };
            }
          );
        }
      );
    })
  ];
  nixpkgs.config.allowAliases = false;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ilyas = {
    isNormalUser = true;
    description = "ilyas";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Doom Emacs dependencies
    fd
    (ripgrep.override { withPCRE2 = true; })
    clang
    coreutils
    # Programs required by Doctor Doom (emacs)
    gnumake
    cmake
    glslang
    sbcl
    haskell-language-server
    haskellPackages.hoogle
    haskellPackages.cabal-install
    jdk21
    opam
    rust-analyzer
    rustc
    cargo
    imagemagick
    isync
    offlineimap
    pipenv
    shellcheck
    pandoc
    ocamlPackages.utop
    ocamlPackages.ocp-indent
    ocamlPackages.merlin
    ruby_3_3
    direnv
    clj-kondo
    dune_3
    fsharp
    html-tidy
    stylelint
    jsbeautifier
    (python311.withPackages (
      ps: with ps; [
        pip
        regex
        setuptools
        nose
        pytest
        isort
        editorconfig
        psutil
      ]
    ))
    # --------------
    # Qemu Virtual Machine
    qemu_kvm
    virt-manager
    virt-viewer
    dnsmasq
    vde2
    bridge-utils
    netcat-openbsd
    # ---------------
    sysprof
    firefox
    ventoy-full
    spotify
    neofetch
    gh
    wgnord
    feh
    wezterm
    pwvucontrol
    helvum
    newsraft
    sfeed
    zs
    moc
    mpd
    mus
    vorbis-tools
    psmisc
    lf
    mc
    ranger
    rover
    sfm
    stagit
    feh
    imv
    mu
    alacritty
    meh
    xorg.xwininfo
    xdotool
    xclip
    qiv
    nsxiv
    xwallpaper
    mplayer
    mpv
    herbe
    tiramisu
    oath-toolkit
    pass
    mupdf
    dash
    mksh
    oksh
    yash
    neovim
    kakoune
    csvquote
    json2tsv
    md4c
    abduco
    deadbeef-with-plugins
    dvtm
    entr
    mtm
    pv
    nq
    pciutils
    alacritty
    wlr-randr
    smenu
    snore
    zbar
    edbrowse
    openshot-qt
    libsForQt5.kdenlive
    elinks
    links2
    surf
    tridactyl-native
    w3m
    w3m-nox
    emacsPackages.w3m
    # -------
    terminator
    tilix
    wezterm
    curl
    libsForQt5.dolphin
    gnome-extension-manager
    nerdfonts
    eza
    btop
    gnome.gnome-tweaks
    mullvad-browser
    zip
    topgrade
    evince
    helix
    zotero
    easyeffects
    dsvpn
    thunderbird
    racket
    nurl
    keepassxc
    mako
    wl-clipboard
    shotman
    distrobox
    man-pages
    unzip
    wget
    lazygit
    zoxide
    oh-my-posh
    typescript
    gnutls
    powershell
    lm_sensors
    mpv
    libgen-cli
    jellyfin-media-player
    glaxnimate
    yt-dlp
    qbittorrent
    htop
    nvtop
    ffmpeg-full
    nnn
    lshw
    xsct
    spacevim
    maiko # Medley Interlisp virtual machine
    profile-cleaner
    tldr
    shortwave
    audacity
    simh
    opera
    tmux
    nixfmt-rfc-style
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnome.adwaita-icon-theme
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable sound with pipewire
  sound.enable = false;
  hardware.pulseaudio.enable = lib.mkForce false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  virtualisation.podman.enable = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
