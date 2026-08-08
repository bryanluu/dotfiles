local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font: adjust to whatever you were using in iTerm2 — this is a common default
config.font = wezterm.font("JetBrains Mono")
config.font_size = 13.0

-- Color scheme: a dark theme close to iTerm2 defaults; browse more with `wezterm ls-fonts --list-fonts`
-- or `wezterm show-keys` for keybinding reference. Full scheme list: https://wezterm.org/colorschemes/
config.color_scheme = "Tokyo Night"

-- Scrollback, since you'll likely want history when not using tmux
config.scrollback_lines = 10000

-- Only show tab bar when there's more than one tab (cleaner when you're mostly in tmux anyway)
config.hide_tab_bar_if_only_one_tab = true

return config

