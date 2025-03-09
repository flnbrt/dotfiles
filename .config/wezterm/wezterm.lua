local wezterm = require('wezterm')

return {
  -- fonts
  font = wezterm.font 'Hack Nerd Font Mono',
  font_size = 13,
  -- tab bar style
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,
  -- other appearance settings
  macos_window_background_blur = 30,
  -- window size
  initial_cols = 136,
  initial_rows = 42,
  -- colorscheme
  color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
}
