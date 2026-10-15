-- Modules in ~/.config/hypr-personal (linked by dotfiles-personal/install.sh) shadow the ones here
package.path = os.getenv("HOME") .. "/.config/hypr-personal/?.lua;" .. package.path

require("env")
require("programs")
require("keybinds")
require("general")
require("rules")
require("autostart")
require("input")
require("monitors")
