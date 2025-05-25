-- wezterm.lua: Highly customized config for wezterm with full oxocarbon colors, UI/productivity tweaks

local wezterm = require("wezterm")

local oxocarbon_colors = {
	foreground = "#e0eddd",
	background = "#161616",
	cursor_bg = "#e0eddd",
	cursor_border = "#e0eddd",
	cursor_fg = "#161616",
	selection_bg = "#393939",
	selection_fg = "#e0eddd",
	ansi = {
		"#262626", -- black
		"#ee5396", -- red
		"#25be6a", -- green
		"#08bdba", -- yellow (cyan in oxocarbon)
		"#78a9ff", -- blue
		"#be95ff", -- magenta
		"#33b1ff", -- cyan
		"#dfdfe0", -- white
	},
	brights = {
		"#393939", -- bright black
		"#ff7eb6", -- bright red
		"#42be65", -- bright green
		"#3ddbd9", -- bright yellow/cyan
		"#82cfff", -- bright blue
		"#d4bbff", -- bright magenta
		"#52bdff", -- bright cyan
		"#ffffff", -- bright white
	},
	tab_bar = {
		background = "#1b1027", -- Deepest purple for the tab bar background
		active_tab = {
			bg_color = "#392a51", -- Medium-dark purple for active tab
			fg_color = "#e0eddd", -- Contrasting text
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#26173a", -- Slightly different dark purple for inactive tabs
			fg_color = "#bfa9de", -- Light purple text for readability
		},
		inactive_tab_hover = {
			bg_color = "#512a6d", -- Brighter purple when hovering over inactive tabs
			fg_color = "#ffffff", -- White text for clarity
			italic = true,
		},
		new_tab = {
			bg_color = "#2a1941", -- Dark purple for the new tab button
			fg_color = "#d3bfff", -- Light purple text
		},
		new_tab_hover = {
			bg_color = "#693b8c", -- Vivid purple for hover state
			fg_color = "#ffffff", -- White text
			italic = true,
		},
	},
}

return {
	-- Color and Appearance
	color_scheme = "Oxocarbon Dark (Gogh)",
	colors = oxocarbon_colors,
	command_palette_fg_color = oxocarbon_colors.foreground,
	command_palette_bg_color = oxocarbon_colors.background,
	command_palette_rows = 10,

	font = wezterm.font_with_fallback({
		{
			family = "GeistMono Nerd Font",
			weight = "Medium",
		},
		{
			family = "JetBrainsMono Nerd Font",
			weight = "Medium",
			italic = true,
		},
		"FiraCode Nerd Font",
		"DengXian",
	}),
	font_size = 14,
	window_background_opacity = 0.5,
	win32_system_backdrop = "Tabbed",
	window_decorations = "RESIZE",
	window_frame = {
		font_size = 10.0,
		active_titlebar_bg = "#262626",
		inactive_titlebar_bg = "#161616",
	},
	window_padding = {
		left = 3,
		right = 3,
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
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
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

	-- Quick select for URLs/emails
	quick_select_patterns = { "[a-zA-Z0-9-_.]+@[a-zA-Z0-9-_.]+", "https?://[\\w./?=&%-]+" },

	-- Dim inactive panes for focus
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.7,
	},

	-- Visual bell instead of audio
	visual_bell = {
		fade_in_duration_ms = 100,
		fade_out_duration_ms = 100,
		target = "CursorColor",
	},

	-- Launch menu
	launch_menu = {
		{
			label = "Powershell",
			args = { "pwsh.exe", "-NoProfileLoadTime", "-NoLogo" },
		},
		{
			label = "Nushell",
			args = { "nu.exe" },
		},
		{
			label = "Bash",
			args = { "C:\\Program Files\\Git\\bin\\bash.exe", "-i", "-l" },
		},
	},

	-- Default shell
	default_prog = { "nu.exe" },

	-- Always close panes without prompt (event handler)
	wezterm.on("mux-is-process-stateful", function(_)
		return false
	end),
}
