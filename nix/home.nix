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
      netcat
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
      trash-cli
      wl-clipboard
      nixVersions.latest
      rclone
      rsync
      mpc
      clock-rs
      # yt-dlp
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
      socat
    ];

    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        pull.rebase = false;
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
      shellWrapperName = "y";
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
          {
            on = [ "g" "w" ];
            run = "cd ~/Work/FERRARI/FERRARI_GT";
            desc = "Goto working directory";
          }
        ];
      };
      settings = {
        opener = {
          edit = [
            {
              run = "\${EDITOR:-vi} %s";
              desc = "$EDITOR";
              block = true;
            }
          ];
          open = [
            { run = "xdg-open %s"; desc = "Open"; orphan = true; }
          ];
        };
        open = {
          rules = [
            { mime = "text/*"; use = "edit"; }
            { mime = "{audio,image,video}/*"; use = "open"; }
            { mime = "application/{json,ndjson}"; use = "edit"; }
            { mime = "*/javascript"; use = "edit"; }
            { mime = "inode/empty"; use = "edit"; }
          ];
          append_rules = [
            { url = "*"; use = "open"; }
          ];
        };
      };
      initLua = ''require("folder-rules"):setup()'';
    };

    xdg.configFile."yazi/theme.yoml".source = ./yazi.toml;


    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.local/share/flatpak/exports/bin" ];

    home.sessionVariables = {
      PAGER = "less";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
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
        monitor = ''
          hyprctl keyword monitor "HDMI-A-1,preferred,auto-$argv[1],1"
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
      withRuby = true;
      withPython3 = true;
      initLua = "dofile('${home.sessionVariables.NIX_CONFIG_FOLDER}/nix/neovim.lua')";

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        trouble-nvim
        lualine-nvim
        telescope-nvim
        nvim-treesitter.withAllGrammars
        nvim-cmp
        cmp-nvim-lsp
        # vim-illuminate
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
        outline-nvim
        nvim-dap
        nvim-dap-view
      ];
      extraPackages = with pkgs; [
        haskell-language-server
        ripgrep
        diagnostic-languageserver
        wl-clipboard
        gcc
        tree-sitter
        ghc
        jdt-language-server
        rust-analyzer
        lua-language-server
        basedpyright
        nil
        bash-language-server
        dockerfile-language-server
        yaml-language-server
        jdt-language-server
        kotlin-language-server
        typescript-language-server
        vscode-langservers-extracted
        vscode-json-languageserver
        taplo
        lemminx
        php83Packages.psalm
        intelephense
        dart
        ltex-ls-plus
        dhall
        dhall-lsp-server
        clang-tools
        rubyPackages.solargraph
        erlang-language-platform
        postgres-language-server
        ruff
        haskellPackages.fourmolu
        google-java-format
        ktfmt
        prettier
        html-tidy
        nixpkgs-fmt
        shfmt
        dockerfmt
        rustfmt
        just
        rufo
        csharpier
        beamMinimal28Packages.erlfmt
        python3Packages.debugpy
        netcoredbg
        csharp-ls
        dotnet-sdk_10
        stylua
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
