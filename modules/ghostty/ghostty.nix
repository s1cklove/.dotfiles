{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title";

      window-padding-x = 12;
      window-padding-y = 10;

      quit-after-last-window-closed = true;
      mouse-hide-while-typing = true;

      theme = "Everforest Dark Hard";
    };
  };
}