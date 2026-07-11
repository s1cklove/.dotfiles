# s1cklove's dots

NixOS + home-manager configuration. Built on [niri](https://github.com/YaLTeR/niri) + [noctalia](https://github.com/noctalia-dev/noctalia).

## Configure on your own

- [ ] `modules/git/git.nix` — `<your-name>` and `<your-email>`
- [ ] `modules/git/git.nix` — `<your-ssh-signing-key-pub>` (run `cat ~/.ssh/id_ed25519.pub`)
- [ ] `modules/niri/config/output.kdl` — monitor names, resolutions, and positions (run `niri msg outputs` to list yours)
- [ ] `modules/noctalia/noctalia.json` — `"avatarImage"` path (currently points to `/home/romanzinin/.face`)
- [ ] `modules/noctalia/noctalia.json` — wallpaper `"directory"` path
- [ ] `modules/noctalia/noctalia.json` — weather `"name"` location (currently `"Marseille, France"`)
- [ ] `configuration.nix` — username `romanzinin` in `users.users` and `sudo.extraRules`
- [ ] `home.nix` — `home.username` and `home.homeDirectory`
- [ ] `flake.nix` — hostname `romanzinin` in `nixosConfigurations` (or pass your own with `--flake .#yourhostname`)
- [ ] `hardware-configuration.nix` — rebuild:
```sh
nixos-generate-config --show-hardware-config
```
