{ config, lib, pkgs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "riky";
  users.users.riky = {
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  system.stateVersion = "25.05";
}
