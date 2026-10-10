-- remap sets the leader keys, so it must load before lazy.nvim maps plugin keys
require("remap")
require("options")

require("config.lazy")
