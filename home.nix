{ config, pkgs, ... }:

rec {

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "riky";
  home.homeDirectory = "/home/riky";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    du-dust
    fd
    procs
    curlie
    gdb
    wget
    curl
    dconf2nix
    gnome.gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.ddterm
    gnomeExtensions.gsconnect
    file
    roboto
    fira-code
    noto-fonts
    bibata-cursors
    materia-theme
    docker-compose
    nodejs
    steam-run
    gcc
    chromedriver
    ffmpeg
    libsecret
    cargo
    rustc
    rust-analyzer
    rustfmt
    pkg-config
    xorg.libX11
    xorg.libXi
    mesa
    alsa-lib
    pkgconfig
    cairo
    gtk4
    gobject-introspection
    lsof
    micro
    powertop
    (let 
      my-python-packages = python-packages: with python-packages; [
        poetry
        pudb
        ipython
        ipykernel
        pandas
        scipy
        numpy
        plotly
        dash
        matplotlib
        notebook
        black
        pyyaml
      ];
      python-with-my-packages = python310.withPackages my-python-packages;
    in
    python-with-my-packages)

    yarn
  ];

  programs.git = {
  	enable=true;
  	userName="rikyiso01";
  	userEmail="riky.isola@gmail.com";
  	signing={
  	  key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRI8KdIpS8+g0IwxfzmrCBP4m7XWj0KECBz42WkgwsG";
  	  signByDefault=true;
  	};
    extraConfig={
      init.defaultBranch="main";
      gpg.format="ssh";
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels\${NIX_PATH:+:$NIX_PATH}";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PYTHONBREAKPOINT = "pudb.set_trace";
    NIXOS_OZONE_WL = "1";
    CHROME_EXECUTABLE="chromium";
    MANPATH="$HOME/.npm-packages/share/man";
  };

  home.sessionPath = ["$HOME/.local/bin" "$HOME/.local/flutter/bin" "$HOME/.npm-packages/bin"];

  fonts.fontconfig.enable = true;
  programs.bat.enable=true;
  programs.exa.enable=true;
  programs.gh.enable=true;

  programs.zsh = {
    enable=true;
    initExtra="source $HOME/.config/nixpkgs/theme.zsh";
    shellAliases={
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

  qt={
    enable=true;
    platformTheme="gnome";
    style={
      name="adwaita-dark";
      package=pkgs.adwaita-qt;
    };
  };

  home.file.".face".source=./logo.png;
  home.file.".local/bin/update".source=./update.sh;

  home.file.".local/bin/chromium"={
    text="#!/usr/bin/env bash\nexec com.brave.Browser $@";
    executable=true;
  };
  home.file.".local/flatpak/downloadhelper"={
    text="#!/usr/bin/env bash\nexec flatpak-spawn --host steam-run $HOME/.local/downloadhelper/bin/net.downloadhelper.coapp-linux-64 $@";
    executable=true;
  };

  home.file.".local/flatpak/chromium".source=./normal-spawn.sh;
  home.file.".local/flatpak/git".source=./normal-spawn.sh;
  home.file.".local/flatpak/python".source=./normal-spawn.sh;
  home.file.".local/flatpak/cargo".source=./normal-spawn.sh;
  home.file.".local/flatpak/rustc".source=./normal-spawn.sh;
  home.file.".local/flatpak/rust-analyzer".source=./normal-spawn.sh;
  home.file.".local/flatpak/rustfmt".source=./normal-spawn.sh;
  home.file.".local/flatpak/zsh".source=./host-spawn;
  home.file.".local/flatpak/code"={
    text="#!/usr/bin/env bash\ntouch /etc/shells\nexec /app/bin/code $@";
    executable=true;
  };
  home.file.".local/share/applications/micro.desktop"={
    text="";
  };

  #imports = [ ./dconf.nix ];

  services.home-manager.autoUpgrade={
    enable=true;
    frequency="weekly";
  };
}
