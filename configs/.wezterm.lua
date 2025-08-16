-- wezterm.lua: Enhanced, clean, and productive config

local wezterm = require("wezterm")

local config = {}

-- ========= Appearance =========
config.color_scheme = "Oxocarbon Dark" -- full oxocarbon colorscheme, easier on eyes
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
	{ family = "JetBrainsMono Nerd Font Mono", weight = "Medium" },
	"SpaceMono Nerd Font",
	"FiraCode Nerd Font",
	"DengXian",
})
config.command_palette_font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font Mono", weight = "Medium" },
	"SpaceMono Nerd Font",
	"FiraCode Nerd Font",
	"DengXian",
})

config.command_palette_bg_color = "#000000"
config.command_palette_rows = 10
config.font_size = 13
config.max_fps = 120
config.window_background_opacity = 0.92
config.win32_system_backdrop = "Mica"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.window_padding = { left = 2, right = 2, top = 0, bottom = 0 }

-- ========= Cursor =========
config.default_cursor_style = "BlinkingBar"
config.animation_fps = 60
config.cursor_blink_rate = 600 -- slower blink, less distracting

-- ========= Scrollback =========
config.scrollback_lines = 10000

-- ========= Productivity =========
-- Define leader key (like tmux) for multi-key combos
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }

config.keys = {
	-- Pane splitting
	{ key = "d", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Pane navigation
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },

	-- Tab management
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{ key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },

	-- Workspace support (like projects)
	{ key = "s", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },

	-- Quick reload config
	{ key = "r", mods = "LEADER", action = wezterm.action.ReloadConfiguration },
}

-- ========= Behavior =========
config.automatically_reload_config = true
config.use_resize_increments = true
config.window_close_confirmation = "NeverPrompt"
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.5 }

-- ========= Launch Menu =========
config.launch_menu = {
	{ label = "Powershell", args = { "pwsh", "-NoLogo" } },
	{ label = "Nushell", args = { "nu" } },
	{ label = "Bash", args = { "bash.exe", "-i", "-l" } },
}

-- ========= Default shell =========
config.default_prog = { "bash" }
config.default_domain = "local"

-- No prompts on closing panes
wezterm.on("mux-is-process-stateful", function(_)
	return false
end)

return config
