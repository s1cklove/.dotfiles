{ pkgs, inputs, ... }:
{
  home-manager.users.romanzinin = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = ./noctalia.json;
    };
  };
}