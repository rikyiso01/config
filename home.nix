{ config, pkgs, lib, ... }:

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
    gnomeExtensions.espresso
    gnomeExtensions.dash-to-dock
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.ddterm
    gnomeExtensions.focus-changer
    fira-code
    materia-theme
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
    elmPackages.elm
    elmPackages.elm-format
    inotify-tools
    nixpkgs-fmt
    ngrok
    brightnessctl
    tlp
    thermald
    traceroute
    poetry
    pypy38
    gnumake
    tesseract
    php82Packages.composer
    #texlive.combined.scheme-full
    (pkgs.callPackage ./downloadhelper.nix { })
    (pkgs.callPackage ./tlauncher.nix { })
    #mysql80
    php82
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
          jupytext
          playwright
          aiofile
          fonttools
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

  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.nix-profile/bin" "$HOME/.local/share/flatpak/exports/bin" ];

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PYTHONBREAKPOINT = "pudb.set_trace";
    #MANPATH = "/usr/share/man:$HOME/.npm-packages/share/man";
    NIXPKGS_ALLOW_UNFREE = "1";
    #XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    VISUAL = "micro";
    EDITOR = "micro";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
  };

  fonts.fontconfig.enable = true;
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

  programs.pandoc.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = "AddKeysToAgent yes";
  };

  programs.bash = {
    enable = true;
    initExtra = "
    PATH=$HOME/.nix-profile/bin:$PATH
    [[ $- == *i* ]] && exec $HOME/.nix-profile/bin/zsh";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''source $HOME/.config/theme.zsh
    FPATH=$HOME/.nix-profile/share/zsh/site-functions:$FPATH
    compinit
    PATH=$HOME/.local/bin:$HOME/.local/share/flatpak/exports/bin:$PATH'';
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

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;

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
    ssh-agent = {
      Unit = {
        Description = "SSH Agent";
      };
      Service = {
        Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
        ExecStart = "/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      };
    };
  };

  home.file.".config/pypoetry/config.toml".text = lib.generators.toINI
    { }
    {
      virtualenvs = {
        in-project = true;
      };
    };
  home.file.".config/theme.zsh".source = ./theme.zsh;
  home.file.".local/bin/update".source = ./update.sh;
  home.file.".local/bin/backup".source = ./backup.sh;
  home.file.".local/bin/startup".source = ./startup.sh;
  home.file.".local/bin/flatpak-switch".source = ./flatpak-switch.py;
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
  home.file.".local/flatpak/chromium".source = ./normal-spawn.sh;
  home.file.".local/flatpak/code" = {
    text = "#!/usr/bin/env bash\nexec /app/bin/code --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto \"$@\"";
    executable = true;
  };
  home.file.".local/flatpak/brave" = {
    text = "#!/usr/bin/env bash\nexec /app/bin/brave --ozone-platform-hint=auto --enable-webrtc-pipewire-capturer=enabled --enable-raw-draw=enabled --use-vulkan --enable-features=VaapiVideoEncoder,CanvasOopRasterization --enable-zero-copy --ignore-gpu-blocklist --enable-usermedia-screen-capturing \"$@\"";
    executable = true;
  };
  home.file.".local/flatpak/host-spawn".source = ./host-spawn;
  home.file.".local/share/applications/net.chessin5d.desktop".text = ''[Desktop Entry]
    Encoding=UTF-8
    Version=1.0
    Type=Application
    Terminal=false
    Exec=${home.homeDirectory}/Games/5dchesswithmultiversetimetravel/5dchesswithmultiversetimetravel
    Name=5D Chess With Multiverse Time Travel
    Icon=${home.homeDirectory}/Games/5dchesswithmultiversetimetravel/5dchesswithmultiversetimetravel.png'';

  home.file.".local/share/flatpak/overrides/com.brave.Browser".text = lib.generators.toINI
    { }
    {
      Context = {
        filesystems = "home;/nix/store:ro;";
      };
      Environment = {
        PATH = "${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin";
      };
    };
  home.file.".local/share/flatpak/overrides/net.ankiweb.Anki".text = lib.generators.toINI
    { }
    {
      Environment = {
        ANKI_WAYLAND = 1;
      };
    };
  home.file.".local/share/flatpak/overrides/com.visualstudio.code".text = lib.generators.toINI
    { }
    {
      Context = {
        sockets = "wayland";
      };
      Environment = {
        PATH = "${home.homeDirectory}/.local/flatpak:${home.homeDirectory}/.local/bin:${home.homeDirectory}/.nix-profile/bin:/app/bin:/usr/bin:${home.homeDirectory}/.var/app/com.visualstudio.code/data/node_modules/bin";
      };
    };
  home.file.".local/share/flatpak/overrides/org.audacityteam.Audacity".text = lib.generators.toINI
    { }
    {
      Context = {
        sockets = "wayland";
      };
    };
  home.file.".local/share/flatpak/overrides/org.wireshark.Wireshark".text = lib.generators.toINI
    { }
    {
      Context = {
        filesystems = "home";
      };
    };

  home.file.".config/flatpak.json".text = builtins.toJSON
    {
      flathub = {
        url = "https://flathub.org/repo/flathub.flatpakrepo";
        packages = [
          "org.gnome.TextEditor"
          "org.gnome.Characters"
          "org.gnome.Logs"
          "org.gnome.Boxes"
          "ca.desrt.dconf-editor"
          "com.brave.Browser"
          "com.google.AndroidStudio"
          "com.github.tchx84.Flatseal"
          "org.videolan.VLC"
          "com.visualstudio.code"
          "rest.insomnia.Insomnia"
          "org.ghidra_sre.Ghidra"
          "org.wireshark.Wireshark"
          "net.ankiweb.Anki"
          "io.dbeaver.DBeaverCommunity"
          "com.obsproject.Studio"
          "org.gnome.Evince"
          "org.gnome.FileRoller"
          "org.gnome.Shotwell"
          "org.gnome.seahorse.Application"
          "org.gnome.PowerStats"
          "org.gnome.Boxes"
          "com.usebottles.bottles"
          "org.gnome.GHex"
          "org.audacityteam.Audacity"
          "com.mattjakeman.ExtensionManager"
          "org.localsend.localsend_app"
          "org.gnome.dspy"
        ];
      };
      flathub-beta = {
        url = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        packages = [ "org.gimp.GIMP" ];
      };
    };

  home.file.".local/share/backgrounds/background.jpg".source = ./wallpaper.jpg;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-seconds = false;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      speed = 0.00512820512820511;
      tap-and-drag = true;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://${home.homeDirectory}/.local/share/backgrounds/background.jpg";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/session" = {
      idle-delay = 300;
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
      event-sounds = true;
      theme-name = "__custom";
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-to-workspace-left = [ ];
      switch-to-workspace-right = [ ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Control><Alt>Left" ];
      toggle-tiled-right = [ "<Control><Alt>Right" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      next = [ "<Super>Right" ];
      play = [ "<Super>space" ];
      previous = [ "<Super>Left" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "gnome-terminal";
      name = "Terminal";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      idle-brightness = 20;
      power-button-action = "interactive";
      sleep-inactive-battery-timeout = 300;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "compiz-alike-magic-lamp-effect@hermes83.github.com"
        "compiz-windows-effect@hermes83.github.com"
        "ddterm@amezin.github.com"
        "AlphabeticalAppGrid@stuarthayhurst"
        "espresso@coadmunkee.github.com"
        "focus-changer@heartmire"
      ];
      favorite-apps = [ "com.brave.Browser.desktop" "org.gnome.Nautilus.desktop" "com.visualstudio.code.desktop" ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      background-opacity = 0.8;
      custom-theme-shrink = false;
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.9;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      preferred-monitor = -2;
      running-indicator-style = "DEFAULT";
      show-mounts = false;
      show-trash = false;
    };
    "org/gnome/shell/extensions/espresso" = {
      has-battery = true;
      show-notifications = false;
    };
    "org/gnome/shell/extensions/focus-changer" = {
      focus-down = [ "<Shift><Alt>Down" ];
      focus-left = [ "<Shift><Alt>Left" ];
      focus-right = [ "<Shift><Alt>Right" ];
      focus-up = [ "<Shift><Alt>Up" ];
    };
  };

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [ "nix-command" ];
  };

  home.activation = {
    setup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/Games/Minecraft/tlauncher"
      ln -sfT "$HOME/Games/Minecraft/tlauncher" "$HOME/.tlauncher"
      mkdir -p "$HOME/Games/5dchesswithmultiversetimetravel" "$HOME/.local/share/Thunkspace/5dchesswithmultiversetimetravel"
      ln -sfT "$HOME/Games/5dchesswithmultiversetimetravel/settings_and_progress.txt" "$HOME/.local/share/Thunkspace/5dchesswithmultiversetimetravel/settings_and_progress.txt"
      ln -sfT "$HOME/.nix-profile/share/gnome-shell/extensions" "$HOME/.local/share/gnome-shell/extensions"
      ln -sfT "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
      ln -sfT "$HOME/.nix-profile/share/icons" "$HOME/.local/share/icons"
      #"$HOME/.nix-profile/bin/ln" -sfT "$HOME/.nix-profile/share/dbus-1" "$HOME/.local/share/dbus-1"
      "$HOME/.local/bin/flatpak-switch"
    '';
  };
}
