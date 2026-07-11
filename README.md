# s1cklove's dots

NixOS + home-manager configuration. Built on [niri](https://github.com/YaLTeR/niri) + [noctalia](https://github.com/noctalia-dev/noctalia).

## Configure on your own

- `modules/git/git.nix` — `<your-name>` and `<your-email>`
- `modules/git/git.nix` — `<your-ssh-signing-key-pub>`
- `modules/niri/config/output.kdl` — monitor names, resolutions, and positions (run `niri msg outputs`)
- `modules/noctalia/noctalia.json` — `"avatarImage"` path
- `modules/noctalia/noctalia.json` — wallpaper `"directory"` path
- `configuration.nix` — username `romanzinin` in `users.users` and `sudo.extraRules` (...actually just grep my username)
- `home.nix` — `home.username` and `home.homeDirectory`
- `flake.nix` — hostname `romanzinin` in `nixosConfigurations` (or pass your own with `--flake .#yourhostname`)
- `hardware-configuration.nix` — rebuild:
```sh
nixos-generate-config --show-hardware-config
```
