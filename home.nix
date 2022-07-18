{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "riky";
  home.homeDirectory = "/home/riky";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    vscode
    bat
    exa
    du-dust
    fd
    procs
    curlie
    gdb
    wget
    curl
    dconf2nix
    gnome.gnome-tweaks
    gnome.gnome-shell-extensions
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.ddterm
    firefox-bin
    docker
    gh
    file
    (let 
      my-python-packages = python-packages: with python-packages; [
        poetry
        pudb
        ipython
      ];
      python-with-my-packages = python310.withPackages my-python-packages;
    in
    python-with-my-packages)
  ];

  programs.git = {
  	enable=true;
  	userName="rikyiso01";
  	userEmail="riky.isola@gmail.com";
  	signing={
  	  key="riky.isola@gmail.com";
  	  signByDefault=true;
  	};
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels\${NIX_PATH:+:$NIX_PATH}";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PYTHONBREAKPOINT = "pudb.set_trace";
    NIXOS_OZONE_WL = "1";
    #GPG_TTY="$(tty)"
  };

  programs.zsh = {
    enable=true;
    initExtra="source $HOME/.config/nixpkgs/theme.zsh";
    shellAliases={
      update="sudo git -C /etc/nixos pull && sudo nixos-rebuild switch && git -C ~/.config/nixpkgs pull && ~/.config/nixpkgs/update.sh && home-manager switch";
      cat="bat";
      ls="exa";
      du="dust";
      find="fd";
      ps="procs";
      curl="curlie";
      gdb="gdb -q";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo"];
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  gtk = {
    enable = true;
    theme = {
      name = "Layan-dark";
      package = pkgs.layan-gtk-theme;
    };
  };

  home.file.".face".source=./logo.png;

  imports = [ ./dconf.nix ];
}
