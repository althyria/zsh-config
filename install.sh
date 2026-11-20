#!/bin/sh
set -eu

# ---------- pretty output ----------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    B=$(printf '\033[1m');  D=$(printf '\033[2m');  R=$(printf '\033[0m')
    MAUVE=$(printf '\033[38;2;203;166;247m'); ROSE=$(printf '\033[38;2;245;194;231m')
    GREEN=$(printf '\033[38;2;166;227;161m'); RED=$(printf '\033[38;2;243;139;168m')
    YELLOW=$(printf '\033[38;2;249;226;175m'); BLUE=$(printf '\033[38;2;137;180;250m')
else
    B=''; D=''; R=''; MAUVE=''; ROSE=''; GREEN=''; RED=''; YELLOW=''; BLUE=''
fi

banner() { printf '\n%s%s╭─────────────────────────────╮\n│   %s✦   dotfiles installer%s%s%s    │\n╰─────────────────────────────╯%s\n' "$B" "$MAUVE" "$ROSE" "$MAUVE" "$B" "" "$R"; }
step()   { printf '\n%s%s▸ %s%s\n' "$B" "$BLUE" "$1" "$R"; }
info()   { printf '  %s•%s %s\n' "$MAUVE" "$R" "$1"; }
ok()     { printf '  %s✔%s %s\n' "$GREEN" "$R" "$1"; }
warn()   { printf '  %s!%s %s\n' "$YELLOW" "$R" "$1"; }
die()    { printf '  %s✘ %s%s\n' "$RED" "$1" "$R" >&2; exit 1; }

trap 'printf "\n  %s✘ Failed on line %s%s\n" "$RED" "$LINENO" "$R" >&2' EXIT

banner

# ---------- detect distro ----------
step "Detecting system"
[ -r /etc/os-release ] || die "Cannot read /etc/os-release"
. /etc/os-release
info "${PRETTY_NAME:-$ID}"

DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
ZSH_DIR="$HOME/.config/zsh"

SUDO=sudo
command -v sudo >/dev/null 2>&1 || SUDO=doas

# ---------- dependencies ----------
step "Installing dependencies"
case "$ID ${ID_LIKE:-}" in
  *debian*|*ubuntu*)
    info "apt-get update"
    $SUDO apt-get update -qq
    for pkg in zsh fzf starship; do
        info "installing ${B}$pkg${R}"
        $SUDO apt-get install -y -qq "$pkg" >/dev/null
        ok "$pkg"
    done
    ;;
  *gentoo*)
    for pkg in app-shells/zsh app-shells/fzf app-shells/starship; do
        info "installing ${B}$pkg${R}"
        $SUDO emerge -qn "$pkg"
        ok "$pkg"
    done
    ;;
  *)
    die "Unsupported or unknown distribution: ${ID:-unknown}"
    ;;
esac

# ---------- symlinks ----------
step "Linking dotfiles"
mkdir -p "$ZSH_DIR"
for f in .zprofile .zsh_plugins.txt .zshrc; do
    ln -sf "$DOTFILES_DIR/$f" "$ZSH_DIR/$f"
    ok "$f ${D}→ $ZSH_DIR/$f${R}"
done
# starship only reads ~/.config/starship.toml (or $STARSHIP_CONFIG)
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
ok "starship.toml ${D}→ $HOME/.config/starship.toml${R}"

# ---------- ZDOTDIR ----------
step "Setting ZDOTDIR"
line='export ZDOTDIR="$HOME/.config/zsh"'
if grep -qxF "$line" "$HOME/.zshenv" 2>/dev/null; then
    ok "already set in ~/.zshenv"
else
    echo "$line" >> "$HOME/.zshenv"
    ok "added to ~/.zshenv"
fi

# ---------- done ----------
trap - EXIT
printf '\n%s%s✦ All done!%s Open a new terminal to see it.\n' "$B" "$GREEN" "$R"
case "${SHELL:-}" in
  *zsh) ;;
  *) warn "zsh isn't your login shell yet: chsh -s \$(command -v zsh)" ;;
esac
printf '\n'
