{ config, pkgs, lib, pwndbg, ... }:

let
  homeManager = rec {

    manual.html.enable = false;
    manual.manpages.enable = true;
    manual.json.enable = false;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "riky";
    home.homeDirectory = "/home/riky";
    targets.genericLinux.enable = true;

    services.home-manager.autoExpire.enable = true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      less
      tldr
      man-pages
      man-pages-posix
      dust
      dua
      fd
      procs
      p7zip
      curlie
      xh
      netcat-openbsd
      iputils
      binutils
      fira-code
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      powertop
      android-tools
      nmap
      exiftool
      imagemagick
      brightnessctl
      traceroute
      xdg-ninja
      python313Packages.ipython
      pre-commit
      git-ignore
      ascii
      w3m
      fastfetch
      pamixer
      pavucontrol
      brightnessctl
      playerctl
      trash-cli
      wl-clipboard
      nixVersions.latest
      rclone
      rsync
      mpc
      clock-rs
      yt-dlp
      jq
      yq
      libnotify
      timg
      ffmpeg
      uutils-coreutils-noprefix
      wev
      zip
      unzip
      # pwndbg.packages.x86_64-linux.pwndbg
    ];

    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
      };
    };
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.lazygit.enable = true;

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      mouse = true;
      prefix = "C-s";
      shell = "${pkgs.fish}/bin/fish";
      extraConfig = ''
                bind-key -T copy-mode-vi 'v' send -X begin-selection
                bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel\; run "tmux save -|wl-copy"
                bind '"' split-window -c "#{pane_current_path}"
                bind % split-window -h -c "#{pane_current_path}"
                bind c new-window -c "#{pane_current_path}"
                bind-key @ choose-tree "join-pane -h -s '%%'"
                bind-key C-@ choose-tree "join-pane -s '%%'"
                bind-key ! break-pane -d
                bind-key C-! break-pane
                bind-key -n Pageup send-keys left
                bind-key -n Pagedown send-keys right
                bind-key C-V run "wl-paste -n | tmux load-buffer - ; tmux paste-buffer"
                bind h select-pane -L
                bind j select-pane -D
                bind k select-pane -U
                bind l select-pane -R
                bind H swap-pane -U
                bind J swap-pane -D
                bind K swap-pane -U
                bind L swap-pane -D
                set-window-option -g mode-keys vi
                set-option -sa terminal-features ',foot:RGB'
                set-option -sg escape-time 10

                bind P swap-window -t -1\; select-window -t -1
                bind N swap-window -t +1\; select-window -t +1

                set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha
                set -g @catppuccin_window_status_style "rounded"
                set -g status-left ""
                set -g status-right ""
                set -ogq @catppuccin_window_text " #{b:pane_current_path}"
                set -ogq @catppuccin_window_current_text " #{b:pane_current_path}"
                run ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

        # Ensure that everything on the right side of the status line
        # is included.
                set -g status-right-length 100

                set -g allow-passthrough on

                set -g copy-command '${pkgs.wl-clipboard}/bin/wl-copy'

                bind-key -T copy-mode-vi "o" send-keys -X copy-pipe-and-cancel "sed s/##/####/g | xargs -I {} tmux run-shell -b 'cd #{pane_current_path}; xdg-open \"{}\" > /dev/null'"
      '';
    };
    programs.htop.enable = true;
    programs.yazi = {
      enable = true;
      flavors = {
        catppuccin-mocha = ./catppuccin-mocha.yazi;
      };
      theme = {
        flavor = {
          dark = "catppuccin-mocha";
        };
      };
      plugins = {
        smart-enter = pkgs.yaziPlugins.smart-enter;
        folder-rules = ./yazi;
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "<Right>";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "<Backspace>";
            run = "hidden toggle";
            desc = "Show hidden files";
          }
          {
            on = "q";
            run = "close";
            desc = "Close current tab";
          }
          {
            on = "e";
            run = "shell -- /usr/bin/flatpak run --file-forwarding org.gimp.GIMP @@ \"$@\" @@";
          }
        ];
      };
      settings = {
        opener = {
          edit = [
            {
              run = "\${EDITOR:-vi} \"$@\"";
              desc = "$EDITOR";
              block = true;
            }
          ];
          open = [
            { run = "xdg-open \"$1\""; desc = "Open"; }
          ];
        };
        open = {
          rules = [
            { mime = "text/*"; use = "edit"; }
            { mime = "{audio,image,video}/*"; use = "open"; }
            { mime = "application/{json,ndjson}"; use = "edit"; }
            { mime = "*/javascript"; use = "edit"; }
            { mime = "inode/empty"; use = "edit"; }
            { name = "*"; use = "open"; }
          ];
        };
      };
      initLua = ''require("folder-rules"):setup()'';
    };


    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.local/share/flatpak/exports/bin" ];

    home.sessionVariables = {
      PAGER = "less";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      DIFFPROG = "${home.homeDirectory}/.nix-profile/bin/nvim -d";
      EDITOR = "${home.homeDirectory}/.nix-profile/bin/nvim";
      VISUAL = "$EDITOR";
      SUDO_EDITOR = "$VISUAL";
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
      NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = "1";
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
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
      XCURSOR_THEME = "Bibata-Modern-Amber";
      XCURSOR_SIZE = "36";
      MPD_HOST = "/run/user/1000/mpd/socket";
      RESTIC_PASSWORD_COMMAND = "password show -a password 'Backup decryption pw'";
      RESTIC_REPOSITORY = "/run/media/riky/90304ff6-a81a-4307-be0f-ab65846845ea/backup";
      RESTIC_REPOSITORY2 = "/run/media/riky/Hard\ Disk/backup";
      NIX_CONFIG_FOLDER = "${home.homeDirectory}/backup/Documents/config";
      RCLONE_CONFIG = "${home.homeDirectory}/backup/rclone.conf";
      RCLONE_PASSWORD_COMMAND = "password show -a Password rclone";
    };

    fonts.fontconfig.enable = true;
    programs.bat.enable = true;
    programs.ripgrep.enable = true;
    programs.zoxide.enable = true;
    programs.eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
    programs.fzf.enable = true;
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    programs.man = {
      enable = true;
    };
    programs.direnv.enable = true;

    programs.distrobox.enable = true;
    home.file.".config/distrobox/distrobox.conf".text = ''
      container_generate_entry=0
      container_manager="podman"
      container_image_default="quay.io/toolbx/ubuntu-toolbox:latest"
      container_name_default="test"
    '';

    home.shell = {
      enableShellIntegration = true;
      enableFishIntegration = true;
    };
    programs.fish = {
      enable = true;
      generateCompletions = true;
      shellAliases = {
        cat = "bat -p";
        du = "dust";
        find = "fd";
        ps = "procs";
        curl = "curlie";
        wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
        nix = "LD_LIBRARY_PATH='' nix=(which nix) $nix";
        neofetch = "fastfetch";
        flake-init = "nix flake init -t github:nix-community/nix-direnv";
        music-update = "nix run ${home.homeDirectory}/backup/Documents/Projects/Python/musicmanager auto Music Music2 Music3 Music4 Bardify Clownpierce Dream FlameFrags Halloween Wemmbu";
        timg = "timg -ps";
        gh = "GH_TOKEN=$(password show -a 'gh token' Github) gh=(which gh) $gh";
        cb = "${pkgs.forgejo-cli}/bin/fj -H codeberg.org";
        # yt = ''(){file="$(mktemp)" && yt-dlp --force-overwrite -xo "$file" "$1" && mpc add "$file"* }'';
      };
      functions = {
        fish_greeting.body = "";
        fish_user_key_bindings.body = ''
          fish_default_key_bindings -M insert
          fish_vi_key_bindings --no-erase insert
        '';
        envsource = ''
          for line in (cat $argv | grep -v '^#')
              set item (string split -m 1 '=' $line)
              set -gx $item[1] ( echo $item[2] | tr -d '"' )
              echo "Exported key $item[1]"
          end
        '';
      };
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
        right_format = "$all";
        format = "$directory$git_branch$git_commit$git_state$git_metrics$git_status$character";
      };
      enableTransience = true;
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraLuaConfig = ''
        vim.opt.termguicolors = true
        local lsp_capabilities=require("cmp_nvim_lsp").default_capabilities()
        vim.lsp.config("basedpyright",{capabilities=lsp_capabilities,cmd={"${pkgs.basedpyright}/bin/basedpyright-langserver","--stdio"},settings={basedpyright={analysis={typeCheckingMode="strict",stubPath="${home.homeDirectory}/backup/Documents/Projects/Python/common-stubs",extraPaths={"typings"}}}}})
        vim.lsp.enable("basedpyright")
        vim.lsp.config("ruff",{capabilities=lsp_capabilities,cmd={"${pkgs.ruff}/bin/ruff","server","--preview"}})
        vim.lsp.enable("ruff")
        vim.lsp.config("nil_ls",{capabilities=lsp_capabilities,cmd={"${pkgs.nil}/bin/nil"}})
        vim.lsp.enable("nil_ls")
        vim.lsp.config("bashls",{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server","start"}})
        vim.lsp.enable("bashls")
        vim.lsp.config("hls",{capabilities=lsp_capabilities,cmd={"haskell-language-server-wrapper","--lsp"}})
        vim.lsp.enable("hls")
        vim.lsp.config("dockerls",{capabilities=lsp_capabilities,cmd={"${pkgs.dockerfile-language-server}/bin/docker-langserver","--stdio"}})
        vim.lsp.enable("dockerls")
        vim.lsp.config("yamlls",{capabilities=lsp_capabilities,cmd={"${pkgs.yaml-language-server}/bin/yaml-language-server","--stdio"}})
        vim.lsp.enable("yamlls")
        vim.lsp.config("jdtls",{capabilities=lsp_capabilities,cmd={"${pkgs.jdt-language-server}/bin/jdtls", "-configuration", "${home.homeDirectory}/.cache/jdtls/config", "-data", "${home.homeDirectory}/.cache/jdtls/workspace"}})
        vim.lsp.enable("jdtls")
        vim.lsp.config("kotlin_language_server",{capabilities=lsp_capabilities,cmd={"${pkgs.kotlin-language-server}/bin/kotlin-language-server"}})
        vim.lsp.enable("kotlin_language_server")
        vim.lsp.config("ts_ls",{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server","--stdio"}})
        vim.lsp.enable("ts_ls")
        vim.lsp.config("eslint",{capabilities=lsp_capabilities,cmd={"${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server","--stdio"}})
        vim.lsp.enable("eslint")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        vim.lsp.config("jsonls",{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver","--stdio"},capabilities=capabilities})
        vim.lsp.enable("jsonls")
        vim.lsp.config("taplo",{capabilities=lsp_capabilities,cmd={"${pkgs.taplo}/bin/taplo","lsp","stdio"}})
        vim.lsp.enable("taplo")
        vim.lsp.config("lemminx",{capabilities=lsp_capabilities,cmd={"${pkgs.lemminx}/bin/lemminx"}})
        vim.lsp.enable("lemminx")
        vim.lsp.config("psalm",{capabilities=lsp_capabilities,cmd={"${pkgs.php83Packages.psalm}/bin/psalm","--language-server"}})
        vim.lsp.enable("psalm")
        vim.lsp.config("intelephense",{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.intelephense}/bin/intelephense","--stdio"}})
        vim.lsp.enable("intelephense")
        vim.lsp.config("cssls",{capabilities=lsp_capabilities,cmd={"${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server","--stdio"}})
        vim.lsp.enable("cssls")
        vim.lsp.config("rust_analyzer",{capabilities=lsp_capabilities,cmd={"rust-analyzer"}})
        vim.lsp.enable("rust_analyzer")
        vim.lsp.config("dartls",{capabilities=lsp_capabilities,cmd={"${pkgs.dart}/bin/dart","language-server","--protocol=lsp"}})
        vim.lsp.enable("dartls")
        vim.lsp.config("ltex_plus",{capabilities=lsp_capabilities,cmd={"${pkgs.ltex-ls-plus}/bin/ltex-ls-plus"},settings={ltex={language="en-US"},additionalRules={languageModel="${home.homeDirectory}/.ngrams"}}})
        vim.lsp.enable("ltex_plus")
        vim.lsp.config("dhall_lsp_server",{capabilities=lsp_capabilities,cmd={"${pkgs.dhall-lsp-server}/bin/dhall-lsp-server"}})
        vim.lsp.enable("dhall_lsp_server")
        vim.lsp.config("clangd",{capabilities=lsp_capabilities,cmd={"${pkgs.clang-tools}/bin/clangd"}})
        vim.lsp.enable("clangd")
        vim.lsp.config("solargraph",{capabilities=lsp_capabilities,cmd={"${pkgs.rubyPackages.solargraph}/bin/solargraph","stdio"}})
        vim.lsp.enable("solargraph")
        vim.lsp.config("csharp_ls",{capabilities=lsp_capabilities,cmd={"${pkgs.csharp-ls}/bin/csharp-ls"}})
        vim.lsp.enable("csharp_ls")
        vim.lsp.config("astro",{capabilities=lsp_capabilities,cmd={"${pkgs.astro-language-server}/bin/astro-ls","--stdio"},init_options={typescript={tsdk="${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"}}})
        vim.lsp.enable("astro")
        vim.lsp.config("csharp_ls",{capabilities=lsp_capabilities,cmd={"${pkgs.csharp-ls}/bin/csharp-ls"}})
        vim.lsp.enable("csharp_ls")

        require("lualine").setup()
        require('nvim-autopairs').setup{}
        require("formatter").setup{
            filetype={
                python={function()return {exe="${pkgs.ruff}/bin/ruff",args={"format","-"},stdin=true} end},
                haskell={function()return {exe="${pkgs.haskellPackages.fourmolu}/bin/fourmolu",args={"--no-cabal","-"},stdin=true} end},
                java={function()return {exe="${pkgs.google-java-format}/bin/google-java-format",args={"-"},stdin=true} end},
                kotlin={function()return {exe="${pkgs.ktfmt}/bin/ktfmt",args={"-"},stdin=true} end},
                javascript={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.js"},stdin=true} end},
                typescript={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.ts"},stdin=true} end},
                typescriptreact={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.tsx"},stdin=true} end},
                css={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.css"},stdin=true} end},
                json={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.json"},stdin=true} end},
                jsonc={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.jsonc"},stdin=true} end},
                yaml={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.yml"},stdin=true} end},
                markdown={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--stdin-filepath=test.md"},stdin=true} end},
                xml={function()return {exe="${pkgs.html-tidy}/bin/tidy",args={"-i","-xml"},stdin=true} end},
                html={function()return {exe="${pkgs.html-tidy}/bin/tidy",args={"-i"},stdin=true} end},
                nix={function()return {exe="${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt",stdin=true} end},
                bash={function()return {exe="${pkgs.shfmt}/bin/shfmt",stdin=true} end},
                dockerfile={function()return {exe="${pkgs.dockerfmt}/bin/dockerfmt",stdin=true} end},
                toml={function()return {exe="${pkgs.taplo}/bin/taplo",args={"fmt","-"},stdin=true} end},
                arduino={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                c={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                cpp={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                rust={function()return {exe="${pkgs.rustfmt}/bin/rustfmt",stdin=true} end},
                dart={function()return {exe="${pkgs.dart}/bin/dart",args={"format"},stdin=false} end},
                dhall={function()return {exe="${pkgs.dhall}/bin/dhall",args={"format"},stdin=true} end},
                just={function()return {exe="${pkgs.just}/bin/just",args={"--dump"},stdin=true} end},
                ruby={function()return {exe="${pkgs.rufo}/bin/rufo",args={"--simple-exit"},stdin=true} end},
                cs={function()return {exe="${pkgs.csharpier}/bin/dotnet-csharpier",stdin=true} end},
                astro={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--plugin=${pkgs.vscode-extensions.astro-build.astro-vscode}/share/vscode/extensions/astro-build.astro-vscode/node_modules/prettier-plugin-astro/dist/index.js","--stdin-filepath=test.astro"},stdin=true} end},
            }
        }
        vim.api.nvim_create_autocmd({'BufLeave'},{command='silent! wa'})
        require('mini.map').setup{integrations={require('mini.map').gen_integration.diagnostic()}}
        require("trouble").setup{icons={},warn_no_results = false,open_no_results = true,preview={type="main",size={width=0.8}}}
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
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },
          matchup={enable=true},
        }
        require('gitblame').setup {
            enabled = true,
            message_when_not_committed = ""
        }
        require('gitsigns').setup()
        require('yazi').setup({open_for_directories = true})
        require('nvim-ts-autotag').setup()
        require("nvim-surround").setup()
        -- require('leap').set_default_mappings()
        -- require('nvim_context_vt').setup()
        require("hardtime").setup{restriction_mode="hint"}
        vim.notify = require("notify")
        require('flash').setup{}
        require('boole').setup{
          mappings = {
              increment = '<C-a>',
              decrement = '<C-x>'
            },
        }

        vim.opt.expandtab = true
        vim.opt.smartindent = true
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.number = true
        vim.opt.incsearch = true
        vim.opt.shortmess:remove({ 'S' })
        vim.opt.colorcolumn = "90"
        vim.opt.list = true
        vim.wo.relativenumber = true
        vim.keymap.set('n', '<Leader>e', '<cmd>Yazi<cr>')
        vim.keymap.set('n', '<Leader>f', '<cmd>Format<cr>')
        vim.keymap.set('n', '<Leader>m', '<cmd>Trouble diagnostics toggle focus=true<cr>')
        vim.keymap.set('n', "<Leader>/", '<cmd>Telescope live_grep<cr>')
        vim.keymap.set('n', "<Leader>l", '<cmd>Telescope find_files<cr>')
        vim.keymap.set('n', "<Leader>g", '<cmd>LazyGit<cr>')
        vim.keymap.set('n', "<esc>", '<cmd>nohlsearch<cr>')
        -- vim.keymap.set('n', "<Leader>i", vim.lsp.buf.hover)
        vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename)
        -- vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float)
        vim.keymap.set('n', '<Leader>o', MiniMap.toggle)
        vim.keymap.set({'n','v'}, "<Leader>.", vim.lsp.buf.code_action)
        vim.keymap.set("n","s",function() require("flash").jump() end)
        -- function _G.set_terminal_keymaps()
        --     local opts = {buffer = 0}
        --     vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        -- end
        -- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        -- vim.env.NVIM_SERVER=vim.v.servername
        vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        vim.cmd [[colorscheme tokyonight-night]]
        vim.o.splitright=true
        vim.o.splitbelow=true
        -- vim.api.nvim_create_autocmd('TermOpen', {
        --     pattern = { '*' },
        --     callback = function()
        --         vim.opt.number = false
        --     end,
        --     group = generalSettingsGroup,
        -- })
        vim.cmd [[highlight DiagnosticUnderlineError ctermfg=red guifg=red]]
        vim.cmd [[highlight DiagnosticUnderlineWarn ctermfg=yellow guifg=yellow]]
        vim.cmd [[highlight DiagnosticUnderlineInfo ctermfg=lightblue guifg=lightblue]]
        -- vim.cmd [[highlight DiagnosticUnderlineHint ctermfg=red guifg=red]]

        -- vim.keymap.set({"n","v"},"hh","<nop>")
        -- vim.keymap.set({"n","v"},"ll","<nop>")
        vim.keymap.set({"n","v","i"},"<Up>","<nop>")
        vim.keymap.set({"n","v","i"},"<Down>","<nop>")
        vim.keymap.set({"n","v","i"},"<Left>","<nop>")
        vim.keymap.set({"n","v","i"},"<Right>","<nop>")
        -- vim.keymap.set("n","x","<nop>")
        -- vim.keymap.set("i","<BS>","<nop>")
        -- vim.keymap.set("i","<Del>","<nop>")
        vim.keymap.set("i","jk","<Esc>")
      '';

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        trouble-nvim
        lualine-nvim
        telescope-nvim
        nvim-treesitter.withAllGrammars
        nvim-cmp
        cmp-nvim-lsp
        vim-illuminate
        vim-vsnip
        formatter-nvim
        yazi-nvim
        vim-commentary
        mini-nvim
        vim-abolish
        dhall-vim
        git-blame-nvim
        gitsigns-nvim
        nvim-ts-autotag
        nvim-surround
        vim-repeat
        twilight-nvim
        hardtime-nvim
        nvim-notify
        nvim-autopairs
        vim-speeddating
        boole-nvim
        rainbow-delimiters-nvim
        vim-matchup
        flash-nvim
        tokyonight-nvim
      ];
      extraPackages = with pkgs; [
        haskell-language-server
        ripgrep
        nodePackages.diagnostic-languageserver
        wl-clipboard
        gcc
        tree-sitter
        ghc
        jdt-language-server
        rust-analyzer
      ];
    };

    home.file."${config.xdg.configHome}/nvim/spell/it.utf-8.spl".source = builtins.fetchurl
      {
        url = "https://vim.mirror.garr.it/pub/vim/runtime/spell/it.utf-8.spl";
        sha256 = "d80733903e836d53790c0ab8c1c2f29f663ca2a77aee7b381aea6b8762ae7413";
      };
    home.file."${config.xdg.configHome}/nvim/spell/it.utf-8.sug".source = builtins.fetchurl
      {
        url = "https://vim.mirror.garr.it/pub/vim/runtime/spell/it.utf-8.sug";
        sha256 = "e0bb1761a79270926b75a8faf4f4d0d840d55a2b34518fd8e512927c2724ce4a";
      };

    programs.nix-index.enable = true;

    programs.home-manager.enable = true;
    home.stateVersion = "22.05";
    xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; android_sdk.accept_license = true; }";
    home.enableNixpkgsReleaseCheck = false;


    news.display = "show";

    xdg = {
      enable = true;
      userDirs = {
        createDirectories = true;
        enable = true;
        documents = "${home.homeDirectory}/backup/Documents";
        music = "${home.homeDirectory}/backup/phone/Music";
      };
      portal = {
        config.common.default = "hyprland;gtk";
      };

    };

    home.file.".gdbinit".text = ''
      source ${pkgs.gef}/share/gef/gef.py
      set history filename ~/.local/state/gdb_history
    '';

    programs.poetry = {
      enable = true;
      package = null;
      settings = {
        virtualenvs.in-project = true;
      };
    };

    nix = {
      enable = true;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        # build-users-group = "nixbld";
        # auto-optimise-store = true;
        bash-prompt-prefix = "(nix:$name)\\040";
        max-jobs = "auto";
        extra-nix-path = "nixpkgs=flake:nixpkgs";
      };
      # registry.local = {
      #   from = { type = "indirect"; id = "nixpkgs"; };
      #   flake = nixpkgs;
      # };
    };

  };

in
homeManager
