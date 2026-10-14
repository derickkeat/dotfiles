#!/usr/bin/env bash
# Install dependencies, then symlink the configs in this repo into place.
set -euo pipefail

pkgs=(
	# Hyprland and the must-haves from https://wiki.hypr.land/useful-utilities/must-have/
	hyprland
	mako                        # notifications; started in hypr/autostart.lua
	pipewire wireplumber        # screen sharing; wpctl for the volume keys
	xdg-desktop-portal-hyprland
	xdg-desktop-portal-kde      # file picker, which XDPH doesn't implement (see xdg-desktop-portal/)
	hyprpolkitagent
	qt5-wayland qt6-wayland
	noto-fonts                  # without a font, text renders as squares

	# Programs hypr/ launches
	ghostty dolphin hyprlauncher    # programs.lua
	hyprshutdown                    # SUPER + M
	brightnessctl playerctl         # media keys in keybinds.lua (wpctl comes with wireplumber)

	# nvim-treesitter compiles parsers with the tree-sitter CLI
	tree-sitter-cli
)
sudo pacman -S --needed "${pkgs[@]}"

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
link "$DOTFILES/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"
