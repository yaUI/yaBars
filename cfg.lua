local addon, ns = ...
local E, M = unpack(yaCore);
local cfg = CreateFrame("Frame")

--ActionBars config  
cfg.yaB = {
	size = 30,						-- setting up default buttons size
	spacing = 2, 					-- spacing between buttons
	media = {						-- MEDIA
		textures_normal = M:Fetch("yaui", "baricon"),
		textures_pushed = M:Fetch("yaui", "baricon"),
		textures_btbg = "Interface\\Buttons\\WHITE8x8",
		button_font = M:Fetch("font", "Helvetica"),
		},
}

cfg.bars = {
["Bar1"] = {
	hide_bar = false,				show_in_combat = false,
	show_on_mouseover = false,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "HORIZONTAL",		rows = 1,					buttons = 12,	
	button_size = cfg.yaB.size,		button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=0, y=154},
	custom_visibility_macro = false	-- set a custom visibility macro for this bar or 'false' to disable 
									-- (e.g. "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists]hide;show")
	},
["Bar2"] = {
	hide_bar = false,				show_in_combat = false,
	show_on_mouseover = false,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "HORIZONTAL",		rows = 2,					buttons = 12,	
	button_size = cfg.yaB.size-2,	button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=-96, y=50},
	custom_visibility_macro = false
	},
["Bar3"] = {
	hide_bar = false,				show_in_combat = false,
	show_on_mouseover = false,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "HORIZONTAL",		rows = 2,					buttons = 12,	
	button_size = cfg.yaB.size-2,	button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=96, y= 50},
	custom_visibility_macro = false
	},
["Bar4"] = {
	hide_bar = false,				show_in_combat = false,
	show_on_mouseover = false,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "HORIZONTAL",		rows = 1,					buttons = 12,	
	button_size = cfg.yaB.size,		button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=0, y= 119},
	custom_visibility_macro = false
	},
["Bar5"] = {
	hide_bar = true,				show_in_combat = false,
	show_on_mouseover = false,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "HORIZONTAL",		rows = 1,					buttons = 12,	
	button_size = 30,				button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=0, y=-119},
	custom_visibility_macro = false
	},
["Bar6"] = {
	hide_bar = true,				show_in_combat = false,
	show_on_mouseover = false,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "HORIZONTAL",		rows = 1,					buttons = 12,	
	button_size = cfg.yaB.size,		button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=0, y=-119},
	custom_visibility_macro = false
	},
["StanceBar"] = {
	hide_bar = false,				show_in_combat = false,
	show_on_mouseover = false,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "HORIZONTAL",		rows = 1,					buttons = 6,	
	button_size = cfg.yaB.size,		button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=-96, y=190},
	custom_visibility_macro = false
	},
["PetBar"] = {
	hide_bar = false,				show_in_combat = false,		scale = 0.8,
	show_on_mouseover = true,		bar_alpha = 1,				fadeout_alpha = 0.3,
	orientation = "HORIZONTAL",		rows = 1,					buttons = NUM_PET_ACTION_SLOTS, 
	button_size = cfg.yaB.size,		button_spacing = cfg.yaB.spacing,
	position = {a="BOTTOM", x=0, y=3},
	custom_visibility_macro = false
	},
["MicroMenu"] = {
	hide_bar = false,				show_on_mouseover = true,	scale = 0.85,
	lock_to_CharacterFrame = false,					-- position MicroMenu bar right on top of your CharacterFrame
	position = {a="TOP", x=0, y=0},  	-- if not locked
	},
	
["ExitVehicleButton"] = {
	disable = false,				user_placed = true,	-- if user_placed is set to false exit vehicle button will be 'docked' into bar1	
	position = {a="BOTTOM", x=-380, y=238}, 			-- only if user_placed = true
	button_size = 28,									-- only if user_placed = true
	},
["ExtraButton"] = {
	disable = false,
	position = {a="BOTTOM", x=0, y=225},
	},

["RaidIconBar"] = {
	hide = true,					in_group_only = true,
	show_on_mouseover = true,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "VERTICAL",		rows = 1,
	button_size = 20,				button_spacing = 3,
	position = {a="RIGHT", x=-10, y=-77},
	},
["WorldMarkerBar"] = {
	hide = true,					disable_in_combat = true,	
	show_on_mouseover = true,		bar_alpha = 1,				fadeout_alpha = 0.5,
	orientation = "VERTICAL",		rows = 1,
	button_size = 23,				button_spacing = cfg.yaB.spacing,
	position = {a="RIGHT", x=-10, y=-312},
	},
}

--ButtonsStyler config
cfg.buttons = {
hide_hotkey = false,		-- remove key binding text from the bars
hide_macro_name = true,		-- remove macro name text from the bars
count_font_size = 12,		-- remove count text from the bars
hotkey_font_size = 13,		-- font size for the key bindings text
name_font_size = 8,			-- font size for the macro name text
colors = {	--R,G,B
	   normal = {0,0,0},
	   pushed = {1,1,1},
	highlight = {.9,.8,.6},
	  checked = {.9,.8,.6},
   outofrange = {.8,.3,.2},
	outofmana = {.3,.3,.7},
	   usable = {1,1,1},
	 unusable = {.4,.4,.4},
	 equipped = {.3,.6,.3}
  }
}

-- HANDOVER
ns.cfg = cfg
