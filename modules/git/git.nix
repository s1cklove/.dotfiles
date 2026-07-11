{ ... }:
{
  programs.git = {
    enable = true;

    config.user = {
        name  = "<your-name>";
        email = "<your-email>";
    };

    settings.alias = {
      cm = "commit -m";
      co = "checkout";
      s = "status";
    };

    signing = {
      key = "<your-ssh-signing-key-pub>";  # run: cat ~/.ssh/id_ed25519.pub
      signByDefault = true;
    };

    settings.gpg.format = "ssh";
  };
}