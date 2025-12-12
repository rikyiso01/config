{ config, pkgs, lib, pwndbg, ... }:

{
  imports = [ ../nix/home.nix ];
  programs.git = {
    enable = true;
    settings = {
      user.name = "rikyiso01";
      user.email = "rikyiso01@noreply.codeberg.org";
      init.defaultBranch = "main";
    };
  };
}
