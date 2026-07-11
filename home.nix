{ inputs, pkgs, ... }:
{
  home.username = "romanzinin";
  home.homeDirectory = "/home/romanzinin";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    inputs.zen-browser.packages.x86_64-linux.default
    git
  ];

  imports = [
    ./modules/ghostty/ghostty.nix
    ./modules/zsh/zsh.nix
    ./modules/fastfetch/fastfetch.nix
    ./modules/starship/starship.nix
  ];
}
