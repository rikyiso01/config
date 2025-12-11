{ config, lib, pkgs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "riky";
  users.users.riky = {
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
