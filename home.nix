{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.username = "ilyas";
  home.homeDirectory = "/home/ilyas";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # # encode the file content in nix configuration file directly
  # home.file."path-to-file-under-home-directory".text = ''
  # '';

  # Gnome HiDpi/Fractional Scaling
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };

  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.package = pkgs.vanilla-dmz;
  home.pointerCursor.name = "Vanilla-DMZ";

  # programs.helix = {
  #   enable = true;
  #   settings = {
  #     theme = "rose-pine";
  #     editor = {
  #       line-number = "relative";
  #       lsp.display-messages = true;
  #     };
  #   };
  # };

  # shell
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(oh-my-posh init bash --config ~/robbyrussell.omp.json)"
      export PATH=$PATH:~/.emacs.d/bin/
    '';
    shellAliases = {
      ip = "ip --color=auto";
      clean = "sudo nix-collect-garbage";
      deepclean = "sudo nix-collect-garbage -d";
      fig = "cd /etc/nixos";
      switch = "cd /etc/nixos; sudo nixos-rebuild switch --flake .#anvil";
      boot = "cd /etc/nixos/; sudo nixos-rebuild boot --flake .#anvil";
      ls = "eza -a";
      confnix = "sudo hx /etc/nixos/configuration.nix";
      flakenix = "sudo hx /etc/nixos/flake.nix";
      homenix = "sudo hx /etc/nixos/home.nix";
      getfullsite = "wget -m -p -E -k -np";
      system76-integrated = "sudo system76-power graphics integrated";
      system76-nvidia = "sudo system76-power graphics nvidia";
      system76-hybrid = "sudo system76-power graphics hybrid";
      system76-compute = "sudo system76-power graphics compute";
      graphics = "sudo system76-power graphics";
    };
  };
  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "bochy992";
    userEmail = "garare992@proton.me";
  };

  # # Scripts
  # home.file.".config/zsh/scripts".source = ./files/scripts;
  # home.file.".config/zsh/scripts".recursive = true;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
