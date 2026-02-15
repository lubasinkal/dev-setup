-- wezterm.lua: Enhanced, clean, and productive config

local wezterm = require("wezterm")

local config = {}

-- ========= Appearance =========
config.color_scheme = "Oxocarbon Dark (Gogh)"
config.colors = {
	cursor_bg = "#ffffff",
	cursor_border = "#ffffff",
	tab_bar = {
		background = "#000000",
		new_tab = {
			bg_color = "#000000",
			fg_color = "#ffffff",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},
		active_tab = {
			bg_color = "#3c3c3c",
			fg_color = "#ffffff",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#1e1e1e",
			fg_color = "#808080",
		},
	},
}
config.font = wezterm.font_with_fallback({
	{ family = "SpaceMono Nerd Font", weight = "Medium" },
	"JetBrainsMono Nerd Font",
})
config.command_palette_bg_color = "#000000"
config.command_palette_rows = 10
config.font_size = 12
config.window_background_opacity = 0.95
-- config.win32_system_backdrop = "Mica"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.window_padding = { left = 2, right = 2, top = 0, bottom = 0 }

-- ========= Cursor =========
config.default_cursor_style = "BlinkingBar"
-- ========= Behavior =========
config.automatically_reload_config = true
config.use_resize_increments = true
config.window_close_confirmation = "NeverPrompt"
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.5 }

-- ========= Launch Menu =========
config.launch_menu = {
	{ label = "Powershell", args = { "pwsh", "-NoLogo" } },
	{ label = "Nushell", args = { "nu" } },
	{ label = "Bash", args = { "C:\\Program Files\\Git\\usr\\bin\\bash.exe", "-i", "-l" } },
}

local act = wezterm.action

config.keys = {
	-- Pane splitting
	{ key = "d", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Turn off the default ctrl+v "input the next character literally",
	-- because it works badly with the Windows Clipboard Manager Win+v.
	{ key = "v", mods = "CTRL", action = wezterm.action.Nop },
	-- Pane navigation
	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },

	-- Tab management
	{ key = "c", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "q", mods = "ALT", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "n", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "ALT", action = act.ActivateTabRelative(-1) },

	-- Reload config
	{ key = "r", mods = "ALT", action = act.ReloadConfiguration },
}

-- ========= Default shell =========
config.default_prog = { "C:\\Program Files\\Git\\usr\\bin\\bash.exe" }
config.default_domain = "local"

-- No prompts on closing panes
wezterm.on("mux-is-process-stateful", function(_)
	return false
end)

return config
