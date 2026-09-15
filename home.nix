{ inputs, pkgs, ... }:
{
  home.username = "romanzinin";
  home.homeDirectory = "/home/romanzinin";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    inputs.zen-browser.packages.x86_64-linux.default
    git

    # int128/kubelogin has a different name
    (runCommand "kubelogin-alias" {} ''
      mkdir -p $out/bin
      ln -s ${kubelogin-oidc}/bin/kubectl-oidc_login $out/bin/kubelogin
    '')
  ];

  imports = [
    ./modules/ghostty/ghostty.nix
    ./modules/zsh/zsh.nix
    ./modules/fastfetch/fastfetch.nix
    ./modules/starship/starship.nix
  ];
}
