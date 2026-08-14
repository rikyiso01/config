{ config, pkgs, lib, pwndbg, ... }:

let
  homeManager = rec {
    home.homeDirectory = "/home/riky";

    home.packages = with pkgs; [
      nixgl.nixGLIntel
      nixgl.nixVulkanIntel
      (config.lib.pamShim.replacePam noctalia)
    ];
    nixpkgs.config.allowUnfreePredicate = (pkg: true);

    pamShim.enable = true;

    home.sessionVariables = {
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
      DIFFPROG = "${home.homeDirectory}/.nix-profile/bin/nvim -d";
      EDITOR = "${home.homeDirectory}/.nix-profile/bin/nvim";
      VISUAL = "$EDITOR";
      SUDO_EDITOR = "$VISUAL";
      NIX_CONFIG_FOLDER = "${home.homeDirectory}/backup/Documents/config";
      LC_TIME = "en_GB";
    };

    accounts = {
      calendar = {
        basePath = "${home.homeDirectory}/backup/Calendar";
        accounts = (builtins.mapAttrs
          (name: value: {
            remote = {
              type = "caldav";
              url = "http://127.0.0.1:5232";
              userName = "t";
              passwordCommand = [ "echo" "t" ];
            };
            vdirsyncer = {
              enable = true;
              localReadOnly = true;
              collections = [ value.collection ];
            };
            khal = {
              enable = value.color != "";
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
            creativity_books = { collection = "tasks-aabaeb8f-bb5a-4b80-b305-4a6c25f635a4"; color = ""; };
            creativity_cooking = { collection = "tasks-e22f86b1-d6fb-455b-92d2-38db9b7300f3"; color = ""; };
            creativity_drawing = { collection = "tasks-5d99f660-e84f-49b3-91e0-5d778433fc56"; color = ""; };
            creativity_music = { collection = "tasks-7e74e867-853e-4aa0-ac78-600644d8d35c"; color = ""; };
            creativity_projects = { collection = "tasks-d5e04306-ee67-41b7-8b5a-40f3fd14123c"; color = ""; };
            creativity_study = { collection = "tasks-6ce598c1-938f-4127-ac62-cd258870ff34"; color = ""; };
            creativity_thinking = { collection = "tasks-06f8d69a-5f20-4573-a08e-46256dede01c"; color = ""; };
            creativity_travel = { collection = "tasks-0453bfd7-c336-44fd-a3bd-ccc34f5362c8"; color = ""; };
            creativity_try = { collection = "tasks-7049b453-09a1-476e-8cb3-ad88818ae4fb"; color = ""; };
            creativity_writing = { collection = "tasks-042dd3ed-efb1-4c8d-892d-8b7ed8d205bd"; color = ""; };
            dreams = { collection = "tasks-3ea11777-fada-4396-b93e-190683007838"; color = ""; };
            friends_tasks = { collection = "tasks-57b98d80-2ee1-457e-89fa-62e19787d056"; color = ""; };
            other = { collection = "tasks-31797752-7403-4990-b964-37077c31be74"; color = ""; };
            survival_choors = { collection = "tasks-13750ca6-3ff0-4073-a48a-d09ff25df7c8"; color = ""; };
            survival_health_tasks = { collection = "tasks-ae3d3f2b-1f2c-4176-9da7-447806342782"; color = ""; };
            survival_buy = { collection = "tasks-e407602c-9dc7-4b75-992a-e0b55a3a30cf"; color = ""; };
            work_freelance = { collection = "tasks-feb8fffa-a1d6-42bb-9e29-a720bf0097a3"; color = ""; };
            work_university = { collection = "tasks-4a32fa21-d9be-40f0-9bcf-3546f1cb9f85"; color = ""; };
          });
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
    programs.todoman = {
      enable = true;
      glob = "*/*";
    };

    programs.fish = {
      shellAliases = {
        music-update = "nix run ${home.homeDirectory}/backup/Documents/Projects/Python/musicmanager auto Music Music2 Music3 Music4 Music5 Bardify Clownpierce Dream FlameFrags Halloween Wemmbu Tensura";
        timg = "timg -ps";
        gh = "GH_TOKEN=$(password show -a 'gh token' Github) gh=(which gh) $gh";
        cb = "${pkgs.forgejo-cli}/bin/fj -H codeberg.org";
        # yt = ''(){file="$(mktemp)" && yt-dlp --force-overwrite -xo "$file" "$1" && mpc add "$file"* }'';
      };
    };

    programs.git = {
      settings = {
        user.name = "rikyiso01";
        user.email = "rikyiso01@noreply.codeberg.org";
        gpg.format = "ssh";
        credential.helper = "${pkgs.git-credential-keepassxc}/bin/git-credential-keepassxc --git-groups";
      };
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPRI8KdIpS8+g0IwxfzmrCBP4m7XWj0KECBz42WkgwsG";
        signByDefault = true;
        format = "openpgp";
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
        {
          condition = "gitdir:~/Work/";
          contents = {
            user = {
              name = "r-isola";
              email = "249273394+r-isola@users.noreply.github.com";
              signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKroTy1E/KG99Zx9TYtbBjJ5o9QXmvntSi16jiDczFmV";
            };
          };
        }
      ];
    };

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "FiraMono Nerd Font Mono:size=16";
        };
        cursor = {
          cursor = "11111b f5e0dc";
        };

        colors = {
          foreground = "c0caf5";
          background = "1a1b26";
          selection-foreground = "c0caf5";
          selection-background = "283457";
          urls = "73daca";

          regular0 = "15161e";
          regular1 = "f7768e";
          regular2 = "9ece6a";
          regular3 = "e0af68";
          regular4 = "7aa2f7";
          regular5 = "bb9af7";
          regular6 = "7dcfff";
          regular7 = "a9b1d6";

          bright0 = "414868";
          bright1 = "f7768e";
          bright2 = "9ece6a";
          bright3 = "e0af68";
          bright4 = "7aa2f7";
          bright5 = "bb9af7";
          bright6 = "7dcfff";
          bright7 = "c0caf5";

          "16" = "ff9e64";
          "17" = "db4b4b";
        };
      };
    };

    gtk = {
      enable = true;
      cursorTheme = {
        name = "";
        package = pkgs.catppuccin-cursors.mochaBlue;
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
      gtk4.theme = config.gtk.theme;
    };
    xdg = {
      enable = true;
      userDirs = {
        setSessionVariables = true;
        createDirectories = true;
        enable = true;
        documents = "${home.homeDirectory}/backup/Documents";
        music = "${home.homeDirectory}/backup/phone/Music";
      };
      portal = {
        config.common.default = "hyprland;gtk";
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      systemd.enable = true;
      configType = "lua";
      extraLuaFiles."config".content = ./hyprland.lua;
    };

    xdg.configFile."noctalia/config.toml".source = (pkgs.formats.toml { }).generate "config" { include.files = [ "${home.sessionVariables.NIX_CONFIG_FOLDER}/nix/noctalia.toml" ]; };

    services.syncthing = {
      enable = true;
      extraOptions = [ "--config=${home.homeDirectory}/backup/syncthing" "--data=${home.homeDirectory}/.local/state/syncthing" "--allow-newer-config" ];
    };
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
    services.wl-clip-persist.enable = true;
    programs.ncmpcpp.enable = true;
    programs.bluetuith.enable = true;

    services.flatpak = {
      enable = true;
      packages = builtins.map (x: { appId = x; origin = "flathub"; }) [
        "org.gnome.TextEditor"
        "org.gnome.Characters"
        "ca.desrt.dconf-editor"
        "com.github.tchx84.Flatseal"
        "com.obsproject.Studio"
        "org.gnome.seahorse.Application"
        "com.usebottles.bottles"
        "org.localsend.localsend_app"
        "org.gnome.dspy"
        "org.keepassxc.KeePassXC"
        "org.gnome.FileRoller"
        "org.gnome.Evince"
        "org.gnome.Loupe"
        "io.github.flattool.Warehouse"
        "io.freetubeapp.FreeTube"
        "org.prismlauncher.PrismLauncher"
        "org.gimp.GIMP"
        "org.libreoffice.LibreOffice"
        "io.gitlab.librewolf-community"
        "eu.betterbird.Betterbird"
        "io.mpv.Mpv"
        "com.calibre_ebook.calibre"
        "io.github.ungoogled_software.ungoogled_chromium"
        "org.virt_manager.virt-manager"
        "page.codeberg.dnkl.foot"
        "org.kde.kdenlive"
        "org.remmina.Remmina"
        "org.onlyoffice.desktopeditors"
        "io.dbeaver.DBeaverCommunity"
        "com.visualstudio.code"
        "com.getpostman.Postman"
        "io.httpie.Httpie"
      ]
      ++
      [{ appId = "org.gnome.Nautilus.Devel"; origin = "gnome-nightly"; }];
      remotes = [{ name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
        { name = "gnome-nightly"; location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo"; }];
      overrides = {
        "ca.desrt.dconf-editor" = { Context.filesystems = [ "~/.config/dconf/user:ro" ]; "Session Bus Policy"."org.freedesktop.Flatpak" = "none"; };
        "com.github.tchx84.Flatseal" = { Context.filesystems = [ "/nix/store:ro" ]; };
        "com.obsproject.Studio" = { Context.filesystems = [ "!xdg-config/kdeglobals" "xdg-videos" "!host" "~/backup/Flatpaks/obs-studio" ]; "Session Bus Policy"."org.freedesktop.Flatpak" = "none"; };
        "com.userbottles.bottles" = { Context.filesystems = [ "!xdg-download" "~/backup/Flatpaks/bottles" ]; };
        "io.gitlab.librewolf-community" = { Context = { devices = [ "all" ]; filesystems = [ "/nix/store:ro" "xdg-run/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer:ro" "~/.local/flatpak:ro" "~/.nix-profile:ro" ]; }; Environment.PATH = "${home.homeDirectory}/.local/flatpak:/app/bin:/usr/bin"; };
        "org.gimp.GIMP" = { Context.filesystems = [ "!xdg-run/gvfs" "!xdg-run/gvfsd" "!/tmp" "!xdg-config/gtk-3.0" "!xdg-config/GIMP" "xdg-pictures" "!host" ]; };
        "org.gnome.Loupe" = { Context.filesystems = [ "!xdg-run/gvfs" "!xdg-run/gvfsd" "!host" ]; };
        "org.gnome.Evince" = { Context.filesystems = [ "!/run/media" "!xdg-run/gvfsd" "!/media" "!home" ]; };
        "org.gnome.FileRolles" = { Context.filesystems = [ "!home" ]; };
        "org.gnome.TextEditor" = { Context.filesystems = [ "!xdg-run/gvfsd" "!host" ]; };
        "org.keepassxc.KeePassXC" = { Context = { devices = [ "!all" "dri" ]; filesystems = [ "!xdg-config/kdeglobals" "/nix/store:ro" "!host" ]; }; };
        "org.prismlauncher.PrismLauncher" = { Context.filesystems = [ "~/backup/Games/Minecraft" ]; };
        "com.calibre_ebook.calibre" = { Context.filesystems = [ "~/backup/Flatpaks/calibre" "~/backup/Books" "!host" ]; };
        "eu.betterbird.Betterbird" = { Context.filesystems = [ "~/backup/Flatpaks/.thunderbird" ]; };
        "io.github.ungoogled_software.ungoogled_chromium" = { Context.filesystems = [ "!xdg-desktop" "!xdg-run/pipewire-0" "!~/.local/share/icons" "!xdg-run/dconf" "!xdg-download" "!~/.config/dconf" "!/run/.heim_org.h5l.kcm-socket" "!~/.local/share/applications" "!/tmp" "!~/.config/kioslaverc" "~/Downloads" "/nix/store:ro" "~/.local/flatpak:ro" ]; Environment.PATH = "/home/riky/.local/flatpak:/app/bin:/usr/bin"; };
        "org.virt_manager.virt-manager" = { Environment.LIBVIRT_DEFAULT_URI = "qemu:///system"; };
        "page.codeberg.dnkl.foot" = { Context.filesystems = [ "xdg-config/foot:ro" "~/.local/flatpak:ro" "/nix/store:ro" ]; Environment.PATH = "/home/riky/.local/flatpak:/app/bin:/usr/bin"; };
      };
      uninstallUnmanaged = true;
    };

    systemd.user.services = {
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
          ExecStart = "sh -c 'podman build -t radicale ${./docker} -f radicale.dockerfile && podman run --name radicale --rm -p 127.0.0.1:5232:5232 -v ${home.homeDirectory}/backup/phone/Drive/DecSync:/decsync:O -v ${home.homeDirectory}/.local/share/radicale/collections:/collections --read-only radicale'";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
      dovecot = {
        Unit = {
          Description = "Dovecot server";
        };
        Service = {
          ExecStart = "sh -c 'podman run -p 31995:31995 -p 127.0.0.1:31143:31143 -v ${home.homeDirectory}/backup/Mail/dovecot.conf:/etc/dovecot/conf.d/dovecot.conf:ro -v ${home.homeDirectory}/backup/Mail/maildir:/srv/vmail/riky/Maildir:O,upperdir=${home.homeDirectory}/.dovecot/upper,workdir=${home.homeDirectory}/.dovecot/work --rm --env USER_PASSWORD=$(${home.homeDirectory}/.local/bin/password show -a Password dovecot) --name dovecot docker.io/dovecot/dovecot:latest'";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
    };

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
      defaultPref("webgl.disabled", false);
      defaultPref("security.OCSP.require", false);
      defaultPref("privacy.clearOnShutdown_v2.cache", true);
      defaultPref("privacy.clearOnShutdown_v2.cookiesAndStorage", true);
      defaultPref("network.http.referer.XOriginPolicy", 2);
      defaultPref("browser.sessionstore.resume_from_crash", false);
      defaultPref("media.autoplay.blocking_policy", 2);
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


    home.file.".local/bin/startup.sh" = {
      source = ./startup.sh;
      executable = true;
    };
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
    home.file.".local/bin/xdg-open" = {
      text = ''
        #!/usr/bin/env bash
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
    home.file.".local/flatpak/foot-wrapper.sh" = {
      text = "#!/bin/sh\n exec /app/bin/foot --app-id=page.codeberg.dnkl.foot \"$@\" /app/bin/host-spawn -cwd ${home.homeDirectory}/backup/Documents ${pkgs.tmux}/bin/tmux new-session -As default 'exec ${pkgs.yazi}/bin/yazi' ";
      executable = true;
    };



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
      LockDatabaseIdle=false
    '';

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
        sudo bash -c 'cp ${pkgs.qFlipper}/etc/udev/rules.d/42-flipperzero.rules /etc/udev/rules.d/42-flipperzero.rules'
        sudo bash -c 'cp ${./51-android.rules} /etc/udev/rules.d/51-android.rules'
        sudo udevadm control --reload-rules
        sudo udevadm trigger
      '';
    };
    home.file.".local/nix-sources/packages" = {
      text = ''
        base
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
        intel-ucode
        reflector
        intel-media-driver
        util-linux
        flatpak
        polkit
        podman
        pipewire
        wireplumber
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
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        pacman-contrib
        ddcutil'';
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
      text = ''
        [terminal]
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
      package = pkgs.nix;
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
        # ln -sfT "${./ungoogled_chromium.jsonc}" "${home.homeDirectory}/.local/share/flatpak/app/io.github.ungoogled_software.ungoogled_chromium/current/active/files/chromium/policies/policies/managed/policies.json"

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

        mkdir -p '${home.homeDirectory}/.dovecot/upper' '${home.homeDirectory}/.dovecot/work'
      '';
    };
  };

in
homeManager
