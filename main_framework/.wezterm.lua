local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'MaterialDarker'
config.default_cursor_style = 'BlinkingBar'
config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

return config
