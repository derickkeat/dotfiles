#!/usr/bin/env bash
# Symlink the configs in this repo into place.
set -euo pipefail

DOTFILES="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# link <source> <target>: point <target> at <source>, backing up whatever is already there
link() {
	local src="$1" dest="$2"

	if [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
		echo "ok      $dest -> $src"
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

link "$DOTFILES/nvim" "$HOME/.config/nvim"
