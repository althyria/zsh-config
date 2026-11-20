<div align="center">

# ✦ dotfiles

*my zsh setup, one command away*

![shell](https://img.shields.io/badge/shell-zsh-cba6f7?style=flat-square)
![prompt](https://img.shields.io/badge/prompt-starship-f5c2e7?style=flat-square)
![distros](https://img.shields.io/badge/distros-debian%20%7C%20gentoo-89b4fa?style=flat-square)

</div>

---

## ✿ What's inside

| File | Purpose |
| --- | --- |
| `starship.toml` | prompt config |
| `.zshrc` | interactive shell config |
| `.zprofile` | login shell environment |
| `.zsh_plugins.txt` | zsh plugin list |
| `install.sh` | installs dependencies and links everything |

## ❯ Install

```sh
git clone https://github.com/althyria/zsh-config ~/.repo
cd ~/.repo
./install.sh
```

Then open a new terminal. If zsh isn't your login shell yet:

```sh
chsh -s "$(command -v zsh)"
```

## ⚙ What the installer does

1. Detects your distro from `/etc/os-release`
2. Installs `zsh`, `fzf` and `starship`
3. Symlinks the dotfiles into `~/.config/zsh`
4. Sets `ZDOTDIR` in `~/.zshenv`

It's safe to re-run: links are refreshed and `~/.zshenv` is only appended to once.

## ☾ Supported systems

- **Debian** and derivatives (Ubuntu, Mint, …), via `apt`
- **Gentoo**, via `emerge`

Needs `sudo` or `doas`. On Debian releases before 13, `starship` isn't in the repos, so install it from [starship.rs](https://starship.rs) first.

## ✧ Tips

- Use a [Nerd Font](https://www.nerdfonts.com/) in your terminal, or prompt icons will show as boxes.
- Set `NO_COLOR=1` to get plain installer output.
- Run the script from anywhere; it finds the repo on its own.

---

<div align="center"><sub>made with ♥ and too many hours in the terminal</sub></div>
