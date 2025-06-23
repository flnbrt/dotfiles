local wezterm = require('wezterm')
local config = {}
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- use operating system Input Method Editor
-- and allow the left modifier keys on macOS
config.use_ime = true
config.send_composed_key_when_left_alt_is_pressed = true

-- fonts
config.font = wezterm.font 'Hack Nerd Font Mono'
config.font_size = 14

-- tab bar style
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- other appearance settings
config.macos_window_background_blur = 30

-- window size
config.initial_cols = 136
config.initial_rows = 42

-- colorscheme
config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte

-- plugins
-- tabline
tabline.setup()

-- return config to wezterm
return config
