{ config, pkgs, ... }:

rec {

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "riky";
  home.homeDirectory = "/home/riky";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    gnome.gnome-system-monitor
    gnome.gnome-disk-utility
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
    file
    fira-code
    bibata-cursors
    materia-theme
    docker
    docker-compose
    chromedriver
    ffmpeg
    rustup
    rust-analyzer
    powertop
    micro
    nodePackages.pnpm
    nodejs-slim
    shellcheck
    android-tools
    nmap
    gef
    mysql80
    (php81.buildEnv
      {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug
        ]));
        extraConfig = ''
          xdebug.mode = debug
          xdebug.start_with_request = yes
        '';
      })
    php81Packages.composer
    wireguard-tools
    haskell-language-server
    binwalk
    exiftool
    imagemagick
    jdk
    unzip
    zip
    elmPackages.elm
    elmPackages.elm-format
    inotify-tools
    gradle
    nodePackages.typescript
    nixpkgs-fmt
    ngrok
    brightnessctl
    netcat
    flatpak
    nano
    vim
    tlp
    traceroute
    poetry
    pypy38
    julia-bin
    texlive.combined.scheme-full
    pandoc
    gnumake
    (pkgs.callPackage ./downloadhelper.nix { })
    (pkgs.callPackage ./tlauncher.nix { })
    (pkgs.callPackage ./marp.nix { })
    (
      let
        my-python-packages = python-packages: with python-packages; [
          pudb
          ipython
          ipykernel
          pandas
          scipy
          numpy
          plotly
          black
          pyyaml
          scikit-learn
          httpx
          pwntools
          beautifulsoup4
          pycryptodome
          pytest
          pillow
          matplotlib
          nbformat
          scikitimage
          numba
          opencv4
          notebook
        ];
        python-with-my-packages = python310.withPackages my-python-packages;
      in
      python-with-my-packages
    )
    (haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle ]))
    dotnet-sdk
  ];

  programs.git = {
    enable = true;
    userName = "rikyiso01";
    userEmail = "riky.isola@gmail.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRI8KdIpS8+g0IwxfzmrCBP4m7XWj0KECBz42WkgwsG";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PYTHONBREAKPOINT = "pudb.set_trace";
    NIXOS_OZONE_WL = "1";
    CHROME_EXECUTABLE = "chromium";
    MANPATH = "/usr/share/man:$HOME/.npm-packages/share/man";
    NIXPKGS_ALLOW_UNFREE = "1";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    VISUAL = "micro";
    EDITOR = "micro";
  };

  fonts.fontconfig.enable = true;
  programs.bat.enable = true;
  programs.exa.enable = true;
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };


  programs.bash = {
    enable = true;
    initExtra = "exec zsh";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''source $HOME/.config/nixpkgs/theme.zsh
    if [ -f $HOME/.ssh/environment ]; then source $HOME/.ssh/environment;fi
    PATH=$HOME/.local/bin:$HOME/.local/flutter/bin:$HOME/.cargo/bin:$PATH'';
    shellAliases = {
      cat = "bat";
      ls = "exa";
      du = "dust";
      find = "fd";
      ps = "procs";
      curl = "curlie";
      gdb = "gef";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };
  };

  programs.nix-index.enable = true;

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = false;
    useTheme = "powerlevel10k_lean";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  #  home.file.".face".source = ./logo.png;

  home.file.".local/bin/update".source = ./update.sh;
  home.file.".local/bin/backup".source = ./backup.sh;
  home.file.".local/bin/startup".source = ./startup.sh;
  home.file.".local/bin/start-docker".source = ./start-docker.sh;
  home.file.".config/autostart/startup.desktop".text = ''
    [Desktop Entry]
    Exec=startup
    Name=startup
    Comment=Startup
    Type=Application
    Icon=nautilus'';
  home.file.".local/bin/conservative".source = ./conservative.sh;
  home.file.".local/bin/cast-audio".source = ./cast-audio.sh;

  home.file.".local/bin/chromium" = {
    text = "#!/usr/bin/env bash\nexec com.brave.Browser $@";
    executable = true;
  };
  home.file.".local/bin/nix-shell" = {
    text = "#!/usr/bin/env bash\nexec /usr/bin/nix-shell $@ --run zsh";
    executable = true;
  };
  home.file.".local/bin/global_black" = {
    text = "#!/usr/bin/env bash\nexec black $@";
    executable = true;
  };
  home.file.".local/bin/jupyter-server" = {
    text = "#!/usr/bin/env bash\ndocker build -f ${home.homeDirectory}/.config/nixpkgs/jupyter -t jupyter:latest ${home.homeDirectory}/.config/nixpkgs\nexec nohup docker run --env DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -p 127.0.0.1:8888:8888 jupyter:latest > /dev/null 2> /dev/null &";
    executable = true;
  };
  home.file.".var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/NativeMessagingHosts/net.downloadhelper.coapp.json".text = ''
    {
      "name": "net.downloadhelper.coapp",
      "description": "Video DownloadHelper companion app",
      "path": "${home.homeDirectory}/.nix-profile/bin/net.downloadhelper.coapp-linux-64",
      "type": "stdio",
      "allowed_origins": [
          "chrome-extension://lmjnegcaeklhafolokijcfjliaokphfk/"
      ]
    }
  '';

  home.file.".local/flatpak/git" = {
    text = "#!/usr/bin/env bash\nsource $HOME/.ssh/environment;exec flatpak-spawn --env=SSH_AUTH_SOCK=$SSH_AUTH_SOCK --env=SSH_AGENT_PID=$SSH_AGENT_PID --host git $@";
    executable = true;
  };
  home.file.".local/flatpak/nix-instantiate".source = ./normal-spawn.sh;
  home.file.".local/flatpak/nixpkgs-fmt".source = ./normal-spawn.sh;
  home.file.".local/flatpak/chromium".source = ./normal-spawn.sh;
  home.file.".local/flatpak/code" = {
    text = "#!/usr/bin/env bash\ntouch /etc/shells\nexec /app/bin/code $@";
    executable = true;
  };
  home.file.".local/flatpak/brave" = {
    text = "#!/usr/bin/env bash\nexec /app/bin/brave --ozone-platform-hint=auto --enable-webrtc-pipewire-capturer=enabled --use-vulkan --enable-features=VaapiVideoEncoder,CanvasOopRasterization --enable-zero-copy --ignore-gpu-blocklist --enable-raw-draw=enabled $@";
    executable = true;
  };
  home.file.".local/flatpak/zsh".source = ./host-spawn;
  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };
  home.file.".local/share/applications/micro.desktop".text = "";
  home.file.".local/share/applications/qv4l2.desktop".text = "";
  home.file.".local/share/applications/qvidcap.desktop".text = "";
  home.file.".local/share/applications/bssh.desktop".text = "";
  home.file.".local/share/applications/avahi-discover.desktop".text = "";
  home.file.".local/share/applications/bvnc.desktop".text = "";
  home.file.".local/share/applications/assistant.desktop".text = "";
  home.file.".local/share/applications/designer.desktop".text = "";
  home.file.".local/share/applications/linguist.desktop".text = "";
  home.file.".local/share/applications/qdbusviewer.desktop".text = "";
  home.file.".local/share/applications/lstopo.desktop".text = "";
  home.file.".local/share/applications/julia.desktop".text = "";
  home.file.".local/share/applications/jupyter-notebook.desktop".text = "";
  home.file.".local/share/applications/jupyter-nbclassic.desktop".text = "";
  home.file.".local/share/applications/org.gnome.Extensions.desktop".text = "";

  nix.package = pkgs.nix;
  nix.settings = { experimental-features = [ "nix-command" ]; };
}
