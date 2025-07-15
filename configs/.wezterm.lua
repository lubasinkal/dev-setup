-- wezterm.lua: Highly customized config for wezterm with full oxocarbon colors, UI/productivity tweaks

local wezterm = require("wezterm")

return {

	-- Color and Appearance
	colors = {
		cursor_bg = "white",
		cursor_border = "white",
	},
	color_scheme = "Pico (base16)",
	command_palette_rows = 10,
	max_fps = 60,

	font = wezterm.font_with_fallback({
		{
			family = "GeistMono Nerd Font Propo",
			weight = "Medium",
		},
		{
			family = "JetBrainsMono Nerd Font Mono",
			weight = "Medium",
			-- italic = true,
		},
		"FiraCode Nerd Font",
		"DengXian",
	}),
	font_size = 14,
	window_background_opacity = 0.9,
	-- win32_system_backdrop = "Tabbed",
	window_decorations = "RESIZE",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	hide_tab_bar_if_only_one_tab = true,
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	automatically_reload_config = true,
	use_resize_increments = true,
	window_close_confirmation = "NeverPrompt",

	-- Cursor
	default_cursor_style = "BlinkingBar",

	-- Scrollback
	scrollback_lines = 5000,

	-- Productivity: Key Bindings
	keys = {
		-- Pane splitting
		{
			key = "d",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "d", mods = "CTRL|ALT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

		-- Pane navigation
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		-- Tab management
		{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
		{ key = "q", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
		{ key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },

		-- Quick reload config
		{ key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
	},

	-- Dim inactive panes for focus
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.5,
	},
	-- Launch menu
	launch_menu = {
		{
			label = "Powershell",
			args = { "pwsh", "-NoProfileLoadTime", "-NoLogo" },
		},
		{
			label = "Nushell",
			args = { "nu" },
		},
		{
			label = "Bash",
			args = { "bash.exe", "-i", "-l" },
		},
	},

	-- Default shell
	default_prog = { "bash" },
	default_domain = "local",
	-- Always close panes without prompt (event handler)
	wezterm.on("mux-is-process-stateful", function(_)
		return false
	end),
}
