{ config, pkgs, lib, ... }:

rec {

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "riky";
  home.homeDirectory = "/home/riky";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    unixtools.xxd
    unixtools.top
    unixtools.arp
    unixtools.wall
    unixtools.ping
    unixtools.watch
    unixtools.util-linux
    which
    iproute2
    coreutils
    openssh
    systemdMinimal
    util-linux
    pkg-config
    # Flatpak dbus
    gnome-text-editor
    gnome.gnome-characters
    gnome.gnome-logs
    gnome.gnome-boxes
    gnome.dconf-editor
    #
    gnome.gnome-system-monitor
    gnome.gnome-disk-utility
    du-dust
    fd
    procs
    curlie
    gdb
    wget
    curl
    gnome.gnome-tweaks
    gnomeExtensions.espresso
    gnomeExtensions.dash-to-dock
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.ddterm
    gnomeExtensions.focus-changer
    file
    fira-code
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
    wireguard-tools
    haskell-language-server
    binwalk
    exiftool
    imagemagick
    jre
    unzip
    zip
    elmPackages.elm
    elmPackages.elm-format
    inotify-tools
    nixpkgs-fmt
    ngrok
    brightnessctl
    netcat
    flatpak
    tlp
    traceroute
    poetry
    pypy38
    gnumake
    (pkgs.callPackage ./downloadhelper.nix { })
    (pkgs.callPackage ./tlauncher.nix { })
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
          nbformat
          scikitimage
          numba
          opencv4
          notebook
          networkx
          kaggle
          opensimplex
        ];
        python-with-my-packages = python310.withPackages my-python-packages;
      in
      python-with-my-packages
    )
    (haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle ]))
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
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PYTHONBREAKPOINT = "pudb.set_trace";
    CHROME_EXECUTABLE = "chromium";
    MANPATH = "/usr/share/man:$HOME/.npm-packages/share/man";
    NIXPKGS_ALLOW_UNFREE = "1";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    VISUAL = "micro";
    EDITOR = "micro";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
  };

  fonts.fontconfig.enable = true;
  programs.matplotlib.enable = true;
  programs.bat.enable = true;
  programs.gnome-terminal = {
    enable = true;
    profile = {
      default = {
        default = true;
        visibleName = "Default";
      };
    };
  };
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
  programs.man = {
    enable = true;
    generateCaches = true;
  };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ coc-pyright auto-save-nvim nerdtree ];
    coc = {
      enable = true;
      settings = {
        "coc.preferences.formatOnType" = true;
        "coc.preferences.formatOnSaveFiletypes" = [ "python" ];
        "python.formatting.provider" = "black";
        "python.analysis.typeCheckingMode" = "strict";
      };
    };
    extraConfig = ''
      set number
    '';
  };

  programs.obs-studio.enable = true;
  programs.pandoc.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = "AddKeysToAgent yes";
  };
  programs.tmux.enable = true;

  programs.texlive = {
    enable = true;
    packageSet = pkgs.texlive; #.combined.scheme-full;
  };

  programs.bash = {
    enable = true;
    initExtra = "exec zsh";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''source $HOME/.config/nixpkgs/theme.zsh
    PATH=$HOME/.local/bin:$PATH'';
    shellAliases = {
      cat = "bat";
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
  home.enableNixpkgsReleaseCheck = true;

  #home.keyboard.layout = "it";
  #home.language.base = "en";
  news.display = "show";
  nix.settings = {
    auto-optimise-store = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Amber";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 0;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 0;
    };
  };
  xdg = {
    enable = true;
    userDirs = {
      createDirectories = true;
      enable = true;
    };
    mimeApps = {
      enable = true;
      associations = {
        added = {
          "text/plain" = [ "org.gnome.TextEditor.desktop" ];
          "application/pdf" = [ "org.gnome.Evince.desktop" ];
          "application/x-desktop" = [ "org.gnome.TextEditor.desktop" ];
          "text/x-csharp" = [ "org.gnome.TextEditor.desktop" ];
          "application/x-php" = [ "org.gnome.TextEditor.desktop" ];
          "text/html" = [ "org.gnome.TextEditor.desktop" "com.brave.Browser.desktop" ];
          "application/x-ipynb+json" = [ "com.visualstudio.code.desktop" ];
          "text/x-python" = [ "org.gnome.TextEditor.desktop" ];
          "application/octet-stream" = [ "org.gnome.TextEditor.desktop" ];
          "application/vnd.ms-publisher" = [ "org.gnome.TextEditor.desktop" ];
          "application/x-wine-extension-ini" = [ "org.gnome.TextEditor.desktop" ];
          "application/x-shellscript" = [ "org.gnome.TextEditor.desktop" ];
        };
      };
      defaultApplications = {
        "application/x-wine-extension-ini" = [ "org.gnome.TextEditor.desktop" ];
        "image/jpeg" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/png" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/jpg" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/pjpeg" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-3fr" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-adobe-dng" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-arw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-bay" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-bmp" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-canon-cr2" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-canon-crw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-cap" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-cr2" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-crw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-dcr" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-dcraw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-dcs" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-dng" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-drf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-eip" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-erf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-fff" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-fuji-raf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-iiq" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-k25" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-kdc" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-mef" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-minolta-mrw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-mos" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-mrw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-nef" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-nikon-nef" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-nrw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-olympus-orf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-orf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-panasonic-raw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-pef" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-pentax-pef" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-png" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-ptx" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-pxn" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-r3d" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-raf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-raw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-rw2" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-rwl" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-rwz" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-sigma-x3f" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-sony-arw" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-sony-sr2" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-sony-srf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-sr2" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-srf" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "image/x-x3f" = [ "org.gnome.Shotwell.Viewer.desktop" ];
        "application/xml" = [ "org.gnome.TextEditor.desktop" ];
        "text/markdown" = [ "org.gnome.TextEditor.desktop" ];
        "application/x-shellscript" = [ "org.gnome.TextEditor.desktop" ];
        "text/plain" = [ "org.gnome.TextEditor.desktop" ];
      };
    };
  };

  systemd.user.services = {
    docker = {
      Unit = {
        Description = "Docker";
      };
      Service = {
        ExecStart = "/usr/bin/sudo ${home.homeDirectory}/.nix-profile/bin/dockerd -H 'unix:///var/run/docker.sock'";
      };
    };
    tlp = {
      Unit = {
        Description = "TLP";
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "/usr/bin/sudo ${home.homeDirectory}/.nix-profile/bin/tlp init start";
        ExecStop = "/usr/bin/sudo ${home.homeDirectory}/.nix-profile/bin/tlp init stop";
      };
    };
    ssh = {
      Unit = {
        Description = "SSH";
      };
      Service = {
        Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
        ExecStart = "${home.homeDirectory}/.nix-profile/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      };
    };
  };

  home.file.".config/tlp.conf".text = ''
    USB_EXCLUDE_BTUSB=1
    CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
    CPU_ENERGY_PERF_POLICY_ON_BAT=power
    PCIE_ASPM_ON_AC=default
    PCIE_ASPM_ON_BAT=powersupersave
  '';
  home.file.".config/avahi-daemon.conf".text = ''
    [server]
    use-ipv4=yes
    use-ipv6=yes
    enable-dbus=no
    ratelimit-interval-usec=1000000
    ratelimit-burst=1000
    [wide-area]
    enable-wide-area=yes
    [publish]
    publish-hinfo=no
    publish-workstation=no
  '';
  home.file.".config/pypoetry/config.toml".text = ''
    [virtualenvs]
    in-project = true
  '';
  home.file.".local/bin/update".source = ./update.sh;
  home.file.".local/bin/backup".source = ./backup.sh;
  home.file.".local/bin/startup".source = ./startup.sh;
  home.file.".config/autostart/startup.desktop".text = ''
    [Desktop Entry]
    Exec=startup
    Name=startup
    Comment=Startup
    Type=Application
    Icon=nautilus'';
  home.file.".local/bin/conservative".source = ./conservative.sh;

  home.file.".local/bin/chromium" = {
    text = "#!/usr/bin/env bash\nexec com.brave.Browser \"$@\"";
    executable = true;
  };
  home.file.".local/bin/nix-shell" = {
    text = "#!/usr/bin/env bash\nexec /usr/bin/nix-shell \"$@\" --run zsh";
    executable = true;
  };
  home.file.".local/bin/global_black" = {
    text = "#!/usr/bin/env bash\nexec black \"$@\"";
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

  home.file.".local/flatpak/git".source = ./normal-spawn.sh;
  home.file.".local/flatpak/nix-instantiate".source = ./normal-spawn.sh;
  home.file.".local/flatpak/nixpkgs-fmt".source = ./normal-spawn.sh;
  home.file.".local/flatpak/chromium".source = ./normal-spawn.sh;
  home.file.".local/flatpak/code" = {
    text = "#!/usr/bin/env bash\ntouch /etc/shells\nexec /app/bin/code --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto \"$@\"";
    executable = true;
  };
  home.file.".local/flatpak/insomnia" = {
    text = "#!/usr/bin/env bash\nexec /app/bin/insomnia --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto \"$@\"";
    executable = true;
  };
  home.file.".local/flatpak/brave" = {
    text = "#!/usr/bin/env bash\nexec /app/bin/brave --ozone-platform-hint=auto --enable-webrtc-pipewire-capturer=enabled --use-vulkan --enable-features=VaapiVideoEncoder,CanvasOopRasterization --enable-zero-copy --ignore-gpu-blocklist --enable-raw-draw=enabled \"$@\"";
    executable = true;
  };
  home.file.".local/flatpak/zsh".source = ./host-spawn;
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
  home.file.".local/share/applications/jupyter-notebook.desktop".text = "";
  home.file.".local/share/applications/jupyter-nbclassic.desktop".text = "";
  home.file.".local/share/applications/org.gnome.Extensions.desktop".text = "";
  home.file.".local/share/applications/nvim.desktop".text = "";
  home.file.".local/share/applications/cups.desktop".text = "";

  home.file.".local/share/flatpak/overrides/com.brave.Browser".text = ''
    [Context]
    filesystems=home;/nix/store:ro;
    [Environment]
    PATH=${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin
  '';
  home.file.".local/share/flatpak/overrides/net.ankiweb.Anki".text = ''
    [Environment]
    ANKI_WAYLAND=1
  '';
  home.file.".local/share/flatpak/overrides/org.raspberrypi.rpi-imager".text = ''
    [Context]
    sockets=wayland;
  '';
  home.file.".local/share/flatpak/overrides/rest.insomnia.Insomnia".text = ''
    [Context]
    filesystems=${home.homeDirectory}/.local/flatpak:ro;/nix/store:ro;
    [Environment]
    PATH=${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin
  '';
  home.file.".local/share/flatpak/overrides/com.visualstudio.code".text = ''
    [Context]
    sockets=wayland;
    [Environment]
    PATH=${home.homeDirectory}/.local/flatpak:${home.homeDirectory}/.local/bin:${home.homeDirectory}/.nix-profile/bin:/app/bin:/usr/bin:${home.homeDirectory}/.var/app/com.visualstudio.code/data/node_modules/bin
  '';
  home.file.".local/share/flatpak/overrides/org.audacityteam.Audacity".text = ''
    [Context]
    sockets=wayland;
  '';
  home.file.".local/share/flatpak/overrides/org.wireshark.Wireshark".text = ''
    [Context]
    filesystems=home;
  '';

  nix.package = pkgs.nix;
  nix.settings = { experimental-features = [ "nix-command" ]; };

  home.activation = {
    setup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      "$HOME/.nix-profile/bin/mkdir" -p "$HOME/Games/Minecraft/tlauncher"
      "$HOME/.nix-profile/bin/ln" -sfT "$HOME/Games/Minecraft/tlauncher" "$HOME/.tlauncher"
      "$HOME/.nix-profile/bin/ln" -sfT "$HOME/.nix-profile/share/gnome-shell/extensions" "$HOME/.local/share/gnome-shell/extensions"
      "$HOME/.nix-profile/bin/ln" -sfT "$HOME/.nix-profile/share/dbus-1" "$HOME/.local/share/dbus-1"
      "$HOME/.nix-profile/bin/systemctl" --user mask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
      '/usr/bin/tracker3' reset -s -r > '/dev/null'
    '';
  };
}
