{ config, pkgs, lib, pwndbg, ... }:

{
  imports = [ ../nix/home.nix ];
  programs.git = {
    settings = {
      user.name = "r.isola";
      user.email = "r.isola@reply.it";
    };
    includes = [
      {
        condition = "gitdir:/mnt/c/Users/r.isola/Documents/config/";
        contents = {
          user = {
            name = "rikyiso01";
            email = "rikyiso01@noreply.codeberg.org";
          };
        };
      }
    ];
  };
}
