#!/usr/bin/env fish

set workspace ~/Work/FERRARI/FERRARI_GT/Reply.Ferrari.AppSKI/Reply.Ferrari.AppSKI
set migrations ~/Work/FERRARI/migrations/ski

ssh homeassistant.riccardoisola.dev docker start teams

hyprctl dispatch exec flatpak run io.github.ungoogled_software.ungoogled_chromium
sleep 2
hyprctl dispatch movetoworkspace 2

hyprctl dispatch exec flatpak run org.remmina.Remmina ~/.var/app/org.remmina.Remmina/data/remmina/group_rdp_work-laptop-remote_homeassistant-riccardoisola-dev.remmina
sleep 2
hyprctl dispatch movetoworkspace 3
hyprctl dispatch exec flatpak run io.dbeaver.DBeaverCommunity

tmux select-window -t 0 \; select-pane -t 0 \; send-keys 'tt1gw'
tmux new-window -c $workspace \; send-keys 'nvim Controllers/HomeController.cs' 'Enter' \; split-window -h -c $workspace \; select-pane -t 0 \; resize-pane -Z
tmux new-window -c $workspace \; send-keys 'dotnet watch run' 'Enter' \; split-window -h -c $workspace \; send-keys 'dotnet run -p ../../Reply.Ferrari.MQ.AppLandingAuth' 'Enter' \; select-pane -t 0 \; resize-pane -Z
tmux new-window -c $migrations \; send-keys 'nvim' 'Enter' \; split-window -h -c $migrations \; select-pane -t 0 \; resize-pane -Z
tmux new-window -t 5 -c ~ \; send-keys 'ncmpcpp' 'Enter' \; split-window -h -c ~ \; send-keys 'ssh -N homeassistant.riccardoisola.dev -L1144:localhost:1144' 'Enter' \; select-pane -t 0 \; resize-pane -Z
sleep 2

flatpak run io.gitlab.librewolf-community --new-tab http://127.0.0.1:1144/vnc.html
flatpak run io.gitlab.librewolf-community --new-tab https://localhost:7202

exit
