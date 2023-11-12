{ config, pkgs, lib, nix-vscode-extensions, ... }:

let
  create_flatpak = file: {
    source = file;
    onChange = "cd /tmp && ${pkgs.flatpak-builder}/bin/flatpak-builder --force-clean --repo=${homeManager.home.homeDirectory}/.local/flatpak-repo /tmp/flatpak-builder ${file} && rm -rf /tmp/flatpak-builder && rm -rf /tmp/.flatpak-builder";
  };
  homeManager = rec {

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "riky";
    home.homeDirectory = "/var/home/riky";
    targets.genericLinux.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      tldr
      man-pages
      man-pages-posix
      perl
      docker
      docker-compose
      du-dust
      fd
      procs
      p7zip
      curlie
      netcat-openbsd
      iputils
      binutils
      unixtools.netstat
      gnomeExtensions.espresso
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.compiz-windows-effect
      gnomeExtensions.compiz-alike-magic-lamp-effect
      gnomeExtensions.burn-my-windows
      ddgr
      fira-code
      rust-analyzer
      rustfmt
      cargo
      php
      powertop
      maven
      micro
      nodePackages.pnpm
      nodejs-slim
      shellcheck
      android-tools
      nmap
      haskell-language-server
      exiftool
      imagemagick
      jdk
      inotify-tools
      nixpkgs-fmt
      brightnessctl
      traceroute
      poetry
      pypy3
      xdg-ninja
      python311Packages.ipython
      (haskellPackages.ghcWithPackages (pkgs: [ pkgs.turtle ]))
      glab
      (callPackage ./downloadhelper.nix { })
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

    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.local/share/flatpak/exports/bin" ];

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      VISUAL = "micro";
      EDITOR = "micro";
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
      CPATH = "${pkgs.opencl-headers}/include";
      LIBRARY_PATH = "${pkgs.ocl-icd}/lib";
      NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = "1";
      OCL_ICD_VENDORS = "${pkgs.intel-compute-runtime}/etc/OpenCL/vendors/intel-neo.icd";
      ANDROID_HOME = "${config.xdg.dataHome}/android";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
      JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    };

    fonts.fontconfig.enable = true;
    programs.bat.enable = true;
    programs.eza = {
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
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    programs.pandoc.enable = true;

    programs.ssh = {
      enable = true;
      extraConfig = "AddKeysToAgent yes";
    };

    programs.bash = {
      enable = true;
      initExtra = "[[ $- == *i* ]] && exec ${pkgs.zsh}/bin/zsh";
      historyFile = "${config.xdg.dataHome}/bash/bash_history";
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      initExtra = "source $HOME/.config/theme.zsh";
      shellAliases = {
        cat = "bat";
        du = "dust";
        find = "fd";
        ps = "procs";
        curl = "curlie";
        sudo = "sudo env \"PATH=$PATH\"";
        wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
        zip = "7z a";
        unzip = "7z x";
        python = "pypy3";
      };
      history.path = "${config.xdg.dataHome}/zsh/zsh_history";
      dotDir = ".config/zsh";
      zplug = {
        enable = true;
        plugins = [
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
        zplugHome = "${config.xdg.dataHome}/zplug";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
    };

    programs.tmux = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
      extraLuaConfig = ''
                vim.opt.termguicolors = true
                require'lspconfig'.pyright.setup{}
                require'lspconfig'.rnix.setup{}
                require("bufferline").setup{}
                require("toggleterm").setup{}
                require('feline').setup()
                require("nvim-tree").setup()

                vim.opt.expandtab = true
                vim.opt.smartindent = true
                vim.opt.tabstop = 4
                vim.opt.shiftwidth = 4
                vim.opt.number = true
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
                vim.opt.incsearch = true
                vim.opt.shortmess:remove({ 'S' })
                vim.api.nvim_create_autocmd('BufWritePre', {
                  buffer = vim.fn.bufnr(),
                  callback = function()
        	        vim.lsp.buf.format({ timeout_ms = 3000 })
        	      end,
                })
        	    vim.keymap.set('n', '<C-b>', '<cmd>NvimTreeToggle<cr>')
        	    vim.keymap.set('n', '<C-m>', '<cmd>TroubleToggle<cr>')
        	    vim.keymap.set('n', "<C-t>", '<cmd>ToggleTerm<cr>')
        	    vim.keymap.set('n', "<C-f>", '<cmd>Telescope live_grep<cr>')
        	    vim.keymap.set('n', "<esc>", '<cmd>nohlsearch<cr>')
      '';
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        trouble-nvim
        bufferline-nvim
        toggleterm-nvim
        feline-nvim
        nvim-tree-lua
        auto-save-nvim
        telescope-nvim
        nvim-treesitter.withAllGrammars
        lazygit-nvim
      ];
      extraPackages = with pkgs; [ nodePackages.pyright rnix-lsp ripgrep lazygit ];
    };

    home.file.".var/app/com.vscodium.codium/config/VSCodium/product.json".text = ''{
      "nameShort": "VSCodium",
      "nameLong": "Visual Studio Code",
      "extensionsGallery": {
        "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
        "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
        "itemUrl": "https://marketplace.visualstudio.com/items"
      }
    }'';

    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      package = pkgs.runCommandLocal "no-vscode" { pname = "vscode"; version = "1.79.1"; } "mkdir $out";
      extensions = (with nix-vscode-extensions.extensions.x86_64-linux.open-vsx; [
        mads-hartmann.bash-ide-vscode
        jeff-hykin.better-cpp-syntax
        ms-python.black-formatter
        ms-vscode.cpptools-themes
        streetsidesoftware.code-spell-checker
        vscjava.vscode-java-debug
        ms-azuretools.vscode-docker
        elmtooling.elm-ls-vscode
        tamasfe.even-better-toml
        haskell.haskell
        justusadam.language-haskell
        ms-python.isort
        streetsidesoftware.code-spell-checker-italian
        wholroyd.jinja
        ms-toolsai.jupyter
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-slideshow
        fwcd.kotlin
        mathiasfrohlich.kotlin
        redhat.java
        ms-vscode.live-server
        marp-team.marp-vscode
        pkief.material-icon-theme
        vscjava.vscode-maven
        bbenoist.nix
        jnoortheen.nix-ide
        zhuangtongfa.material-theme
        xdebug.php-debug
        bmewburn.vscode-intelephense-client
        esbenp.prettier-vscode
        vscjava.vscode-java-dependency
        getpsalm.psalm-vscode-plugin
        ms-python.python
        rust-lang.rust-analyzer
        foxundermoon.shell-format
        ms-vscode.test-adapter-converter
        hbenl.vscode-test-explorer
        vscjava.vscode-java-test
        tomoki1207.pdf
        redhat.vscode-xml
        redhat.vscode-yaml
        hbenl.test-adapter-converter
        llvm-vs-code-extensions.vscode-clangd
        ms-pyright.pyright
        surendrajat.apklab
        loyieking.smalise
        hashicorp.hcl
        mechatroner.rainbow-csv
        janisdd.vscode-edit-csv
      ]) ++ (with nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
        #htmlhint.vscode-htmlhint
        #visualstudioexptteam.vscodeintellicode
        #ms-python.vscode-pylance
      ]);
      keybindings = [
        {
          "key" = "ctrl+e";
          "command" = "-workbench.action.quickOpen";
        }
        {
          "key" = "ctrl+[Minus]";
          "command" = "workbench.action.terminal.toggleTerminal";
        }
        {
          "key" = "down";
          "command" = "-editor.action.scrollDownHover";
          "when" = "editorHoverFocused";
        }
        {
          "key" = "left";
          "command" = "-editor.action.scrollLeftHover";
          "when" = "editorHoverFocused";
        }
        {
          "key" = "right";
          "command" = "-editor.action.scrollRightHover";
          "when" = "editorHoverFocused";
        }
        {
          "key" = "up";
          "command" = "-editor.action.scrollUpHover";
          "when" = "editorHoverFocused";
        }
      ];
      mutableExtensionsDir = false;
      userSettings = {
        "editor.fontLigatures" = true;
        "files.autoSave" = "onFocusChange";
        "editor.fontSize" = 16;
        "python.formatting.provider" = "none";
        "explorer.confirmDragAndDrop" = false;
        "git.confirmSync" = false;
        "python.languageServer" = "Jedi";
        "git.autofetch" = true;
        "python.analysis.typeCheckingMode" = "strict";
        "editor.formatOnSave" = true;
        "git.enableCommitSigning" = true;
        "update.mode" = "none";
        "rust-analyzer.server.path" = "${home.homeDirectory}/.local/flatpak/rust-analyzer";
        "github.gitProtocol" = "ssh";
        "editor.fontFamily" = "'Fira Code'";
        "editor.linkedEditing" = true;
        "search.smartCase" = true;
        "git.enableSmartCommit" = true;
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "prettier.tabWidth" = 4;
        "[html]" = {
          "editor.defaultFormatter" = "vscode.html-language-features";
        };
        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = true;
        "[dockercompose]" = {
          "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "python.defaultInterpreterPath" = "/bin/python3";
        "explorer.confirmDelete" = false;
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        "git.autoStash" = true;
        "git.fetchOnPull" = true;
        "git.mergeEditor" = true;
        "git.pullBeforeCheckout" = true;
        "psalm.unusedVariableDetection" = true;
        "terminal.integrated.commandsToSkipShell" = [
          "language-julia.interrupt"
        ];
        "intelephense.diagnostics.typeErrors" = false;
        "markdown.marp.enableHtml" = true;
        "markdown.marp.themes" = [
          "./theme.css"
        ];
        "cSpell.language" = "en;it";
        "cSpell.enableFiletypes" = [
          "!python"
        ];
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.formatOnType" = true;
        };
        "redhat.telemetry.enabled" = true;
        "workbench.editor.limit.value" = 7;
        "workbench.editor.limit.enabled" = true;
        "workbench.colorTheme" = "One Dark Pro Darker";
        "workbench.preferredLightColorTheme" = "GitHub Light";
        "workbench.preferredDarkColorTheme" = "One Dark Pro Darker";
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "terminal.integrated.profiles.linux" = {
          "zsh" = {
            "path" = "${home.homeDirectory}/.local/flatpak/host-spawn";
            "icon" = "terminal-bash";
            "args" = [
              "/usr/bin/bash"
            ];
            "overrideName" = true;
          };
          "sh" = {
            "path" = "/bin/sh";
            "icon" = "terminal-linux";
          };
        };
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.shellIntegration.enabled" = false;
        "[dockerfile]" = {
          "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
        };
        "java.configuration.runtimes" = [
          {
            "name" = "JavaSE-19";
            "path" = "${home.homeDirectory}/.nix-profile/lib/openjdk";
            "default" = true;
          }
        ];
        "settingsSync.ignoredSettings" = [
          "-python.formatting.blackPath"
          "-python.defaultInterpreterPath"
        ];
        "java.configuration.updateBuildConfiguration" = "automatic";
        "workbench.iconTheme" = "material-icon-theme";
        "java.compile.nullAnalysis.mode" = "automatic";
        "java.completion.filteredTypes" = [
          "com.sun.*"
          "sun.*"
          "jdk.*"
          "org.graalvm.*"
          "io.micrometer.shaded.*"
        ];
        "haskell.manageHLS" = "PATH";
        "window.zoomLevel" = 1;
        "vsintellicode.modelDownloadPath" = "${home.homeDirectory}/.var/app/com.vscodium.codium/data/codium/intellicode";
        "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";
        "clangd.path" = "${home.homeDirectory}/.var/app/com.vscodium.codium/config/VSCodium/User/globalStorage/llvm-vs-code-extensions.vscode-clangd/install/16.0.2/clangd_16.0.2/bin/clangd";
        "apklab.apkSignerPath" = "${home.homeDirectory}/.apklab/uber-apk-signer-1.3.0.jar";
        "apklab.apktoolPath" = "${home.homeDirectory}/.apklab/apktool_2.8.1.jar";
        "apklab.jadxDirPath" = "${home.homeDirectory}/.apklab/jadx-1.4.7";
      };
    };


    programs.nix-index.enable = true;

    programs.home-manager.enable = true;
    home.stateVersion = "22.05";
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; android_sdk.accept_license = true; }";
    home.enableNixpkgsReleaseCheck = true;

    news.display = "show";
    nix.settings = {
      auto-optimise-store = true;
      auto-allocate-uids = true;
      extra-nix-path = "nixpkgs=flake:nixpkgs";
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
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    xdg = {
      enable = true;
      userDirs = {
        createDirectories = true;
        enable = true;
        documents = "${home.homeDirectory}/backup/Documents";
      };
    };

    systemd.user.services = {
      keepass = {
        Unit = {
          Description = "KeepassXC";
        };
        Service = {
          ExecStart = "bash -c 'while ! host www.google.com; do sleep 5; done;sleep 5; gio mount google-drive://riky.isola@gmail.com; secret-tool lookup 'keepass' 'password' | flatpak run org.keepassxc.KeePassXC --pw-stdin \"/run/user/1000/gvfs/google-drive:host=gmail.com,user=riky.isola/My Drive/keepass.kdbx\"'";
        };
        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
      autotune = {
        Unit = { Description = "Powertop autotune"; };
        Service = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${home.homeDirectory}/.local/bin/autotune";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      cat = {
        Unit = { Description = "X11 Cat"; };
        Service = {
          ExecStart = "${pkgs.oneko}/bin/oneko -tora -bg 'dark gray'";
        };
        Install = { WantedBy = [ "gnome-session-x11-services.target" ]; };
      };
    };

    home.file.".gdbinit".text = "source ${pkgs.gef}/share/gef/gef.py";
    home.file."Templates/emptyfile.txt".text = "";
    home.file."Templates/pwntools.py".source = ./pwntoolstemplate.py;

    home.file.".config/pypoetry/config.toml".text = lib.generators.toINI
      { }
      {
        virtualenvs = {
          in-project = true;
        };
      };
    home.file.".config/theme.zsh".source = ./theme.zsh;

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
    home.file.".var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".text = ''	
          {	
          "allowed_origins": [	
              "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/",	
              "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"	
          ],	
          "description": "KeePassXC integration with native messaging support",	
          "name": "org.keepassxc.keepassxc_browser",	
          "path": "${home.homeDirectory}/.local/flatpak/org.keepassxc.KeePassXC",	
          "type": "stdio"	
      }	
    '';


    home.file.".config/autostart/startup.desktop".text = ''
      [Desktop Entry]
      Exec=${./startup.sh}
      Name=startup
      Comment=Startup
      Type=Application
      Icon=nautilus'';
    home.file.".local/bin/conservative".source = ./conservative.sh;
    home.file.".local/bin/charge".source = ./charge.py;

    home.file.".local/bin/chromium" = {
      text = "#!/usr/bin/env bash\nexec flatpak run --command=/app/bin/chromium org.chromium.Chromium \"$@\"";
      executable = true;
    };

    home.file.".local/flatpak/git".source = ./normal-spawn.sh;
    home.file.".local/flatpak/org.keepassxc.KeePassXC".source = ./normal-spawn.sh;
    home.file.".local/flatpak/chromium".source = ./normal-spawn.sh;
    home.file.".local/flatpak/docker".source = ./normal-spawn.sh;
    home.file.".local/flatpak/ghc" = {
      text = "#!/usr/bin/env bash\nif [ -f default.nix ]; then exec flatpak-spawn --host nix-shell --pure --run \"ghc $(printf \"'%s' \" \"$@\")\" default.nix; else exec flatpak-spawn --host ghc \"$@\"; fi";
      executable = true;
    };
    home.file.".local/flatpak/cabal-fmt" = {
      text = "#!/usr/bin/env bash\nexec flatpak-spawn --host ${pkgs.haskellPackages.cabal-fmt.bin}/bin/cabal-fmt \"$@\"";
      executable = true;
    };
    home.file.".local/flatpak/cargo" = {
      text = "#!/usr/bin/env bash\nif [ -f shell.nix ]; then exec flatpak-spawn --host nix-shell --pure --run \"cargo $*\"; else exec ${pkgs.cargo}/bin/cargo \"$@\"; fi";
      executable = true;
    };
    home.file.".local/flatpak/rust-analyzer" = {
      text = "#!/usr/bin/env bash\nif [ -f shell.nix ]; then exec flatpak-spawn --host nix-shell --pure --run \"rust-analyzer $*\"; else exec ${pkgs.rust-analyzer}/bin/rust-analyzer \"$@\"; fi";
      executable = true;
    };
    home.file.".local/flatpak/code" = {
      text = "#!/usr/bin/env bash\nexec /app/bin/code --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto \"$@\"";
      executable = true;
    };
    home.file.".local/flatpak/cobalt" = {
      text = "#!/usr/bin/env bash\nln -sfT $XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer $XDG_RUNTIME_DIR/kpxc_server && exec /app/bin/cobalt --ozone-platform-hint=auto --enable-features=WebContentsForceDark \"$@\"";
      executable = true;
    };
    home.file.".local/flatpak/brave" = {
      #text = "#!/usr/bin/env bash\nln -sfT $XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer $XDG_RUNTIME_DIR/kpxc_server && mkdir -p /etc/brave/policies/managed && ln -sf \"$HOME/.local/nix-sources/policy.json\" /etc/brave/policies/managed/policy.yml && exec /app/bin/cobalt --ozone-platform-hint=auto --enable-features=WebContentsForceDark --incognito \"$@\"";
      text = "#!/usr/bin/env bash\nln -sfT $XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer $XDG_RUNTIME_DIR/kpxc_server && exec /app/bin/cobalt --ozone-platform-hint=auto --enable-features=WebContentsForceDark,AIChat --incognito \"$@\"";
      executable = true;
    };
    home.file.".local/flatpak/codium" = {
      text = "#!/usr/bin/env bash\nexec /app/bin/codium --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto \"$@\"";
      executable = true;
    };
    home.file.".local/flatpak/host-spawn".source = ./host-spawn;

    home.file.".local/share/flatpak/overrides/ca.desrt.dconf-editor".text = ''
      [Context]
      filesystems=~/.config/dconf/user:ro
      [Session Bus Policy]
      org.freedesktop.Flatpak=none
    '';
    home.file.".local/share/flatpak/overrides/com.github.tchx84.Flatseal".text = ''
      [Context]
      filesystems=/nix/store:ro
    '';
    home.file.".local/share/flatpak/overrides/com.google.AndroidStudio".text = ''
      [Context]
      filesystems=xdg-documents/Projects/Android;!host
      persistent=.android;Android

      [Session Bus Policy]
      org.freedesktop.Flatpak=none
    '';
    home.file.".local/share/flatpak/overrides/com.obsproject.Studio".text = ''
      [Context]
      filesystems=!xdg-config/kdeglobals;xdg-videos;!host

      [Session Bus Policy]
      org.freedesktop.Flatpak=none
    '';
    # home.file.".local/share/flatpak/overrides/com.userbottles.bottles".text = ''
    #   [Context]
    #   filesystems=!xdg-download
    # '';
    home.file.".local/share/flatpak/overrides/com.visualstudio.code".text = ''
      [Context]
      filesystems=!xdg-config/kdeglobals;!xdg-config/gtk-3.0;!host
    '';
    home.file.".local/share/flatpak/overrides/com.vscodium.codium".text = ''
      [Context]
      filesystems=!xdg-config/kdeglobals;/nix/store:ro;~/.nix-profile/bin:ro;~/.local/bin:ro;~/.local/flatpak:ro;~/.vscode/extensions:ro;xdg-config/Code/User:ro;!host;xdg-documents

      [Environment]
      PATH=${home.homeDirectory}/.local/flatpak:${home.homeDirectory}/.local/bin:${home.homeDirectory}/.nix-profile/bin:/app/bin:/usr/bin
    '';
    home.file.".local/share/flatpak/overrides/io.dbeaver.DBeaverCommunity".text = ''
      [Context]
      sockets=!ssh-auth
      filesystems=!home
    '';
    home.file.".local/share/flatpak/overrides/net.ankiweb.Anki".text = ''
      [Environment]
      ANKI_WAYLAND=1
    '';
    home.file.".local/share/flatpak/overrides/org.chromium.Chromium".text = ''
      [Context]
      filesystems=/nix/store:ro;xdg-run/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer:ro

      [Environment]
      PATH=${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin
    '';
    home.file.".local/share/flatpak/overrides/com.brave.Browser".text = ''
      [Context]
      filesystems=!xdg-download;/nix/store:ro;xdg-run/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer:ro;~/.local/nix-sources/policy.json:ro;~/.local/flatpak:ro;~/.nix-profile:ro

      [Environment]
      PATH=${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin

      [Session Bus Policy]
      org.freedesktop.Flatpak=talk
    '';
    home.file.".local/share/flatpak/overrides/org.ghidra_sre.Ghidra".text = ''
      [Context]
      filesystems=xdg-documents/CTF:ro;!home
      persistent=.ghidra
    '';
    home.file.".local/share/flatpak/overrides/org.gimp.GIMP".text = ''
      [Context]
      filesystems=!xdg-run/gvfs;!xdg-run/gvfsd;!/tmp;!xdg-config/gtk-3.0;!xdg-config/GIMP;xdg-pictures;!host
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.Boxes".text = ''
      [Context]
      filesystems=!host
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.Loupe".text = ''
      [Context]
      filesystems=!xdg-run/gvfs;!xdg-run/gvfsd;!host
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.Evince".text = ''
      [Context]
      filesystems=!/run/media;!xdg-run/gvfsd;!/media;!home
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.FileRoller".text = ''
      [Context]
      filesystems=!home
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.GHex".text = ''
      [Context]
      filesystems=!xdg-run/gvfsd;!host
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.TextEditor".text = ''
      [Context]
      filesystems=!xdg-run/gvfsd;!host
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.Totem".text = ''
      [Context]
      filesystems=!xdg-run/gvfs;!xdg-run/gvfsd;!/run/media;!xdg-videos;!xdg-pictures;!xdg-download
    '';
    home.file.".local/share/flatpak/overrides/org.keepassxc.KeePassXC".text = ''
      [Context]
      filesystems=!xdg-config/kdeglobals;!/tmp;/nix/store:ro;!host
    '';
    home.file.".local/share/flatpak/overrides/org.pitivi.Pitivi".text = ''
      [Context]
      filesystems=xdg-videos;!host
    '';
    home.file.".local/share/flatpak/overrides/org.remmina.Remmina".text = ''
      [Context]
      filesystems=!xdg-download;!xdg-run/gvfsd;~/.ssh;!home
    '';
    home.file.".local/share/flatpak/overrides/org.wireshark.Wireshark".text = ''
      [Context]
      filesystems=!xdg-config/kdeglobals;!xdg-public-share;xdg-download;!home
    '';

    home.file.".var/app/org.keepassxc.KeePassXC/config/keepassxc/keepassxc.ini".text = ''
      [General]
      ConfigVersion=2
      MinimizeAfterUnlock=true
      UseAtomicSaves=false
      AutoSaveAfterEveryChange=false

      [Browser]
      AlwaysAllowAccess=true
      CustomProxyLocation=
      Enabled=true
      SearchInAllDatabases=false

      [GUI]
      MinimizeOnClose=true
      MinimizeOnStartup=true
      MinimizeToTray=true
      ShowTrayIcon=true
      TrayIconAppearance=monochrome-light

      [KeeShare]
      Active="<?xml version=\"1.0\"?><KeeShare><Active/></KeeShare>\n"
      Own="<?xml version=\"1.0\"?><KeeShare><PrivateKey>MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCv+DiaOYsA5VeObx8y0Z0dUaAHBejPyLXaYpHFz5SCqUkiPGhVYlyN4hRrIaKWWS8+uNHE+TRasLoMeKLSl/QLz8bJnIUfbBmUa2yG3ES+l+vAFUQ9fdJMFSm+zbzhM8jg6rRj+T9QyDZlH7oD5TwibJ04M9krqlUxjaCNSjUpNZMPbBfxMRNllwERlAGY7EtqsIg/L8LyVagUGnZtKCy2rUftUb9lUUKPQ9Qkp7KsveTJ/OHEMHE3tEI/7EKBpvV2IYXgsuqjGXogx/DwBnC2HMAX0pr35V46X6dXfVYeLQVxCzI3zo2kIdeUEVNPT0WmbZoY6+kWcWYfLNgSwO0DAgMBAAECggEABdCZhajc/B08lfNFFwMry5a6kKxGiEanbXQ5ZfI0ljItK0mF4DvdN4foEmVaf7QYCu8y+1quOv+KLA/B5IE0PIdmGAnf+khXHzIVRqWU3fcuNzsTiCIWMAC5BuxxGHcn0tQDPLkQuVdMXW4Y5CY0krgRraaOGvc2VDNeZnhGpnD6YfymWb+LTvM8zv1FGa4DGb/rEiunPlbaLM0FFwpQ8/JdPI8FUK36Yrf8Xk/MzNwYQepBEj9osfVxvTzRa4Jvrh8P25nYEBMIJKzHM3+MqM2a3xC5K72GKvjFLOOQz7pUKaSc0kbPkf7JD24x1pHXkPqXGJPG5qPPUxVkDj/K2QKBgQDNvo08G91E3AzI6ssndNo1FQyfyBHLRzXdL6KEl6+bXowDKvYmQw3bQxy86eylnqscYQIqsSWI0cxNgsffQnSefq0f+q7qI6pZXiHiR137rodEHGUDXfIyGpPDR8WShMKBfdjptm3CkApCtgeGy82wBzToTIl1m9RcT8BNM6XZ2wKBgQDa89Gay9c/0Q0l8hq8Slt4hNq4LtshSZ+my4l6Wbu+1RUUa6mseKGo2vLFzGVRn4AnumhW4HWqlwxGDda9MxJiP7PuBeZjUFmhW0RFMDkvsRUQBzIWgPe7+jrfVMHwr9nUzOF9uKadPG1YM0M+DFaDxKRD06CU0MNtSbHl8ahF+QKBgQCB0NR+c7pmQ03Ry8vJJoKz8YcYnf0UPOcwm2i4rpi/uKUxLn9HXxG0IiFU1Whai8W9Tzw1wbZEINP+qCECroS0qIsF3X9V/pDyeGF6y7ryHYn9oMjfmfxCPuCy22s+6oNrfwNJW7DfjVDcDMys8ZTjl3h7hidJTLxuTmewjoD79wKBgAIihHWs7SFbKXSoQqh5VSD8sqE/G7XcYOkgbOu7ekAnFbiIQDRFTNY3pExXbNl546b/g0rtj1glduIr+l8H43L/ygJVHmTzgJw5JpZCHRyg7mKkn1Fm2oODshVBX064eDhB8yTlqwI3d513in1NY36PaUacBqHM00r6f/iM/aYJAoGATDR8rHxE5p5p2V4gtnn1iTSNbAJy++tWBmNPAXomph7r4kKkL0LVmCt+1eiTE0Xe4byn6b6YAEWo/GikvMHitukrcNJ6V8XwtNAdgA2ML8+p54y8w1R/Du7IJWbt3lnl0R47DQ6Om8Dpqy63DgD3uJGFyfz3D8X41t7WBwJzBYY=</PrivateKey><PublicKey><Signer>riky</Signer><Key>MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCv+DiaOYsA5VeObx8y0Z0dUaAHBejPyLXaYpHFz5SCqUkiPGhVYlyN4hRrIaKWWS8+uNHE+TRasLoMeKLSl/QLz8bJnIUfbBmUa2yG3ES+l+vAFUQ9fdJMFSm+zbzhM8jg6rRj+T9QyDZlH7oD5TwibJ04M9krqlUxjaCNSjUpNZMPbBfxMRNllwERlAGY7EtqsIg/L8LyVagUGnZtKCy2rUftUb9lUUKPQ9Qkp7KsveTJ/OHEMHE3tEI/7EKBpvV2IYXgsuqjGXogx/DwBnC2HMAX0pr35V46X6dXfVYeLQVxCzI3zo2kIdeUEVNPT0WmbZoY6+kWcWYfLNgSwO0DAgMBAAECggEABdCZhajc/B08lfNFFwMry5a6kKxGiEanbXQ5ZfI0ljItK0mF4DvdN4foEmVaf7QYCu8y+1quOv+KLA/B5IE0PIdmGAnf+khXHzIVRqWU3fcuNzsTiCIWMAC5BuxxGHcn0tQDPLkQuVdMXW4Y5CY0krgRraaOGvc2VDNeZnhGpnD6YfymWb+LTvM8zv1FGa4DGb/rEiunPlbaLM0FFwpQ8/JdPI8FUK36Yrf8Xk/MzNwYQepBEj9osfVxvTzRa4Jvrh8P25nYEBMIJKzHM3+MqM2a3xC5K72GKvjFLOOQz7pUKaSc0kbPkf7JD24x1pHXkPqXGJPG5qPPUxVkDj/K2QKBgQDNvo08G91E3AzI6ssndNo1FQyfyBHLRzXdL6KEl6+bXowDKvYmQw3bQxy86eylnqscYQIqsSWI0cxNgsffQnSefq0f+q7qI6pZXiHiR137rodEHGUDXfIyGpPDR8WShMKBfdjptm3CkApCtgeGy82wBzToTIl1m9RcT8BNM6XZ2wKBgQDa89Gay9c/0Q0l8hq8Slt4hNq4LtshSZ+my4l6Wbu+1RUUa6mseKGo2vLFzGVRn4AnumhW4HWqlwxGDda9MxJiP7PuBeZjUFmhW0RFMDkvsRUQBzIWgPe7+jrfVMHwr9nUzOF9uKadPG1YM0M+DFaDxKRD06CU0MNtSbHl8ahF+QKBgQCB0NR+c7pmQ03Ry8vJJoKz8YcYnf0UPOcwm2i4rpi/uKUxLn9HXxG0IiFU1Whai8W9Tzw1wbZEINP+qCECroS0qIsF3X9V/pDyeGF6y7ryHYn9oMjfmfxCPuCy22s+6oNrfwNJW7DfjVDcDMys8ZTjl3h7hidJTLxuTmewjoD79wKBgAIihHWs7SFbKXSoQqh5VSD8sqE/G7XcYOkgbOu7ekAnFbiIQDRFTNY3pExXbNl546b/g0rtj1glduIr+l8H43L/ygJVHmTzgJw5JpZCHRyg7mKkn1Fm2oODshVBX064eDhB8yTlqwI3d513in1NY36PaUacBqHM00r6f/iM/aYJAoGATDR8rHxE5p5p2V4gtnn1iTSNbAJy++tWBmNPAXomph7r4kKkL0LVmCt+1eiTE0Xe4byn6b6YAEWo/GikvMHitukrcNJ6V8XwtNAdgA2ML8+p54y8w1R/Du7IJWbt3lnl0R47DQ6Om8Dpqy63DgD3uJGFyfz3D8X41t7WBwJzBYY=</Key></PublicKey></KeeShare>\n"
      QuietSuccess=true

      [PasswordGenerator]
      AdditionalChars=
      ExcludedChars=

      [Security]
      ClearClipboard=false
      IconDownloadFallback=true
      LockDatabaseScreenLock=false
    '';

    home.file.".local/nix-sources/policy.json".text = builtins.toJSON {
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderKeyword = "duckduckgo.com";
      DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      PaymentMethodQueryEnabled = false;
      HighEfficiencyModeEnabled = true;
      BookmarkBarEnabled = true;
      BackgroundModeEnabled = false;
      AlwaysOpenPdfExternally = true;
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveShieldsDisabledForUrls = [ "https://duckduckgo.com" ];
      IPFSEnabled = false;
      ExtensionInstallForcelist = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # Ublock lite
        "oboonakemofpalcgghocfoadofidjkkk" # KeepassXC
        "lmjnegcaeklhafolokijcfjliaokphfk" # Video Download Helper
        "fnaicdffflnofjppbagibeoednhnbjhg" # Floccus
        "mpbjkejclgfgadiemmefgebjfooflfhl" # Buster
        "ceipnlhmjohemhfpbjdgeigkababhmjc" # I'm not a robot
        "dpplndkoilcedkdjicmbeoahnckdcnle" # 123Apps
      ];
    };

    home.file.".local/nix-sources/flatpak.json".text = builtins.toJSON
      {
        flathub = {
          url = "https://flathub.org/repo/flathub.flatpakrepo";
          packages = [
            "org.gnome.TextEditor"
            "org.gnome.Characters"
            "org.gnome.Logs"
            "org.gnome.Boxes"
            "ca.desrt.dconf-editor"
            "com.github.tchx84.Flatseal"
            "rest.insomnia.Insomnia"
            "org.ghidra_sre.Ghidra"
            "org.wireshark.Wireshark"
            "net.ankiweb.Anki"
            "io.dbeaver.DBeaverCommunity"
            "com.obsproject.Studio"
            "org.gnome.seahorse.Application"
            "org.gnome.PowerStats"
            "org.gnome.Boxes"
            "com.usebottles.bottles"
            "org.gnome.GHex"
            "org.gnome.Extensions"
            "org.localsend.localsend_app"
            "org.gnome.dspy"
            "org.gnome.Snapshot"
            "org.gnome.SoundRecorder"
            "org.pitivi.Pitivi"
            "org.keepassxc.KeePassXC"
            "com.google.AndroidStudio"
            "org.gnome.Totem"
            "org.gnome.FileRoller"
            "org.gnome.Evince"
            "org.chromium.Chromium"
            "org.gnome.Loupe"
            "com.vscodium.codium"
            "org.freedesktop.Sdk//22.08"
            "org.freedesktop.Platform//22.08"
            "org.remmina.Remmina"
            "com.github.micahflee.torbrowser-launcher"
            "com.brave.Browser"
            "org.gnome.SimpleScan"
          ];
        };
        flathub-beta = {
          url = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
          packages = [ "org.gimp.GIMP" ];
        };
        local = {
          url = "file://${home.homeDirectory}/.local/flatpak-repo";
          packages = [
            "org.tlauncher.TLauncher"
            "org.chromium.Chromium.Extension.KeepassXC"
            "org.chromium.Chromium.Extension.VideoDownloadHelper"
            "org.chromium.Chromium.Extension.Policy"
          ];
        };
      };

    home.file.".local/nix-sources/tlauncher.yml" = create_flatpak ./tlauncher.yml;
    home.file.".local/nix-sources/keepassxc.yml" = create_flatpak ./keepassxc.yml;
    home.file.".local/nix-sources/downloadhelper.yml" = create_flatpak ./downloadhelper.yml;
    home.file.".local/nix-sources/chrome-policy.yml" = create_flatpak ./chrome-policy.yml;
    home.file.".local/nix-sources/powertop.hs" = {
      source = ./powertop.hs;
      onChange = ''
        ${pkgs.ghc}/bin/ghc ${./powertop.hs} -odir /tmp/autotune -hidir /tmp/autotune -o "$HOME/.local/bin/autotune"
        sudo chown root:root "$HOME/.local/bin/autotune"
        sudo chmod u+s "$HOME/.local/bin/autotune"
        rm -rf /tmp/autotune
      '';
    };
    home.file.".local/nix-sources/udev.rules" = {
      source = ./udev.rules;
      onChange = ''
        sudo bash -c 'cp ${./udev.rules} /etc/udev/rules.d/40-custom.rules'
        sudo bash -c 'cp ${pkgs.qflipper}/etc/udev/rules.d/42-flipperzero.rules /etc/udev/rules.d/42-flipperzero.rules'
        sudo bash -c 'cp ${pkgs.android-udev-rules}/lib/udev/rules.d/51-android.rules /etc/udev/rules.d/51-android.rules'
        sudo udevadm control --reload-rules
        sudo udevadm trigger
      '';
    };

    home.file.".local/share/backgrounds/background.jpg".source = ./wallpaper.jpg;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        clock-show-date = true;
        clock-show-seconds = false;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
        font-antialiasing = "rgba";
        font-hinting = "full";
        show-battery-percentage = true;
        toolkit-accessibility = false;
      };
      "org/gnome/desktop/peripherals/mouse" = {
        speed = 1.0;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        click-method = "areas";
        speed = 0.6;
        tap-and-drag = true;
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };
      "org/gnome/desktop/screensaver" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file:///usr/share/backgrounds/gnome/adwaita-l.webp";
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
        switch-to-workspace-left = [ "<Super>j" "<Super>h" ];
        switch-to-workspace-right = [ "<Super>k" "<Super>l" ];
        close = [ "<Super>x" ];
        move-to-workspace-left = [ "<Shift><Super>j" "<Shift><Super>h" ];
        move-to-workspace-right = [ "<Shift><Super>k" "<Shift><Super>l" ];
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":close";
      };
      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = [ "<Control><Alt>Left" ];
        toggle-tiled-right = [ "<Control><Alt>Right" ];
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
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
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          "compiz-alike-magic-lamp-effect@hermes83.github.com"
          "compiz-windows-effect@hermes83.github.com"
          "AlphabeticalAppGrid@stuarthayhurst"
          "espresso@coadmunkee.github.com"
          "burn-my-windows@schneegans.github.com"
        ];
        favorite-apps = [ "com.brave.Browser.desktop" "org.gnome.Nautilus.desktop" "com.vscodium.codium.desktop" "org.gnome.Console.desktop" ];
      };
      "org/gnome/desktop/privacy" = {
        remove-old-trash-files = true;
        remove-old-temp-files = true;
        old-files-age = 30;
      };
      "org/gnome/shell/extensions/burn-my-windows" = {
        active-profile = toString ./window-animation.conf;
      };
      "org/gnome/shell/extensions/espresso" = {
        has-battery = true;
        show-notifications = false;
      };
      "org/gnome/Console" = {
        last-window-size = lib.hm.gvariant.mkTuple [ 1900 1048 ];
      };
    };

    nix.package = pkgs.nix;
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
    };

    home.activation = {
      setup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfT "$HOME/backup/id_ed25519" "$HOME/.ssh/id_ed25519"
        ln -sfT "$HOME/backup/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
        chmod 600 "$HOME/.ssh/id_ed25519"
        mkdir -p "$HOME/.var/app/org.tlauncher.TLauncher/.tlauncher"
        ln -sfT "$HOME/backup/Games/Minecraft/tlauncher" "$HOME/.var/app/org.tlauncher.TLauncher/.tlauncher"
        mkdir -p "$HOME/.var/app/org.tlauncher.TLauncher/.minecraft"
        ln -sfT "$HOME/backup/Games/Minecraft/minecraft" "$HOME/.var/app/org.tlauncher.TLauncher/.minecraft"
        ln -sfT "$HOME/.nix-profile/share/gnome-shell/extensions" "$HOME/.local/share/gnome-shell/extensions"
        ln -sfT "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
        ln -sfT "$HOME/.nix-profile/share/icons" "$HOME/.local/share/icons"
        rm -rf "$HOME/.var/app/com.vscodium.codium/data/codium/extensions"
        mkdir -p "$HOME/.var/app/com.vscodium.codium/data/codium"
        mkdir -p "$HOME/.var/app/com.vscodium.codium/config/VSCodium/User"
        ln -sfT "$HOME/.vscode/extensions" "$HOME/.var/app/com.vscodium.codium/data/codium/extensions"
        ln -sfT "$HOME/.config/Code/User/settings.json" "$HOME/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json"
        ln -sfT "$HOME/.config/Code/User/keybindings.json" "$HOME/.var/app/com.vscodium.codium/config/VSCodium/User/keybindings.json"
        mkdir -p "$HOME/.local/share/applications"
        for f in com.vscodium.codium com.vscodium.codium-url-handler; do
            sed -E 's:^(Exec=.*com\.vscodium\.codium)(.*)$:\1 --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto\2:' < "$HOME/.local/share/flatpak/exports/share/applications/$f.desktop" > "$HOME/.local/share/applications/$f.desktop"
        done
        systemctl enable --user podman.socket
        systemctl --user mask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
        ${./flatpak-switch.py}
      '';
    };
  };

in
homeManager
