#!/usr/bin/env bash
# Install dependencies, then symlink the configs in this repo into place.
set -euo pipefail

pkgs=(
	# Hyprland and the must-haves from https://wiki.hypr.land/useful-utilities/must-have/
	hyprland
	mako                        # notifications; started in hypr/autostart.lua
	quickshell                  # bar; started in hypr/autostart.lua
	pipewire wireplumber        # screen sharing; wpctl for the volume keys
	pipewire-audio              # sound card support, which pipewire lacks on its own
	pipewire-pulse pipewire-alsa
	pipewire-jack               # ffmpeg needs a JACK provider; pacman would otherwise offer jack2
	xdg-desktop-portal-hyprland
	xdg-desktop-portal-gtk      # file picker, which XDPH doesn't implement
	hyprpolkitagent
	qt5-wayland qt6-wayland
	noto-fonts                  # without a font, text renders as squares

	# Programs hypr/ launches
	ghostty nautilus hyprlauncher   # programs.lua
	hyprshutdown                    # SUPER + M
	hyprshot                        # SUPER + S and SUPER + SHIFT + S
	brightnessctl playerctl         # media keys in keybinds.lua (wpctl comes with wireplumber)

	firefox
	git less
	neovim ripgrep
	tmux

	# nvim-treesitter compiles parsers with the tree-sitter CLI, using base-devel's C compiler
	tree-sitter-cli base-devel
)
sudo pacman -Syu --needed "${pkgs[@]}"

DOTFILES="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# link <source> <target>: point <target> at <source>, backing up whatever is already there
link() {
	local src="$1" dest="$2"

	if [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
		echo "linked  $dest -> $src"
		return
	fi

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		local backup
		backup="$dest.bak-$(date +%Y%m%d%H%M%S)"
		mv "$dest" "$backup"
		echo "backup  $dest -> $backup"
	fi

	mkdir -p "$(dirname "$dest")"
	ln -s "$src" "$dest"
	echo "linked  $dest -> $src"
}

link "$DOTFILES/hypr" "$HOME/.config/hypr"
link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/quickshell" "$HOME/.config/quickshell"

# Private overrides from the dotfiles-personal submodule; a non-recursive clone leaves it empty
if [ -f "$DOTFILES/dotfiles-personal/install.sh" ]; then
	source "$DOTFILES/dotfiles-personal/install.sh"
fi
