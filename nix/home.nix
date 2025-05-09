{ config, pkgs, lib, nix-vscode-extensions, ... }:

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
      du-dust
      fd
      procs
      p7zip
      curlie
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
      bluetuith
      fastfetch
      pamixer
      pavucontrol
      brightnessctl
      playerctl
      trash-cli
      distrobox
      wl-clipboard
      nixVersions.latest
      rclone
      rsync
      mpc-cli
      clock-rs
      yt-dlp
      jq
      yq
      libnotify
      timg
      ffmpeg
      restic
    ];

    accounts = {
      calendar = {
        basePath = "${home.homeDirectory}/backup/Calendar";
        accounts = builtins.mapAttrs
          (name: value: {
            remote = {
              type = "caldav";
              url = "http://127.0.0.1:5232";
              userName = "t";
              passwordCommand = [ "echo" "t" ];
            };
            vdirsyncer = {
              enable = true;
              collections = [ value.collection ];
            };
            khal = {
              enable = true;
              readOnly = true;
              type = "discover";
              color = value.color;
            };
          })
          {
            creativity = { collection = "calendars-51ebc243-e08c-4cfb-b3c5-9e58c6c33dc0"; color = "yellow"; };
            friends = { collection = "calendars-85c59956-f652-4410-89e4-57cf8d55b17f"; color = "light cyan"; };
            survival = { collection = "calendars-88424f24-751c-49b2-8783-2218dc5d2dcd"; color = "light blue"; };
            health = { collection = "calendars-53019f4a-8f2a-4809-aeba-d22c4c393fc5"; color = "light magenta"; };
            tasks = { collection = "calendars-d87a7978-7196-4208-a861-fcaeb09d39a7"; color = "light red"; };
            transports = { collection = "calendars-c97798c1-8ec6-484e-8a28-52e41109b474"; color = "dark magenta"; };
            work = { collection = "calendars-fad4fc34-12ee-4f75-98ed-2f77eb2a6419"; color = "light green"; };
          };
      };
      email = {
        maildirBasePath = "${home.homeDirectory}/backup/Mail";
        accounts = {
          disroot = {
            address = "rikyiso01@disroot.org";
            userName = "rikyiso01";
            getmail = {
              enable = true;
              readAll = false;
              delete = false;
              mailboxes = [ "Archive" ];
            };
            imap = {
              host = "disroot.org";
              port = 993;
              tls.enable = true;
            };
            neomutt = {
              enable = true;
              mailboxType = "imap";
              extraConfig = ''set imap_pass="`${home.homeDirectory}/.local/bin/password show -a password Disroot`"'';
            };
            passwordCommand = [ "${home.homeDirectory}/.local/bin/password" "show" "-a" "password" "Disroot" ];
            realName = "Riccardo";
            smtp = {
              host = "disroot.org";
              port = 465;
              tls.enable = true;
            };
          };
          gmail = {
            primary = true;
            address = "riky.isola@gmail.com";
            userName = "riky.isola";
            # getmail = {
            #   enable = true;
            #   readAll = true;
            #   mailboxes = [ "ALL" ];
            # };
            neomutt = {
              enable = true;
              mailboxType = "imap";
              extraConfig = ''set imap_pass="`${home.homeDirectory}/.local/bin/password show -a 'getmail password' Google`"'';
            };
            passwordCommand = [ "${home.homeDirectory}/.local/bin/password" "show" "-a" "'getmail password'" "Google" ];
            realName = "Riccardo";
            flavor = "gmail.com";
          };
        };
      };
    };

    programs.neomutt = {
      enable = true;
      macros = [{
        key = "V";
        map = [ "attach" ];
        action = "<pipe-entry>iconv -c --to-code=UTF8 > ~/.cache/neomutt/mail.html<enter><shell-escape>xdg-open ~/.cache/neomutt/mail.html<enter>";
      }];
    };
    programs.vdirsyncer.enable = true;
    services.vdirsyncer.enable = true;
    programs.khal = {
      enable = true;
      settings = {
        default = {
          highlight_event_days = true;
          timedelta = "1d";
        };
        view = {
          dynamic_days = false;
        };
      };
      locale = {
        dateformat = "%d/%m/%y";
        datetimeformat = "%d/%m/%y %H:%M";
        longdateformat = "%d/%m/%y";
        longdatetimeformat = "%d/%m/%y %H:%M";
        timeformat = "%H:%M";
      };
    };
    programs.todoman.enable = true;

    programs.git = {
      enable = true;
      userName = "rikyiso01";
      userEmail = "31405152+rikyiso01@users.noreply.github.com";
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRI8KdIpS8+g0IwxfzmrCBP4m7XWj0KECBz42WkgwsG";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        gpg.format = "ssh";
        credential.helper = "${pkgs.git-credential-keepassxc}/bin/git-credential-keepassxc --git-groups";
      };
      includes = [
        {
          condition = "gitdir:~/backup/Documents/School/";
          contents = {
            user = {
              name = "rikyiso01";
              email = "4943369@studenti.unige.it";
              signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlqN7rO/To4JJjxYrljVmVWPsv7qSPwa+yQVsv0ahCq";
            };
          };
        }
      ];
    };

    programs.zellij = {
      enable = true;
      settings = {
        default_shell = "fish";
        show_startup_tips = false;
        copy_command = "wl-copy";
        pane_frames = false;
        default_layout = "default";
        session_serialization = false;
        ui.pane_frames.hide_session_name = true;
        keybinds = {
          "normal clear-defaults=true" = {
            "bind \"Ctrl s\"" = { SwitchToMode = "Tmux"; };
          };
          tmux = builtins.listToAttrs (builtins.map (x: { name = "bind \"${toString x}\""; value = { GoToTab = x; SwitchToMode = "Normal"; }; }) [ 1 2 3 4 5 6 7 8 9 ]);
        };
      };
    };
    xdg.configFile."zellij/layouts/startup.kdl".text = ''
      layout {
          new_tab_template {
              pane
              pane size=1 borderless=true {
                    plugin location="tab-bar"
                }
          }
          tab {
              pane command="yazi" close_on_exit=true
              pane size=1 borderless=true {
                    plugin location="compact-bar"
                }
          }
      }
    '';
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      mouse = true;
      prefix = "C-s";
      shell = "${pkgs.fish}/bin/fish";
      # plugins = with pkgs.tmuxPlugins; [ catppuccin ];
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
                set-window-option -g mode-keys vi
                set-option -sa terminal-features ',foot:RGB'
                set-option -sg escape-time 10

                set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha
                set -g @catppuccin_window_status_style "rounded"
                set -g status-left ""
                set -g status-right ""
                set -ogq @catppuccin_window_text " #{pane_current_command}"
                set -ogq @catppuccin_window_current_text " #{pane_current_command}"
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
    nixpkgs.overlays = [
      (self: super: {
        # Use ranger PR, fixes freeze after opening image in kitty: https://github.com/ranger/ranger/pull/2856
        ranger = super.ranger.overrideAttrs (old: {
          version = "1.9.3";
          src = super.fetchFromGitHub {
            owner = "Ethsan";
            repo = "ranger";
            rev = "71a06f28551611d192d3e644d95ad04023e10801";
            sha256 = "sha256-Yjdn1oE5VtJMGnmQ2VC764UXKm1PrkIPXXQ8MzQ8u1U=";
          };
          propagatedBuildInputs = old.propagatedBuildInputs ++ (with super.python3Packages; [ astroid pylint ]);
        });
      })
    ];
    programs.yazi = {
      enable = true;
      plugins = { smart-enter = pkgs.yaziPlugins.smart-enter; };
      keymap = {
        manager.prepend_keymap = [
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
        ];
      };
    };
    programs.ranger = {
      enable = true;
      extraConfig = ''
        map dT shell ${pkgs.trash-cli}/bin/trash-put %s
        map dD shell ${pkgs.trash-cli}/bin/trash-put %s
        map O shell xdg-mime default $(${pkgs.gnused}/bin/sed -n '1{p;q}').desktop $(xdg-mime query filetype %s)
        setlocal path=~/Downloads sort mtime
        set preview_images true
        set preview_images_method kitty
      '';
    };
    home.file.".config/ranger/rifle.conf".text = ''
      mime application/zip, flag f = /bin/unzip "$1"
      !mime ^application/json|^text|^inode,!ext sh,!ext sql,!ext pl,!ext js,!ext tsx,!ext rs,!ext dart,!ext tex,!ext mmd,!ext jsonl,!ext astro, flag f = xdg-open "$1"
      label editor = "$EDITOR" -- "$@"
      label pager  = "$PAGER" -- "$@"
    '';
    xdg.configFile."wezterm/wezterm.lua".text = ''
      local wezterm = require 'wezterm'
      return {
        disable_default_key_bindings = true,
        font = wezterm.font 'FiraMono Nerd Font Mono',
        font_size = 16,
        window_padding={left=0,right=0,top=0,bottom=0,},
        hide_tab_bar_if_only_one_tab = true,
        audible_bell = "Disabled",
        default_cwd = "${home.homeDirectory}/backup/Documents",
        window_close_confirmation = "NeverPrompt",
        default_prog = { '${pkgs.tmux}/bin/tmux', 'new-session', '-As', 'default', 'exec ${pkgs.yazi}/bin/yazi', },
      }
    '';
    programs.kitty = {
      enable = true;
      font.name = "FiraMono Nerd Font Mono";
      # font.name = "FiraCode Nerd Font Mono";
      # font.name = "Fira Code";
      # font.name="DejaVu Sans";
      font.size = 16;
      settings = { enable_audio_bell = false; startup_session = "${home.homeDirectory}/.config/kitty/session.conf"; };
    };
    home.file.".config/kitty/session.conf".text = "cd ${home.homeDirectory}/backup/Documents\nlaunch /bin/sh -c \"${pkgs.tmux}/bin/tmux new-session -As default 'exec ${pkgs.yazi}/bin/yazi'\"";
    programs.lazygit.enable = true;

    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.local/share/flatpak/exports/bin" ];

    home.sessionVariables = {
      PAGER = "less";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      EDITOR = "${home.homeDirectory}/.nix-profile/bin/nvim";
      DIFFPROG = "${pkgs.vim}/bin/vimdiff";
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
    };

    programs.vim.enable = true;
    fonts.fontconfig.enable = true;
    programs.bat.enable = true;
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

    home.file.".config/distrobox/distrobox.conf".text = ''
      container_generate_entry=0
      container_manager="podman"
      container_image_default="quay.io/toolbx/ubuntu-toolbox:latest"
      container_name_default="test"
    '';

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
        zip = "7z a";
        unzip = "7z x";
        nix = "LD_LIBRARY_PATH='' nix=(which nix) $nix";
        top = "htop";
        neofetch = "fastfetch";
        vim = "$VISUAL";
        flake-init = "nix flake init -t github:nix-community/nix-direnv";
        music-update = "nix run github:rikyiso01/musicmanager auto Music Music2 Music3 Bardify Clownpierce Dream FlameFrags Halloween";
        timg = "timg -pk";
        gh = "GH_TOKEN=$(password show -a 'gh token' Github) gh";
        rclone = "RCLONE_PASSWORD_COMMAND='password show -a Password rclone' rclone --config ${home.homeDirectory}/backup/rclone.conf";
        gg = "lazygit";
        # yt = ''(){file="$(mktemp)" && yt-dlp --force-overwrite -xo "$file" "$1" && mpc add "$file"* }'';
      };
      interactiveShellInit = ''set fish_greeting'';
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
      };
      enableTransience = true;
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      initContent = ''
        bindkey -e
        if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
            source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
        fi
        source $HOME/.config/theme.zsh

        function xdg-open(){(
            set -euo pipefail
            file="$1";
            if [[ "$file" == -* ]]; then
                /usr/bin/xdg-open "$file"
                return $?
            fi
            if [[ "$file" != /* && "$file" != *://* ]]; then
                file="$(realpath -es "$file")"
            fi
            if [[ "$file" == /* ]]; then
                realpath -e "$file" >/dev/null
            fi
            /usr/bin/xdg-open "$file" 0<&- &>/dev/null &!
        )}
      '';
      shellAliases = {
        cat = "bat -p";
        du = "dust";
        find = "fd";
        ps = "procs";
        curl = "curlie";
        wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
        zip = "7z a";
        unzip = "7z x";
        nix = "LD_LIBRARY_PATH='' nix";
        top = "htop";
        neofetch = "fastfetch";
        vim = "$VISUAL";
        flake-init = "nix flake init -t github:nix-community/nix-direnv";
        music-update = "nix run github:rikyiso01/musicmanager auto Music Music2 Music3 Bardify Clownpierce Dream FlameFrags Halloween";
        timg = "timg -pk";
        gh = "GH_TOKEN=$(password show -a 'gh token' Github) gh";
        rclone = "RCLONE_PASSWORD_COMMAND='password show -a Password rclone' rclone --config ${home.homeDirectory}/backup/rclone.conf";
        yt = ''(){file="$(mktemp)" && yt-dlp --force-overwrite -xo "$file" "$1" && mpc add "$file"* }'';
        gg = "lazygit";
      };
      history.path = "${home.homeDirectory}/backup/zsh_history";
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

    programs.neovim = {
      enable = true;
      extraLuaConfig = ''
        vim.opt.termguicolors = true
        local lsp_capabilities=require("cmp_nvim_lsp").default_capabilities()
        require'lspconfig'.basedpyright.setup{capabilities=lsp_capabilities,cmd={"${pkgs.basedpyright}/bin/basedpyright-langserver","--stdio"},settings={basedpyright={analysis={typeCheckingMode="strict",stubPath="${home.homeDirectory}/backup/Documents/Projects/Python/common-stubs",extraPaths={"typings"}}}}}
        require'lspconfig'.ruff.setup{capabilities=lsp_capabilities,cmd={"${pkgs.ruff}/bin/ruff","server","--preview"}}
        require'lspconfig'.nil_ls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nil}/bin/nil"}}
        require'lspconfig'.ansiblels.setup{capabilities=lsp_capabilities,cmd={"${pkgs.ansible-language-server}/bin/ansible-language-server","--stdio"}}
        require'lspconfig'.bashls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server","start"}}
        require'lspconfig'.hls.setup{capabilities=lsp_capabilities,cmd={"haskell-language-server-wrapper","--lsp"}}
        require'lspconfig'.dockerls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.dockerfile-language-server-nodejs}/bin/docker-langserver","--stdio"}}
        require'lspconfig'.yamlls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.yaml-language-server}/bin/yaml-language-server","--stdio"}}
        require'lspconfig'.jdtls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.jdt-language-server}/bin/jdtls", "-configuration", "${home.homeDirectory}/.cache/jdtls/config", "-data", "${home.homeDirectory}/.cache/jdtls/workspace"}}
        require'lspconfig'.ts_ls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server","--stdio"}}
        require'lspconfig'.eslint.setup{capabilities=lsp_capabilities,cmd={"${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server","--stdio"}}
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        require'lspconfig'.jsonls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver","--stdio"},capabilities=capabilities}
        require'lspconfig'.taplo.setup{capabilities=lsp_capabilities,cmd={"${pkgs.taplo}/bin/taplo","lsp","stdio"}}
        require'lspconfig'.lemminx.setup{capabilities=lsp_capabilities,cmd={"${pkgs.lemminx}/bin/lemminx"}}
        require'lspconfig'.psalm.setup{capabilities=lsp_capabilities,cmd={"${pkgs.php83Packages.psalm}/bin/psalm","--language-server"}}
        require'lspconfig'.intelephense.setup{capabilities=lsp_capabilities,cmd={"${pkgs.nodePackages.intelephense}/bin/intelephense","--stdio"}}
        require'lspconfig'.cssls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server","--stdio"}}
        require'lspconfig'.rust_analyzer.setup{capabilities=lsp_capabilities,cmd={"rust-analyzer"}}
        require'lspconfig'.dartls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.dart}/bin/dart","language-server","--protocol=lsp"}}
        require'lspconfig'.ltex.setup{capabilities=lsp_capabilities,cmd={"${pkgs.ltex-ls}/bin/ltex-ls"},settings={ltex={language="auto"}}}
        require'lspconfig'.dhall_lsp_server.setup{capabilities=lsp_capabilities,cmd={"${pkgs.dhall-lsp-server}/bin/dhall-lsp-server"}}
        require'lspconfig'.clangd.setup{capabilities=lsp_capabilities,cmd={"${pkgs.clang-tools}/bin/clangd"}}
        -- require'lspconfig'.solc.setup{capabilities=lsp_capabilities,cmd={"${pkgs.solc}/bin/solc","--lsp"}}
        require'lspconfig'.solargraph.setup{capabilities=lsp_capabilities,cmd={"${pkgs.rubyPackages.solargraph}/bin/solargraph","stdio"}}
        require'lspconfig'.csharp_ls.setup{capabilities=lsp_capabilities,cmd={"${pkgs.csharp-ls}/bin/csharp-ls"}}
        require'lspconfig'.astro.setup{capabilities=lsp_capabilities,cmd={"${pkgs.astro-language-server}/bin/astro-ls","--stdio"}}

        require("toggleterm").setup{open_mapping=[[<Leader>t]],direction="float"}
        require("lualine").setup()
        require("autoclose").setup({
           options = {
              disabled_filetypes = { "text", "markdown" },
           },
        })
        require("formatter").setup{
            filetype={
                python={function()return {exe="${pkgs.ruff}/bin/ruff",args={"format","-"},stdin=true} end},
                haskell={function()return {exe="${pkgs.haskellPackages.fourmolu}/bin/fourmolu",args={"--no-cabal","-"},stdin=true} end},
                java={function()return {exe="${pkgs.google-java-format}/bin/google-java-format",args={"-"},stdin=true} end},
                javascript={function()return {exe="prettier",args={"--stdin-filepath=test.js"},stdin=true} end},
                typescript={function()return {exe="prettier",args={"--stdin-filepath=test.ts"},stdin=true} end},
                typescriptreact={function()return {exe="prettier",args={"--stdin-filepath=test.tsx"},stdin=true} end},
                css={function()return {exe="prettier",args={"--stdin-filepath=test.css"},stdin=true} end},
                json={function()return {exe="prettier",args={"--stdin-filepath=test.json"},stdin=true} end},
                jsonc={function()return {exe="prettier",args={"--stdin-filepath=test.jsonc"},stdin=true} end},
                yaml={function()return {exe="prettier",args={"--stdin-filepath=test.yml"},stdin=true} end},
                markdown={function()return {exe="prettier",args={"--stdin-filepath=test.md"},stdin=true} end},
                xml={function()return {exe="${pkgs.html-tidy}/bin/tidy",args={"-i","-xml"},stdin=true} end},
                html={function()return {exe="${pkgs.html-tidy}/bin/tidy",args={"-i"},stdin=true} end},
                nix={function()return {exe="${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt",stdin=true} end},
                bash={function()return {exe="${pkgs.shfmt}/bin/shfmt",stdin=true} end},
                dockerfile={function()return {exe="${pkgs.dockfmt}/bin/dockfmt",args={"fmt"},stdin=true} end},
                -- toml={function()return {exe="prettier",args={"--stdin-filepath=test.toml"},stdin=true} end},
                arduino={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                c={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                cpp={function()return {exe="${pkgs.clang-tools}/bin/clang-format",stdin=true} end},
                rust={function()return {exe="${pkgs.rustfmt}/bin/rustfmt",stdin=true} end},
                dart={function()return {exe="${pkgs.dart}/bin/dart",args={"format"},stdin=false} end},
                dhall={function()return {exe="${pkgs.dhall}/bin/dhall",args={"format"},stdin=true} end},
                just={function()return {exe="${pkgs.just}/bin/just",args={"--dump"},stdin=true} end},
                ruby={function()return {exe="${pkgs.rufo}/bin/rufo",args={"--simple-exit"},stdin=true} end},
            }
        }
        vim.api.nvim_create_autocmd({'BufLeave'},{command='silent! wa'})
        -- require("Comment").setup{}
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
        }
        require('gitblame').setup {
            enabled = true,
            message_when_not_committed = ""
        }
        require('gitsigns').setup()
        require('yazi').setup({open_for_directories = true})

        vim.opt.expandtab = true
        vim.opt.smartindent = true
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.number = true
        vim.opt.incsearch = true
        vim.opt.shortmess:remove({ 'S' })
        vim.opt.colorcolumn = "90"
        vim.opt.list = true
        -- vim.keymap.set('n', '<Leader>e', '<cmd>RnvimrToggle<cr>')
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
        function _G.set_terminal_keymaps()
            local opts = {buffer = 0}
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        end
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        vim.env.NVIM_SERVER=vim.v.servername
        -- vim.g.rnvimr_enable_picker = 1
        -- vim.g.rnvimr_enable_ex = 1
        -- vim.g.rnvimr_ranger_cmd = {'ranger', '--cmd=set preview_images false'}
        vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        vim.cmd [[colorscheme torte]]
        vim.o.splitright=true
        vim.o.splitbelow=true
        vim.api.nvim_create_autocmd('TermOpen', {
            pattern = { '*' },
            callback = function()
                vim.opt.number = false
            end,
            group = generalSettingsGroup,
        })

      '';
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        trouble-nvim
        toggleterm-nvim
        lualine-nvim
        telescope-nvim
        nvim-treesitter.withAllGrammars
        lazygit-nvim
        nvim-cmp
        cmp-nvim-lsp
        markdown-preview-nvim
        autoclose-nvim
        vim-illuminate
        ansible-vim
        vim-vsnip
        formatter-nvim
        # rnvimr
        yazi-nvim
        vim-commentary
        # pkgs.vimExtraPlugins.Comment-nvim
        mini-nvim
        vim-abolish
        dhall-vim
        git-blame-nvim
        gitsigns-nvim
      ];
      extraPackages = with pkgs; [
        haskell-language-server
        # nodePackages.prettier-plugin-toml
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
      ];
    };

    home.file."${config.xdg.configHome}/nvim/spell/it.utf-8.spl".source = builtins.fetchurl {
      url = "https://vim.mirror.garr.it/pub/vim/runtime/spell/it.utf-8.spl";
      sha256 = "d80733903e836d53790c0ab8c1c2f29f663ca2a77aee7b381aea6b8762ae7413";
    };
    home.file."${config.xdg.configHome}/nvim/spell/it.utf-8.sug".source = builtins.fetchurl {
      url = "https://vim.mirror.garr.it/pub/vim/runtime/spell/it.utf-8.sug";
      sha256 = "e0bb1761a79270926b75a8faf4f4d0d840d55a2b34518fd8e512927c2724ce4a";
    };

    programs.nix-index.enable = true;

    programs.home-manager.enable = true;
    home.stateVersion = "22.05";
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; android_sdk.accept_license = true; }";
    home.enableNixpkgsReleaseCheck = false;

    home.file.".config/xdg-desktop-portal/hyprland-portals.conf".text = ''
      [preferred]
      default=hyprland;gtk
    '';

    news.display = "show";

    # qt = {
    #   enable = true;
    #   platformTheme.name = "adwaita";
    #   style = {
    #     name = "adwaita-dark";
    #     package = pkgs.adwaita-qt;
    #   };
    # };
    gtk = {
      enable = true;
      cursorTheme = {
        name = "Bibata-Modern-Amber";
        package = pkgs.bibata-cursors;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      #   gtk3.extraConfig = {
      #     gtk-application-prefer-dark-theme = 1;
      #   };
      #   # gtk4.extraConfig = {
      #   #   gtk-application-prefer-dark-theme = 1;
      #   # };
    };
    xdg = {
      enable = true;
      userDirs = {
        createDirectories = true;
        enable = true;
        documents = "${home.homeDirectory}/backup/Documents";
        music = "${home.homeDirectory}/backup/Music";
      };
    };


    home.file.".config/hypr/hyprland.conf".text = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=eDP-1,1920x1080@60,auto,1
      monitor=,preferred,auto,1,mirror,eDP-1

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      # $terminal = /usr/bin/kitty
      $terminal = /usr/bin/flatpak run org.wezfurlong.wezterm
      $fileManager = /usr/bin/flatpak run org.gnome.NautilusDevel

      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox
      exec-once = ${pkgs.swaynotificationcenter}/bin/swaync
      exec-once = /usr/libexec/polkit-gnome-authentication-agent-1
      exec-once = ${pkgs.waybar}/bin/waybar
      exec-once = ${pkgs.hypridle}/bin/hypridle
      exec-once = dbus-update-activation-environment --systemd --all
      exec-once= $fileManager
      exec-once=[workspace 1 silent; maximize] sleep 1 && $terminal
      exec-once=sleep 2 && /usr/bin/flatpak kill org.gnome.NautilusDevel
      exec-once=[workspace 1 silent; noinitialfocus] sleep 5 && flatpak run io.gitlab.librewolf-community
      exec-once=secret-tool lookup keepass password | SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh flatpak run --file-forwarding org.keepassxc.KeePassXC --pw-stdin @@ ${home.homeDirectory}/backup/phone/Drive/keepass.kdbx @@
      # exec-once=sleep 1 && hyprctl dispatch focuswindow kitty
      exec-once=${pkgs.gammastep}/bin/gammastep -O 4000
      exec-once=${pkgs.hyprpaper}/bin/hyprpaper

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # Set programs that you use
      $menu = ${pkgs.wofi}/bin/wofi

      # Some default env vars.
      env = XCURSOR_SIZE,36
      env = XCURSOR_THEME,Bibata-Modern-Amber
      # env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us,it
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = yes
          }

          sensitivity = 1.0 # -1.0 to 1.0, 0 means no modification.
          repeat_rate=50
          repeat_delay=300
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = master

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10

          blur {
              enabled = false
              size = 3
              passes = 1
          }

          # drop_shadow = false
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = yes

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          # animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          # new_is_master = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = off
      }

      misc {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
          vfr=true
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
      windowrulev2 = float,class:^(org.wezfurlong.wezterm)$
      windowrulev2 = tile,class:^(org.wezfurlong.wezterm)$

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, RETURN, exec, $terminal
      bind = $mainMod, Q, killactive,
      bind = $mainMod SHIFT, P, exec, poweroff
      bind = $mainMod SHIFT, F, exec, if [[ $(powerprofilesctl get) = 'power-saver' ]]; then powerprofilesctl set balanced; else powerprofilesctl set power-saver; fi
      bind = $mainMod SHIFT, W, exec, pkill hyprpaper
      bind = $mainMod SHIFT, B, exec, rfkill toggle bluetooth
      bind = $mainMod SHIFT, R, exec, nmcli d wifi rescan
      bind = $mainMod SHIFT, G, exec, swaylock
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      # bind = $mainMod, left, layoutmsg, cycleprev
      # bind = $mainMod, right, layoutmsg, cyclenext
      # bind = $mainMod, up, layoutmsg, cycleprev
      # bind = $mainMod, down, layoutmsg, cyclenext
      bind = $mainMod, H, layoutmsg, cycleprev
      bind = $mainMod, L, layoutmsg, cyclenext
      bind = $mainMod, K, layoutmsg, cycleprev
      bind = $mainMod, J, layoutmsg, cyclenext

      # Move window mainMod + arrow keys
      # bind = $mainMod SHIFT, left, layoutmsg, swapprev
      # bind = $mainMod SHIFT, right, layoutmsg, swapnext
      # bind = $mainMod SHIFT, up, layoutmsg, swapprev
      # bind = $mainMod SHIFT, down, layoutmsg, swapnext
      bind = $mainMod SHIFT, H, layoutmsg, swapprev
      bind = $mainMod SHIFT, L, layoutmsg, swapnext
      bind = $mainMod SHIFT, K, layoutmsg, swapprev
      bind = $mainMod SHIFT, J, layoutmsg, swapnext

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Example special workspace (scratchpad)
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5
      bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5
      bind = , XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t
      bind = , XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
      bind = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl -a play-pause
      bind = , XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl -a play-pause
      bind = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl -a next
      bind = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl -a previous
      bind = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
      bind = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
      bind = , Print, exec, ${pkgs.grim}/bin/grim "$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/$(date +'%s_grim.png')"

      bind = , XF86HomePage, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
      bind = , XF86Mail, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+

      bind = $mainMod SHIFT, SPACE, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next

      bind = $mainMod, F, fullscreen, 0
      bind = $mainMod, M, fullscreen, 1
      bind = $mainMod SHIFT, M, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t
    '';

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          margin = "9 13 -10 18";
          spacing = 8;
          modules-left = [ "hyprland/language" "hyprland/workspaces" ];
          modules-center = [ "custom/clock" ];
          modules-right = [ "pulseaudio" "cpu" "memory" "network" "bluetooth" "power-profiles-daemon" "backlight" "battery" "tray" ];
          "custom/clock" = {
            format = "{}";
            exec = "date +'%a, %d %b, %R'";
            interval = 1;
          };
          clock = {
            format = "{:%a, %d %b, %I:%M %p}";
          };
          pulseaudio = {
            reverse-scrolling = 1;
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}%  {format_source}";
            format-bluetooth-muted = " {format_source}";
            format-muted = "󰸈 {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              default = [ "" "" "" ];
            };
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
          cpu = {
            interval = 2;
            format = "{usage}% ";
          };
          memory = {
            interval = 2;
            format = "{percentage}% 󰍛 {swapPercentage}% ";
          };
          network = {
            format-wifi = "{essid} 󰖩";
            format-ethernet = "󰈀";
            format-disconnected = "󰖪";
            on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          };
          bluetooth = {
            format = "󰂯";
            format-disabled = "󰂲";
            format-connected = "󰂱";
          };
          power-profiles-daemon = {
            "format-icons" = {
              "balanced" = "";
              "performance" = "󰈸";
              "power-saver" = "󰌪";
            };
          };
          backlight = {
            device = "intel_backlight";
            format = "{percent}% {icon}";
            format-icons = [ "" ];
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}?";
            format-plugged = "{capacity}% ";
            format-charging = "{capacity}% ";
            format-discharging = "{capacity}% {icon}";
            format-icons = [ "" "" "" "" "" ];
          };

          "hyprland/language" = {
            format = "{}";
            format-en = "EN";
            format-it = "IT";
            keyboard = "at-translated-set-2-keyboard";
          };

          tray = {
            icon-size = 16;
            spacing = 0;
          };
        };
      };
      style = ''
        *{
            border: none;
            font-family: 'FiraMono Nerd Font Mono';
            /*font-family: 'FiraCode Nerd Font Mono';*/
            font-size: 1em;
            background: transparent;
            color: #ffffff;
        }
        .module{
            background: #383c4a;
            border-radius: 10px;
            padding: 0 16px 0 16px;
        }
        #workspaces{
            padding: 0;
        }
        #workspaces button.active{
            border-radius: inherit;
            background: #4e5263;
        }
        #workspaces button:hover{
            transition: none;
            box-shadow: none;
            text-shadow: none;
            border-radius: inherit;
            background: #7c818c;
        }
        #battery.plugged{
            color: #ffffff;
            background-color: #26A65B;
        }
        #battery.charging{
            color: #ffffff;
            background-color: #26A65B;
        }
        #battery.warning:not(.charging) {
            background-color: #ffbe61;
            color: black;
        }

        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: black;
        }
      '';
    };
    programs.wofi = {
      enable = true;
      settings = {
        hide_scroll = true;
        show = "drun";
        width = "30%";
        lines = 8;
        line_wrap = "word";
        term = "kitty";
        allow_markup = true;
        always_parse_args = false;
        show_all = true;
        print_command = true;
        layer = "overlay";
        allow_images = true;
        sort_order = "alphabetical";
        gtk_dark = true;
        prompt = "";
        image_size = 20;
        display_generic = false;
        location = "center";
        key_expand = "Tab";
        insensitive = true;
      };
    };
    home.file.".config/wofi/style.css".source = ./wofi.css;
    home.file.".config/hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof swaylock || swaylock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
      }
    '';
    home.file.".config/swaylock/config".text = "color=333333";
    home.file.".config/hypr/hyprpaper.conf".text = ''
      preload = ${./wallpapers/solo.jpg}
      wallpaper = ,${./wallpapers/solo.jpg}
    '';

    services.syncthing.enable = true;
    services.syncthing.extraOptions = [ "-config=${home.homeDirectory}/backup/syncthing" "-data=${home.homeDirectory}/.local/state/syncthing" ];
    services.mpd = {
      enable = true;
      musicDirectory = "${config.xdg.userDirs.music}";
      extraConfig = ''
        audio_output {
            type "pipewire"
            name "PipeWire Sound Server"
        }
        auto_update "yes"
      '';
      network = {
        startWhenNeeded = true;
      };
    };
    services.mpd-mpris.enable = true;
    programs.ncmpcpp.enable = true;

    systemd.user.services = {
      startup = {
        Unit = { Description = "Startup"; };
        Service = {
          ExecStartPre = "/bin/sleep 5";
          ExecStart = "bash ${./startup.sh}";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      battery = {
        Unit = { Description = "Battery low"; };
        Service = {
          ExecStart = "bash ${./battery.sh} 30 'Battery low'";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      battery2 = {
        Unit = { Description = "Battery very low"; };
        Service = {
          ExecStart = "bash ${./battery.sh} 15 'Battery very low'";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      rclone = {
        Unit = {
          Description = "rclone";
        };
        Service = {
          ExecStartPre = "bash -c 'while ! getent hosts www.google.com; do sleep 5; done'";
          ExecStart = "${pkgs.rclone}/bin/rclone --config ${home.homeDirectory}/backup/rclone.conf copy --update ${home.homeDirectory}/backup/phone/Drive drive:Syncthing";
          Environment = "RCLONE_PASSWORD_COMMAND='${home.homeDirectory}/.local/bin/password show -a Password rclone'";
        };
        Install = { WantedBy = [ "default.target" ]; };
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
      trash = {
        Unit = { Description = "Automatically empty trash"; };
        Service = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${pkgs.trash-cli}/bin/trash-empty 30";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      clear-playlist = {
        Unit = { Description = "Clear mpd playlist on startup"; };
        Service = {
          Type = "oneshot";
          ExecStartPre = "sleep 1";
          ExecStart = "${pkgs.mpc-cli}/bin/mpc clear";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      redlib = {
        Unit = { Description = "Custom frontend for Reddit"; };
        Service = {
          ExecStart = "${pkgs.redlib}/bin/redlib -p 8385";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      gh-token = {
        Unit = { Description = "Github token loader"; };
        Service = {
          ExecStart = "systemctl --user import-environment GH_TOKEN";
          Environment = "GH_TOKEN='${home.homeDirectory}/.local/bin/password show -a 'gh token' Github'";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      radicale = {
        Unit = {
          Description = "Radicale server";
        };
        Service = {
          ExecStart = "sh -c 'podman build -t radicale ${./docker} -f radicale.dockerfile && podman run --name radicale --rm -p 127.0.0.1:5232:5232 -v ${home.homeDirectory}/backup/phone/Drive/DecSync:/decsync -v ${home.homeDirectory}/.local/share/radicale/collections:/collections --read-only radicale'";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      searxng = {
        Unit = {
          Description = "Searxng server";
        };
        Service = {
          ExecStart = "podman run --name searxng --rm --read-only -p 127.0.0.1:5233:8080 docker.io/searxng/searxng:latest";
          ExecStop = "nohup podman stop -t0 searxng";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
    };

    home.file.".gdbinit".text = ''
      source ${pkgs.gef}/share/gef/gef.py
      set history filename ~/.local/state/gdb_history
    '';

    home.file.".config/pypoetry/config.toml".text = lib.generators.toINI
      { }
      {
        virtualenvs = {
          in-project = true;
        };
      };
    home.file.".config/theme.zsh".source = ./theme.zsh;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        "color-scheme" = "prefer-dark";
      };
      "org/gtk/settings/file-chooser" = {
        "show-hidden" = true;
      };
      "org/gtk/gtk4/settings" = {
        "show-hidden" = true;
      };
    };

    home.file.".var/app/io.gitlab.librewolf-community/.librewolf/librewolf.overrides.cfg".text = ''
      defaultPref("privacy.resistFingerprinting", false);
      defaultPref("webgl.disabled", true);
      defaultPref("security.OCSP.require", false);
      defaultPref("privacy.clearOnShutdown_v2.cache", true);
      defaultPref("privacy.clearOnShutdown_v2.cookiesAndStorage", true);
      defaultPref("network.http.referer.XOriginPolicy", 2);
      defaultPref("browser.sessionstore.resume_from_crash", false);
      defaultPref("media.autoplay.blocking_policy", 2);
    '';

    home.file.".var/app/io.gitlab.librewolf-community/.librewolf/native-messaging-hosts/net.downloadhelper.coapp.json".text = ''
      {
      "name": "net.downloadhelper.coapp",
      "description": "Video DownloadHelper companion app",
      "path": "${pkgs.vdhcoapp}/bin/vdhcoapp",
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
      "path": "${pkgs.keepassxc}/bin/keepassxc-proxy",
      "type": "stdio"
      }
    '';


    home.file.".local/bin/password" = {
      text = ''
        #!/usr/bin/env bash

            set -euo pipefail

            action="$1"
            shift

            secret-tool lookup keepass password | ${pkgs.keepassxc}/bin/keepassxc-cli "$action" ~/backup/phone/Drive/keepass.kdbx "$@"
      '';
      executable = true;
    };


    home.file.".local/flatpak/librewolf" = {
      text = "#!/usr/bin/env bash\nln -sfT $XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer $XDG_RUNTIME_DIR/kpxc_server && exec /app/bin/librewolf \"$@\"";
      executable = true;
    };
    home.file.".local/flatpak/cobalt" = {
      text = "#!/usr/bin/env bash\n exec /app/bin/cobalt --webrtc-ip-handling-policy=default --ozone-platform=wayland \"$@\"";
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
    home.file.".local/share/flatpak/overrides/com.obsproject.Studio".text = ''
      [Context]
      filesystems=!xdg-config/kdeglobals;xdg-videos;!host;~/backup/Flatpaks/obs-studio

      [Session Bus Policy]
      org.freedesktop.Flatpak=none
    '';
    home.file.".local/share/flatpak/overrides/com.userbottles.bottles".text = ''
      [Context]
      filesystems=!xdg-download;~/backup/Flatpaks/bottles
    '';
    home.file.".local/share/flatpak/overrides/io.gitlab.librewolf-community".text = ''
      [Context]
      devices=all
      filesystems=/nix/store:ro;xdg-run/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer:ro;~/.local/flatpak:ro;~/.nix-profile:ro

      [Environment]
      PATH=${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin
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
    home.file.".local/share/flatpak/overrides/org.gnome.TextEditor".text = ''
      [Context]
      filesystems=!xdg-run/gvfsd;!host
    '';
    home.file.".local/share/flatpak/overrides/org.keepassxc.KeePassXC".text = ''
      [Context]
      devices=!all;dri
      filesystems=!xdg-config/kdeglobals;/nix/store:ro;!host
    '';
    home.file.".local/share/flatpak/overrides/org.prismlauncher.PrismLauncher".text = ''
      [Context]
      filesystems=~/backup/Games/Minecraft
    '';
    home.file.".local/share/flatpak/overrides/com.calibre_ebook.calibre".text = ''
      [Context]
      filesystems=~/backup/Flatpaks/calibre;~/backup/Books;!host
    '';
    home.file.".local/share/flatpak/overrides/eu.betterbird.Betterbird".text = ''
      [Context]
      filesystems=~/backup/Flatpaks/.thunderbird
    '';
    home.file.".local/share/flatpak/overrides/io.github.ungoogled_software.ungoogled_chromium".text = ''
      [Context]
      filesystems=!xdg-desktop;!xdg-run/pipewire-0;!~/.local/share/icons;!xdg-run/dconf;!xdg-download;!~/.config/dconf;!/run/.heim_org.h5l.kcm-socket;!~/.local/share/applications;!/tmp;!~/.config/kioslaverc;~/.local/flatpak:ro;/nix/store:ro

      [Environment]
      PATH=/home/riky/.local/flatpak:/app/bin:/usr/bin
    '';


    home.file.".var/app/org.keepassxc.KeePassXC/config/keepassxc/keepassxc.ini".text = ''
      [General]
      ConfigVersion=2
      MinimizeAfterUnlock=true
      UseAtomicSaves=true
      AutoSaveAfterEveryChange=true

      [SSHAgent]
      Enabled=true

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

    home.file.".local/nix-sources/flatpak" = {
      text = ''
        org.gnome.TextEditor
        org.gnome.Characters
        ca.desrt.dconf-editor
        com.github.tchx84.Flatseal
        com.obsproject.Studio
        org.gnome.seahorse.Application
        com.usebottles.bottles
        org.localsend.localsend_app
        org.gnome.dspy
        org.shotcut.Shotcut
        org.keepassxc.KeePassXC
        org.gnome.FileRoller
        org.gnome.Evince
        org.gnome.Loupe
        org.gnome.SimpleScan
        io.github.flattool.Warehouse
        io.freetubeapp.FreeTube
        org.prismlauncher.PrismLauncher
        org.gimp.GIMP
        org.libreoffice.LibreOffice
        io.gitlab.librewolf-community
        eu.betterbird.Betterbird
        io.mpv.Mpv
        com.calibre_ebook.calibre
        org.chromium.Chromium
        io.github.ungoogled_software.ungoogled_chromium
        org.virt_manager.virt-manager
        org.gnome.NautilusDevel'';
      onChange = ''
        flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak remote-add --user --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
        flatpak install --user -y $(comm -23 <(sort $HOME/.local/nix-sources/flatpak) <(flatpak list --app --user --columns=application | sort)) || true
        flatpak remove --user -y $(comm -13 <(sort $HOME/.local/nix-sources/flatpak) <(flatpak list --app --user --columns=application | sort)) || true
      '';
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
    home.file.".local/nix-sources/packages" = {
      text = "base
        linux
        linux-firmware
        sof-firmware
        networkmanager
        networkmanager-openvpn
        sudo
        nix
        greetd
        greetd-tuigreet
        hyprland
        kitty
        swaylock
        intel-ucode
        reflector
        intel-media-driver
        util-linux
        flatpak
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        polkit-gnome
        pipewire
        wireplumber
        podman
        pipewire-jack
        pipewire-alsa
        pipewire-pulse
        pipewire-audio
        qemu-desktop
        vulkan-intel
        gnome-keyring
        power-profiles-daemon
        libvirt
        bluez
        bluez-utils
        udisks2
        pacman-contrib";
      onChange = "
            sudo pacman -S --noconfirm --needed $(cat $HOME/.local/nix-sources/packages)
            sudo pacman -D --asdeps $(pacman -Qqe)
            sudo pacman -D --asexplicit $(cat $HOME/.local/nix-sources/packages)
            if pacman -Qdtq
            then
                pacman -Qdtq | sudo pacman --noconfirm -Rns -
            fi
        ";
    };
    home.file.".local/nix-sources/enabled-system-services" = {
      text = "
            reflector
            fstrim.timer
            polkit
            power-profiles-daemon
            virtqemud.socket
            virtnodedevd.socket
            virtstoraged.socket
            virtnetworkd.socket
            virtlogd.socket
            virtlockd.socket
            bluetooth
        ";
      onChange = "sudo systemctl enable $(cat $HOME/.local/nix-sources/enabled-system-services)";
    };
    home.file.".local/nix-sources/groups" = {
      text = "libvirt";
      onChange = "while read p; do sudo usermod -aG $p $USER; done < $HOME/.local/nix-sources/groups";
    };
    home.file.".local/nix-sources/pam" = {
      text = ''#%PAM-1.0

        auth       required     pam_securetty.so
        auth       requisite    pam_nologin.so
        auth       include      system-local-login
        auth       optional     pam_gnome_keyring.so
        account    include      system-local-login
        session    optional     pam_fde_boot_pw.so inject_for=gkr
        session    include      system-local-login
        session    optional     pam_gnome_keyring.so auto_start'';
      onChange = "sudo mkdir -p /etc/pam.d && sudo tee /etc/pam.d/greetd < $HOME/.local/nix-sources/pam";
    };
    home.file.".local/nix-sources/pam_fde_boot_pw.so" = {
      source = ./pam_fde_boot_pw.so;
      onChange = "sudo cp ${./pam_fde_boot_pw.so} /lib/security/pam_fde_boot_pw.so";
    };
    home.file.".local/nix-sources/greetd" = {
      text = ''[terminal]
        vt = 1
        [default_session]
        command = "/usr/bin/tuigreet --remember --cmd /usr/bin/Hyprland"
        user = "greeter"
        [initial_session]
        command = "/usr/bin/Hyprland"
        user = "riky"
        '';
      onChange = "sudo mkdir -p /etc/greetd && sudo tee /etc/greetd/config.toml < $HOME/.local/nix-sources/greetd";
    };
    home.file.".local/nix-sources/nix.conf" = {
      text = ''
        build-users-group = nixbld
        auto-optimise-store = true
      '';
      onChange = "sudo mkdir -p /etc/nix && sudo tee /etc/nix/nix.conf < $HOME/nix-sources/nix.conf";
    };
    home.file.".local/nix-sources/systemd-boot-hook" = {
      text = ''
        [Trigger]
        Type = Package
        Operation = Upgrade
        Target = systemd

        [Action]
        Description = Gracefully upgrading systemd-boot...
        When = PostTransaction
        Exec = /usr/bin/systemctl restart systemd-boot-update.service
      '';
      onChange = "sudo mkdir -p /etc/pacman.d/hooks && sudo tee /etc/pacman.d/hooks/95-systemd-boot.hook < $HOME/nix-sources/systemd-boot-hook";
    };
    home.file.".local/nix-sources/journald-config" = {
      text = ''
        [Journal]
        SystemMaxUse=50M
      '';
      onChange = "sudo mkdir -p /etc/systemd/journald.conf.d && sudo tee /etc/systemd/journald.conf.d/00-journal-size.conf < $HOME/.local/nix-sources/journald-config";
    };
    home.file.".local/nix-sources/logind-config" = {
      text = ''
        [Login]
        KillUserProcesses=yes
      '';
      onChange = "sudo mkdir -p /etc/systemd/logind.conf.d && sudo tee /etc/systemd/logind.conf.d/00-kill-tmux.conf < $HOME/.local/nix-sources/logind-config";
    };
    home.file.".local/nix-sources/hosts" = {
      text = ''
        127.0.0.1        localhost
        ::1              localhost
      '';
      onChange = "sudo tee /etc/hosts < $HOME/.local/nix-sources/hosts";
    };


    nix = {
      enable = true;
      package = pkgs.nix;
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

    home.activation = {
      setup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rmdir "$HOME/Documents" > /dev/null 2> /dev/null || true
        rmdir "$HOME/Music" > /dev/null 2> /dev/null || true
        ln -sfT "$HOME/.nix-profile/share/fonts" "$HOME/.local/share/fonts"
        ln -sfT "$HOME/.nix-profile/share/icons" "$HOME/.local/share/icons"

        mkdir -p "$HOME/.local/share/applications"
        chmod -w "$HOME/.local/share/applications" "$HOME/Desktop"

        systemctl enable --user gcr-ssh-agent.socket
        systemctl enable --user podman.socket
        systemctl --user mask tracker-extract-3.service tracker-miner-fs-3.service tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service tracker-miner-fs-control-3.service
        mkdir -p "${home.homeDirectory}/.local/share/flatpak/app/io.gitlab.librewolf-community/current/active/files/lib/librewolf/distribution"
        ln -sfT "${./policies.json}" "${home.homeDirectory}/.local/share/flatpak/app/io.gitlab.librewolf-community/current/active/files/lib/librewolf/distribution/policies.json"
        mkdir -p "${home.homeDirectory}/.local/share/flatpak/app/io.github.ungoogled_software.ungoogled_chromium/current/active/files/chromium/policies/policies/managed"
        ln -sfT "${./chromium.jsonc}" "${home.homeDirectory}/.local/share/flatpak/app/io.github.ungoogled_software.ungoogled_chromium/current/active/files/chromium/policies/policies/managed/policies.json"

        mkdir -p "$HOME/.var/app/org.prismlauncher.PrismLauncher/data"
        ln -sfT "$HOME/backup/Games/Minecraft" "$HOME/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher"

        mkdir -p "$HOME/.var/app/com.calibre_ebook.calibre/config"
        ln -sfT "$HOME/backup/Flatpaks/calibre" "$HOME/.var/app/com.calibre_ebook.calibre/config/calibre"

        mkdir -p "$HOME/.var/app/com.obsproject.Studio/config"
        ln -sfT "$HOME/backup/Flatpaks/obs-studio" "$HOME/.var/app/com.obsproject.Studio/config/obs-studio"

        mkdir -p "$HOME/.var/app/com.usebottles.bottles/data"
        # ln -sfT "$HOME/backup/Flatpaks/bottles" "$HOME/.var/app/com.usebottles.bottles/data/bottles"

        mkdir -p "$HOME/.var/app/eu.betterbird.Betterbird"
        # ln -sfT "$HOME/backup/Flatpaks/.thunderbird" "$HOME/.var/app/eu.betterbird.Betterbird/.thunderbird"

        mkdir -p "$HOME/.local/share"
        ln -sfT "$HOME/backup/keyrings" "$HOME/.local/share/keyrings"

        ln -sfT "$HOME/backup/fish_history" "$HOME/.local/share/fish/fish_history"
      '';
    };
  };

in
homeManager
