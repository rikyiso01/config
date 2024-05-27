{ config, pkgs, lib, nix-vscode-extensions, ... }:

let
  create_flatpak = file: {
    source = file;
    onChange = "cd /tmp && ${pkgs.flatpak-builder}/bin/flatpak-builder --force-clean --repo=${homeManager.home.homeDirectory}/.local/flatpak-repo /tmp/flatpak-builder ${file} && rm -rf /tmp/flatpak-builder && rm -rf /tmp/.flatpak-builder";
  };
  homeManager = rec {

    manual.html.enable = false;
    manual.manpages.enable = true;
    manual.json.enable = false;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "riky";
    home.homeDirectory = "/var/home/riky";
    targets.genericLinux.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      perl
      tldr
      man-pages
      man-pages-posix
      du-dust
      fd
      procs
      p7zip
      curlie
      netcat-openbsd
      iputils
      binutils
      unixtools.netstat
      gnomeExtensions.caffeine
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.compiz-windows-effect
      gnomeExtensions.compiz-alike-magic-lamp-effect
      gnomeExtensions.burn-my-windows
      gnomeExtensions.system-monitor-tray-indicator
      gnomeExtensions.stopwatch
      gnomeExtensions.one-window-wonderland
      fira-code
      fira-code-nerdfont
      php
      powertop
      micro
      android-tools
      nmap
      exiftool
      imagemagick
      jre
      brightnessctl
      traceroute
      xdg-ninja
      python311Packages.ipython
      devbox
      pre-commit
      gnome-console
      git-ignore
      evtest
      ascii
      virt-manager
      w3m
      bluetuith
      networkmanager
      neofetch
      pulseaudio
      brightnessctl
      playerctl
      vbindiff
      trash-cli
      python312Packages.pipx
      distrobox
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

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      mouse = true;
      extraConfig = ''
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        set-window-option -g mode-keys vi
        set-option -sa terminal-features ',foot:RGB'
        set-option -sg escape-time 10
      '';
    };
    programs.htop.enable = true;
    programs.ranger = {
      enable = true;
      extraConfig = ''
        map dT shell ${pkgs.trash-cli}/bin/trash-put %s
        map dD shell ${pkgs.trash-cli}/bin/trash-put %s
      '';
    };
    home.file.".config/ranger/rifle.conf".text = ''
      !mime ^application/json|^text|^inode,!ext sh,!ext sql,!ext pl, flag f = xdg-open "$1"
      label editor = "$EDITOR" -- "$@"
      label pager  = "$PAGER" -- "$@"
    '';
    programs.foot = { enable = true; settings = { main = { shell = "${pkgs.tmux}/bin/tmux new-session 'exec ranger'"; font = "FiraCode Nerd Font Mono:size=16"; }; }; };
    programs.lazygit.enable = true;

    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.local/share/flatpak/exports/bin" ];

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      VISUAL = "${pkgs.vim}/bin/vim";
      EDITOR = "${pkgs.vim}/bin/vim";
      SUDO_EDITOR = "${pkgs.vim}/bin/vim";
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
      NIXOS_OZONE_WL = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    fonts.fontconfig.enable = true;
    programs.bat.enable = true;
    programs.eza.enable = true;
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

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    home.file.".config/distrobox/distrobox.conf".text = ''
      container_generate_entry=0
      container_manager="podman"
      container_image_default="quay.io/toolbx/ubuntu-toolbox:latest"
      container_name_default="test"
    '';

    # programs.bash = {
    #   enable = true;
    #   initExtra = "[[ $- == *i* ]] && exec ${pkgs.zsh}/bin/zsh";
    #   historyFile = "${config.xdg.dataHome}/bash/bash_history";
    # };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      initExtra = ''
        bindkey -e
        source $HOME/.config/theme.zsh
      '';
      shellAliases = {
        cat = "bat";
        du = "dust";
        find = "fd";
        ps = "procs";
        curl = "curlie";
        wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
        zip = "7z a";
        unzip = "7z x";
        nix = "LD_LIBRARY_PATH='' nix";
        devbox = "LD_LIBRARY_PATH='' devbox";
        top = "htop";
      };
      history.path = "${config.xdg.dataHome}/zsh/zsh_history";
      dotDir = ".config/zsh";
      zplug = {
        enable = true;
        plugins = [
          { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
        zplugHome = "${config.xdg.dataHome}/zplug";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
    };

    programs.vim.enable = true;

    programs.neovim = {
      enable = true;
      extraLuaConfig = ''
                vim.opt.termguicolors = true
                local lsp_capabilities=require("cmp_nvim_lsp").default_capabilities()
                require'lspconfig'.pyright.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.pyright}/bin/pyright-langserver","--stdio"},settings={python={analysis={typeCheckingMode="strict",stubPath="/var/home/riky/backup/Documents/Projects/Python/common-stubs",extraPaths={"typings"}}}}}
                require'lspconfig'.ruff.setup{capabilities=lsp_capabilities,cmd={"${pkgs.ruff}/bin/ruff","server","--preview"}}
                require'lspconfig'.nil_ls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nil}/bin/nil"}}
                require'lspconfig'.ansiblels.setup{capabilities=lsp_capabilities,cmd={"${pkgs.ansible-language-server}/bin/ansible-language-server","--stdio"}}
                require'lspconfig'.bashls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server","--stdio"}}
                require'lspconfig'.hls.setup{capabilities=lsp_capabilities,cmd={"haskell-language-server-wrapper","--lsp"}}
                require'lspconfig'.dockerls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.dockerfile-language-server-nodejs}/bin/docker-langserver","--stdio"}}
                require'lspconfig'.yamlls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.yaml-language-server}/bin/yaml-language-server","--stdio"}}
                require'lspconfig'.jdtls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.jdt-language-server}/bin/jdtls", "-configuration", "${home.homeDirectory}/.cache/jdtls/config", "-data", "${home.homeDirectory}/.cache/jdtls/workspace"}}
                require'lspconfig'.tsserver.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server","--stdio"}}
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities.textDocument.completion.completionItem.snippetSupport = true
                require'lspconfig'.jsonls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver","--stdio"},capabilities=capabilities}
                require'lspconfig'.taplo.setup{capabilities=lsp_capabilities,cmd={"${pkgs.taplo}/bin/taplo","lsp","stdio"}}
                require'lspconfig'.lemminx.setup{capabilities=lsp_capabilities,cmd={"${pkgs.lemminx}/bin/lemminx"}}
                require'lspconfig'.psalm.setup{capabilities=lsp_capabilities,cmd={"${pkgs.php83Packages.psalm}/bin/psalm","--language-server"}}
                require'lspconfig'.intelephense.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.intelephense}/bin/intelephense","--stdio"}}
                require'lspconfig'.cssls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server","--stdio"}}
                -- require'lspconfig'.arduino_language_server.setup{capabilities=lsp_capabilities,cmd={"${pkgs.arduino-language-server}/bin/arduino-language-server"}}
                require'lspconfig'.rust_analyzer.setup{capabilities=lsp_capabilities,cmd={"rust-analyzer"}}
                require("bufferline").setup{}
                require("toggleterm").setup{open_mapping=[[<C-t>]],direction="float"}
                require("feline").setup()
                require("auto-session").setup{}
                require("autoclose").setup()
                -- require("stickybuf").setup()
                require("formatter").setup{
                    filetype={
                        python={function()return {exe="${pkgs.python312Packages.black}/bin/black",args={"-"},stdin=true} end},
                        haskell={function()return {exe="${pkgs.haskellPackages.fourmolu}/bin/fourmolu",args={"--no-cabal","-"},stdin=true} end},
                        java={function()return {exe="${pkgs.google-java-format}/bin/google-java-format",args={"-"},stdin=true} end},
                        javascript={function()return {exe="prettier",args={"--stdin-filepath=test.js"},stdin=true} end},
                        typescript={function()return {exe="prettier",args={"--stdin-filepath=test.ts"},stdin=true} end},
                        css={function()return {exe="prettier",args={"--stdin-filepath=test.css"},stdin=true} end},
                        json={function()return {exe="prettier",args={"--stdin-filepath=test.json"},stdin=true} end},
                        jsonc={function()return {exe="prettier",args={"--stdin-filepath=test.jsonc"},stdin=true} end},
                        yaml={function()return {exe="prettier",args={"--stdin-filepath=test.yml"},stdin=true} end},
                        markdown={function()return {exe="prettier",args={"--stdin-filepath=test.md"},stdin=true} end},
                        xml={function()return {exe="${pkgs.libxml2}/bin/xmllint",args={"--format","-"},stdin=true} end},
                        nix={function()return {exe="${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt",stdin=true} end},
                        bash={function()return {exe="${pkgs.shfmt}/bin/shfmt",stdin=true} end},
                        dockerfile={function()return {exe="${pkgs.dockfmt}/bin/dockfmt",args={"fmt"},stdin=true} end},
                        -- php={function()return {exe="${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt",stdin=true} end},
                        toml={function()return {exe="prettier",args={"--stdin-filepath=test.toml"},stdin=true} end},
                        arduino={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                        c={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                        cpp={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                        rust={function()return {exe="${pkgs.rustfmt}/bin/rustfmt",stdin=true} end},
                    }
                }
                vim.api.nvim_create_autocmd({'BufLeave'},{command='silent! wa'})
                require("Comment").setup{}
                require('mini.map').setup{integrations={require('mini.map').gen_integration.diagnostic()}}
                require("trouble").setup{icons=false,action_keys={jump={}}}
                vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
                local cmp=require("cmp")
                cmp.setup{
                snippet = {
                      -- REQUIRED - you must specify a snippet engine
                      expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
                      end,
                    },
                    sources={{name="nvim_lsp",keyword_length=1},},
                    window={
                        completion={
                            border="rounded",
                            winhighlight="Normal:CmpNormal",
                        },
                        documentation={
                            border="rounded",
                            winhighlight="Normal:CmpNormal",
                        },
                    },
                    formatting={fields={"menu","abbr","kind"},},
                    mapping={
                        ['<CR>']=cmp.mapping.confirm({select=false}),
                        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
                        ['<Down>'] = cmp.mapping.select_next_item(select_opts),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-d>'] = cmp.mapping.scroll_docs(4),
                        ['<esc>'] = cmp.mapping.abort(),
                    },
                }

                vim.opt.expandtab = true
                vim.opt.smartindent = true
                vim.opt.tabstop = 4
                vim.opt.shiftwidth = 4
                vim.opt.number = true
                -- vim.g.loaded_netrw = 1
                -- vim.g.loaded_netrwPlugin = 1
                -- vim.g.rnvimr_enable_ex=1
                vim.opt.incsearch = true
                vim.opt.shortmess:remove({ 'S' })
        	    vim.keymap.set('n', '<C-e>', '<cmd>RnvimrToggle<cr>')
        	    vim.keymap.set('n', '<C-k><C-f>', '<cmd>Format<cr>')
        	    vim.keymap.set('n', '<C-k><C-m>', '<cmd>TroubleToggle<cr>')
        	    vim.keymap.set('n', "<C-f>", '<cmd>Telescope live_grep<cr>')
        	    vim.keymap.set('n', "<C-g>", '<cmd>LazyGit<cr>')
        	    -- vim.keymap.set('n', "<C-w>", '<cmd>bd<cr>')
        	    vim.keymap.set('n', "gt", '<cmd>bn<cr>')
        	    vim.keymap.set('n', "gT", '<cmd>bp<cr>')
        	    -- vim.keymap.set('n', "<C-Tab>", '<cmd>bnext<cr>')
        	    vim.keymap.set('n', "<esc>", '<cmd>nohlsearch<cr>')
        	    vim.keymap.set('n', "<C-k><C-i>", vim.lsp.buf.hover)
                vim.keymap.set('n', '<C-k><C-r>', vim.lsp.buf.rename)
                vim.keymap.set('n', '<C-k><C-d>', vim.diagnostic.open_float)
                vim.keymap.set('n', 'mt', MiniMap.toggle)
        	    vim.keymap.set({'n','v'}, "<C-.>", vim.lsp.buf.code_action)
                function _G.set_terminal_keymaps()
                    local opts = {buffer = 0}
                    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                end
                vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()') 
                vim.env.NVIM_SERVER=vim.v.servername
                vim.api.nvim_set_hl(0, 'FloatBorder', {bg='#3B4252', fg='#5E81AC'})
                vim.api.nvim_set_hl(0, 'NormalFloat', {bg='#3B4252'})
                vim.api.nvim_set_hl(0, 'TelescopeNormal', {bg='#3B4252'})
                vim.api.nvim_set_hl(0, 'TelescopeBorder', {bg='#3B4252'})
                vim.g.rnvimr_enable_picker = 1
                vim.g.rnvimr_enable_ex = 1
                vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      '';
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        trouble-nvim
        bufferline-nvim
        toggleterm-nvim
        feline-nvim
        telescope-nvim
        nvim-treesitter.withAllGrammars
        lazygit-nvim
        auto-session
        vim-move
        nvim-cmp
        cmp-nvim-lsp
        markdown-preview-nvim
        autoclose-nvim
        pkgs.vimExtraPlugins.jupynium-nvim
        vim-illuminate
        ansible-vim
        vim-vsnip
        formatter-nvim
        rnvimr
        pkgs.vimExtraPlugins.Comment-nvim
        # codewindow-nvim
        mini-nvim
        (pkgs.vimUtils.buildVimPlugin {
          name = "stickybuf-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "stevearc";
            repo = "stickybuf.nvim";
            rev = "f3398f8639e903991acdf66e2d63de7a78fe708e";
            sha256 = "sha256-+ZcfItAtidLMQKSGJcU6EBlHbgHQGs/InQYxMknjnzw=";
          };
        })
      ];
      extraPackages = with pkgs; [
        haskell-language-server
        nodePackages.prettier-plugin-toml
        nodePackages.prettier
        ripgrep
        lazygit
        nodePackages.diagnostic-languageserver
        wl-clipboard
        gcc
        tree-sitter
        ghc
        jdt-language-server
        rust-analyzer
        # clang-tools
      ];
    };

    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = (with nix-vscode-extensions.extensions.x86_64-linux.open-vsx; [
        mads-hartmann.bash-ide-vscode
        jeff-hykin.better-cpp-syntax
        ms-python.black-formatter
        ms-vscode.cpptools-themes
        streetsidesoftware.code-spell-checker
        vscjava.vscode-java-debug
        ms-azuretools.vscode-docker
        # elmtooling.elm-ls-vscode
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
        # surendrajat.apklab
        loyieking.smalise
        hashicorp.hcl
        mechatroner.rainbow-csv
        janisdd.vscode-edit-csv
        redhat.ansible
        # shopify.ruby-lsp
        dhall.vscode-dhall-lsp-server
        dhall.dhall-lang
        bpruitt-goddard.mermaid-markdown-syntax-highlighting
        tomoyukim.vscode-mermaid-editor
        mkhl.direnv
        aaron-bond.better-comments
        # ms-vscode.makefile-tools
        vscodevim.vim
        vscjava.vscode-gradle
        ryanluker.vscode-coverage-gutters
        # codeium.codeium
        alexkrechik.cucumberautocomplete
      ]) ++ (with nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
        htmlhint.vscode-htmlhint
        visualstudioexptteam.vscodeintellicode
        ms-python.vscode-pylance
        ms-vscode.cpptools
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
        {
          "command" = "explorer.newFile";
          "key" = "ctrl+n";
        }
        {
          "command" = "workbench.action.toggleMaximizedPanel";
          "key" = "ctrl+shift+b";
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
        "git.autofetch" = true;
        "python.analysis.typeCheckingMode" = "strict";
        "editor.formatOnSave" = true;
        "git.enableCommitSigning" = true;
        "update.mode" = "none";
        "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
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
        "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python3";
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
        "[dockerfile]" = {
          "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
        };
        "java.configuration.runtimes" = [
          {
            "name" = "JavaSE-19";
            "path" = "${pkgs.jdk19}/lib/openjdk";
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
        "vsintellicode.modelDownloadPath" = "${home.homeDirectory}/.config/Code/User/intellicode";
        "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";
        "apklab.apkSignerPath" = "${home.homeDirectory}/.config/Code/User/apklab/uber-apk-signer-1.3.0.jar";
        "apklab.apktoolPath" = "${home.homeDirectory}/.config/Code/User/apklab/apktool_2.8.1.jar";
        "apklab.jadxDirPath" = "${home.homeDirectory}/.config/Code/User/apklab/jadx-1.4.7";
        "terminal.integrated.enablePersistentSessions" = false;
        "ansible.python.interpreterPath" = "${pkgs.python3}/bin/python3";
        "python.analysis.stubPath" = "/var/home/riky/backup/Documents/Projects/Python/common-stubs";
        "python.analysis.extraPaths" = [ "typings" ];
        "python.analysis.autoImportCompletions" = true;
        "ansible.ansible.path" = "${pkgs.ansible}/bin/ansible";
        "ansible.validation.lint.path" = "${pkgs.ansible-lint}/bin/ansible-lint";
        "vscode-dhall-lsp-server.executable" = "${pkgs.dhall-lsp-server}/bin/dhall-lsp-server";
        "rubyLsp.rubyVersionManager" = "custom";
        "rubyLsp.customRubyCommand" = "${pkgs.ruby.withPackages (ps: with ps; [ ruby-lsp ])}/bin/ruby";
        "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        "haskell.serverEnvironment" = {
          "PATH" = "${pkgs.busybox}/bin:${pkgs.ghc}/bin:${pkgs.haskellPackages.haskell-language-server}/bin";
        };
        "vim.handleKeys" = {
          "<C-w>" = false;
          "<C-k>" = false;
          "<C-d>" = true;
          "<C-s>" = false;
          "<C-z>" = false;
        };
        "codeium.enableConfig" = {
          "*" = false;
        };
      };
    };


    programs.nix-index.enable = true;

    programs.home-manager.enable = true;
    home.stateVersion = "22.05";
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; android_sdk.accept_license = true; }";
    home.enableNixpkgsReleaseCheck = true;

    news.display = "show";

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
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

    services.syncthing.enable = true;

    systemd.user.services = {
      startup = {
        Unit = { Description = "Startup"; };
        Service = { ExecStart = "bash ${./startup.sh}"; };
        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
      rclone = {
        Unit = {
          Description = "rclone";
        };
        Service = {
          ExecStart = "bash -c 'while ! host www.google.com; do sleep 5; done; ${pkgs.rclone}/bin/rclone copy --update ${home.homeDirectory}/backup/Syncthing drive:Syncthing'";
        };
        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
      keepass = {
        Unit = {
          Description = "KeepassXC";
        };
        Service = {
          ExecStart = "bash -c 'sleep 5; secret-tool lookup keepass password | flatpak run org.keepassxc.KeePassXC --pw-stdin ${home.homeDirectory}/backup/Syncthing/keepass.kdbx'";
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
      #cat = {
      #  Unit = { Description = "X11 Cat"; };
      #  Service = {
      #    ExecStart = "${pkgs.oneko}/bin/oneko -tora -bg 'dark gray'";
      #  };
      #  Install = { WantedBy = [ "gnome-session-x11-services.target" ]; };
      #};
    };

    home.file.".gdbinit".text = "source ${pkgs.gef}/share/gef/gef.py";
    home.file."Templates/emptyfile.txt".text = "";

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
      "path": "${pkgs.callPackage ./downloadhelper.nix { }}/bin/net.downloadhelper.coapp-linux-64",
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
      "path": "${./keepassxc-proxy}",
      "type": "stdio"
      }
    '';

    home.file.".var/app/io.gitlab.librewolf-community/.librewolf/native-messaging-hosts/net.downloadhelper.coapp.json".text = ''
      {
      "name": "net.downloadhelper.coapp",
      "description": "Video DownloadHelper companion app",
      "path": "${pkgs.callPackage ./downloadhelper.nix { }}/bin/net.downloadhelper.coapp-linux-64",
      "type": "stdio",
      "allowed_extensions": [
      "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}"
      ]
      }
    '';
    home.file.".var/app/io.gitlab.librewolf-community/.librewolf/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".text = ''
      {
      "allowed_extensions": [
      "keepassxc-browser@keepassxc.org"
      ],
      "description": "KeePassXC integration with native messaging support",
      "name": "org.keepassxc.keepassxc_browser",
      "path": "${./keepassxc-proxy}",
      "type": "stdio"
      }
    '';


    home.file.".local/bin/qemu".source = ./qemu.py;
    home.file.".local/bin/jupynvim".source = ./jupynvim.py;

    home.file.".local/flatpak/brave" = {
      text = "#!/usr/bin/env bash\nln -sfT $XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer $XDG_RUNTIME_DIR/kpxc_server && mkdir -p /etc/brave/policies/managed && ln -sfT ${./brave.jsonc} /etc/brave/policies/managed/brave.json && exec /app/bin/cobalt --ozone-platform-hint=auto --enable-features=WebContentsForceDark -incognito \"$@\"";
      executable = true;
    };

    home.file.".local/flatpak/librewolf" = {
      text = "#!/usr/bin/env bash\nln -sfT $XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer $XDG_RUNTIME_DIR/kpxc_server && exec /app/bin/librewolf \"$@\"";
      executable = true;
    };

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
      filesystems=xdg-documents;!host
      persistent=.android;Android;.local/share/gradle

      [Session Bus Policy]
      org.freedesktop.Flatpak=none
    '';
    home.file.".local/share/flatpak/overrides/com.obsproject.Studio".text = ''
      [Context]
      filesystems=!xdg-config/kdeglobals;xdg-videos;!host

      [Session Bus Policy]
      org.freedesktop.Flatpak=none
    '';
    home.file.".local/share/flatpak/overrides/com.userbottles.bottles".text = ''
      [Context]
      filesystems=!xdg-download
    '';
    home.file.".local/share/flatpak/overrides/io.dbeaver.DBeaverCommunity".text = ''
      [Context]
      sockets=!ssh-auth
      filesystems=!home
      persistent=.local/share/DBeaverData
    '';
    home.file.".local/share/flatpak/overrides/net.ankiweb.Anki".text = ''
      [Environment]
      ANKI_WAYLAND=1
    '';
    home.file.".local/share/flatpak/overrides/com.brave.Browser".text = ''
      [Context]
      filesystems=/nix/store:ro;xdg-run/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer:ro;~/.local/flatpak:ro;~/.nix-profile:ro;!xdg-desktop;!~/.local/share/icons;!xdg-run/dconf;!~/.config/dconf;!~/.config/kioslaverc;!~/.local/share/applications;!host-etc

      [Environment]
      PATH=${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin
    '';
    home.file.".local/share/flatpak/overrides/io.gitlab.librewolf-community".text = ''
      [Context]
      devices=all
      filesystems=/nix/store:ro;xdg-run/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer:ro;~/.local/flatpak:ro;~/.nix-profile:ro

      [Environment]
      PATH=${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin
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
    home.file.".local/share/flatpak/overrides/net.werwolv.ImHex".text = ''
      [Context]
      filesystems=!host
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.TextEditor".text = ''
      [Context]
      filesystems=!xdg-run/gvfsd;!host
    '';
    home.file.".local/share/flatpak/overrides/org.gnome.Totem".text = ''
      [Context]
      devices=!all
      filesystems=!xdg-run/gvfs;!xdg-run/gvfsd;!/run/media;!xdg-videos;!xdg-pictures;!xdg-download
    '';
    home.file.".local/share/flatpak/overrides/org.keepassxc.KeePassXC".text = ''
      [Context]
      devices=!all;dri
      filesystems=!xdg-config/kdeglobals;!/tmp;/nix/store:ro;!host;xdg-download;~/backup/Syncthing
    '';
    home.file.".local/share/flatpak/overrides/org.pitivi.Pitivi".text = ''
      [Context]
      filesystems=xdg-videos;!host
    '';
    home.file.".local/share/flatpak/overrides/org.remmina.Remmina".text = ''
      [Context]
      filesystems=!xdg-run/gvfsd;~/.ssh;!home;xdg-documents
      devices=!all;dri
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

    home.file.".local/nix-sources/flatpak.json".text = builtins.toJSON
      {
        flathub = {
          url = "https://flathub.org/repo/flathub.flatpakrepo";
          packages = [
            "org.gnome.TextEditor"
            "org.gnome.Characters"
            "org.gnome.Logs"
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
            "com.usebottles.bottles"
            "net.werwolv.ImHex"
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
            "org.gnome.Loupe"
            "org.remmina.Remmina"
            "com.brave.Browser"
            "org.gnome.SimpleScan"
            "io.github.flattool.Warehouse"
            "app.moosync.moosync"
            "org.polymc.PolyMC"
            "org.gimp.GIMP"
            "org.libreoffice.LibreOffice"
            "io.gitlab.librewolf-community"
            "eu.betterbird.Betterbird"
          ];
        };
        # flathub-beta = {
        #   url = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        #   packages = [ "org.gimp.GIMP" ];
        # };
      };

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
        clock-format = "24h";
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
      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.hm.gvariant.mkUint32 300;
        repeat-interval = lib.hm.gvariant.mkUint32 25;
      };
      "org/gnome/desktop/background" = {
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
        # move-to-monitor-left = [ ];
        # move-to-monitor-right = [ ];
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
        # switch-to-workspace-left = [ "<Alt>j" ];
        # switch-to-workspace-right = [ "<Alt>k" ];
        close = [ "<Super>q" ];
        # move-to-workspace-left = [ "<Alt>Left" ];
        # move-to-workspace-right = [ "<Alt>Right" ];
        # move-to-workspace-left = [ ];
        # move-to-workspace-right = [ ];
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":close";
      };
      "org/gnome/mutter/keybindings" = {
        # toggle-tiled-left = [ "<Control><Alt>Left" ];
        # toggle-tiled-right = [ "<Control><Alt>Right" ];
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        # custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" ];
        # next = [ "<Super>Right" ];
        play = [ "<Super>space" ];
        # previous = [ "<Super>Left" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Shift><Super>p";
        command = "gnome-session-quit --power-off";
        name = "Poweroff";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>Return";
        command = "foot";
        name = "Terminal";
      };
      # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      #   binding = "<Control><Alt>b";
      #   command = "flatpak run com.brave.Browser";
      #   name = "Browser";
      # };
      # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      #   binding = "<Control><Alt>v";
      #   command = "flatpak run com.vscodium.codium";
      #   name = "VSCode";
      # };
      "org/gnome/settings-daemon/plugins/power" = {
        idle-brightness = 20;
        power-button-action = "nothing";
        sleep-inactive-battery-timeout = 300;
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          "compiz-alike-magic-lamp-effect@hermes83.github.com"
          "compiz-windows-effect@hermes83.github.com"
          "AlphabeticalAppGrid@stuarthayhurst"
          "caffeine@patapon.info"
          "burn-my-windows@schneegans.github.com"
          "system-monitor-indicator@mknap.com"
          "stopwatch@aliakseiz.github.com"
          "gnome-one-window-wonderland@jqno.nl"
        ];
        favorite-apps = [ "io.gitlab.librewolf-community.desktop" "org.gnome.Nautilus.desktop" "org.codeberg.dnkl.foot.desktop" ];
      };
      "org/gnome/desktop/privacy" = {
        remove-old-trash-files = true;
        remove-old-temp-files = true;
        old-files-age = 30;
      };
      "org/gnome/shell/extensions/burn-my-windows" = {
        active-profile = toString ./window-animation.conf;
      };
      "org/gnome/shell/extensions/caffeine" = {
        show-notifications = false;
      };
    };

    nix = {
      enable=true;
      package = pkgs.nix;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        build-users-group = "nixbld";
        auto-optimise-store = true;
        bash-prompt-prefix = "(nix:$name)\\040";
        max-jobs = "auto";
        extra-nix-path = "nixpkgs=flake:nixpkgs";
      };
        # registry.local = {
        #   from = { type = "indirect"; id = "nixpkgs"; };
        #   flake = nixpkgs;
        # };
    };

    home.activation = {
      setup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rmdir "$HOME/Documents" > /dev/null 2> /dev/null || true
        ln -sfT "$HOME/backup/id_ed25519" "$HOME/.ssh/id_ed25519"
        ln -sfT "$HOME/backup/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
        chmod 600 "$HOME/.ssh/id_ed25519"
        ln -sfT "$HOME/.nix-profile/share/gnome-shell/extensions" "$HOME/.local/share/gnome-shell/extensions"
        ln -sfT "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
        ln -sfT "$HOME/.nix-profile/share/icons" "$HOME/.local/share/icons"
        
        systemctl enable --user podman.socket
        systemctl --user mask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
        ${pkgs.python3}/bin/python3 ${./flatpak-switch.py}
        if [ ! -d ${nix-vscode-extensions.extensions.x86_64-linux.open-vsx.ms-toolsai.jupyter}/share/vscode/extensions/ms-toolsai.jupyter/temp ]; then
          sudo mkdir ${nix-vscode-extensions.extensions.x86_64-linux.open-vsx.ms-toolsai.jupyter}/share/vscode/extensions/ms-toolsai.jupyter/temp
          sudo chown $USER:$USER ${nix-vscode-extensions.extensions.x86_64-linux.open-vsx.ms-toolsai.jupyter}/share/vscode/extensions/ms-toolsai.jupyter/temp
        fi
      '';
    };
  };

in
homeManager
