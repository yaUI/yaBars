local addon, ns = ...
local E, M = unpack(yaCore);
local cfg = ns.cfg
local yaB = ns.yaB

local myclass = select(2, UnitClass("player"))

--if not cfg.enable_action_bars then return end
if IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") then return end

-- enabling default action bars
local f = CreateFrame"Frame"
f:RegisterEvent("PLAYER_ENTERING_WORLD")
--f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function()
	if InCombatLockdown() then return end
	local ab1, ab2, ab3, ab4 = GetActionBarToggles()
	if (not ab1 or not ab2 or not ab3 or not ab4) then
		SetActionBarToggles(1, 1, 1, 1)
		StaticPopupDialogs.SET_AB = {
			text = "yaBars is loaded, enabling 4 additional default action bars. UI reload is required",
			button1 = ACCEPT,
			button2 = CANCEL,
			OnAccept = function() ReloadUI() end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = true,
			preferredIndex = 5,
		}
		StaticPopup_Show("SET_AB")
	end
	-- show grid
	for i = 1, 12 do
		local btn = _G[format("ActionButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarRightButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarBottomRightButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarLeftButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarBottomLeftButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("ExtraBarButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
	end
		--SHOW_MULTI_ACTIONBAR_1 = 1
		--SHOW_MULTI_ACTIONBAR_2 = 1
		--SHOW_MULTI_ACTIONBAR_3 = 1
		--SHOW_MULTI_ACTIONBAR_4 = 1
		--InterfaceOptions_UpdateMultiActionBars()
		--MultiActionBar_Update()
end)

---- Modifying default action bars
-- Creating holder frames for each bar
local mainbar = yaB.CreateHolder("Bar1_holder", cfg.bars["Bar1"].position)
local overridebar = yaB.CreateHolder("OverrideBar_holder", cfg.bars["Bar1"].position)
local bottomleftbar = yaB.CreateHolder("Bar2_holder", cfg.bars["Bar2"].position)
local bottomrightbar = yaB.CreateHolder("Bar3_holder", cfg.bars["Bar3"].position)
local leftbar = yaB.CreateHolder("Bar4_holder", cfg.bars["Bar4"].position)
local rightbar = yaB.CreateHolder("Bar5_holder", cfg.bars["Bar5"].position)
local extrabar = yaB.CreateHolder("Bar6_holder", cfg.bars["Bar6"].position)
local stancebar = yaB.CreateHolder("StanceBar_holder", cfg.bars["StanceBar"].position)
local petbar = yaB.CreateHolder("PetBar_holder", {a= cfg.bars["PetBar"].position.a, x=	cfg.bars["PetBar"].position.x*1.25, y= cfg.bars["PetBar"].position.y*1.25})
--local extrabtn = yaB.CreateHolder("ExtraBtn_holder", cfg.ExtraButton["Position"])

---- Forging action bars
-- parenting action buttons to our holders
MainMenuBarArtFrame:SetParent(mainbar)
OverrideActionBar:SetParent(overridebar)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil)
MultiBarBottomLeft:SetParent(bottomleftbar)
MultiBarBottomRight:SetParent(bottomrightbar)
MultiBarLeft:SetParent(leftbar)
MultiBarRight:SetParent(rightbar)
MultiBarRight:EnableMouse(false)
PetActionBarFrame:SetParent(petbar)
PossessBarFrame:SetParent(stancebar)
PossessBarFrame:EnableMouse(false)
StanceBarFrame:SetParent(stancebar)
StanceBarFrame:SetPoint("BOTTOMLEFT",stancebar,-12,-3)
StanceBarFrame.ignoreFramePositionManager = true

-- set up action bars
yaB.SetBar(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS,"Bar1")
yaB.SetBar(overridebar, "OverrideActionBarButton", NUM_ACTIONBAR_BUTTONS,"Bar1")
	RegisterStateDriver(overridebar, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
	RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
yaB.SetBar(bottomleftbar, "MultiBarBottomLeftButton", NUM_ACTIONBAR_BUTTONS,"Bar2")
yaB.SetBar(bottomrightbar, "MultiBarBottomRightButton", NUM_ACTIONBAR_BUTTONS,"Bar3")
yaB.SetBar(leftbar, "MultiBarLeftButton", NUM_ACTIONBAR_BUTTONS,"Bar4")
yaB.SetBar(rightbar, "MultiBarRightButton", NUM_ACTIONBAR_BUTTONS,"Bar5")
yaB.SetBar(petbar, "PetActionButton", NUM_PET_ACTION_SLOTS,"PetBar")
	petbar:SetScale(cfg.bars["PetBar"].scale or 0.80)
	RegisterStateDriver(petbar, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
yaB.SetStanceBar(stancebar, "StanceButton", NUM_STANCE_SLOTS)
	stancebar:SetScale(cfg.bars["StanceBar"].scale or 0.80)
yaB.SetStanceBar(stancebar, "PossessButton", NUM_POSSESS_SLOTS)
yaB.SetExtraBar(extrabar, "ExtraBarButton", cfg.bars["Bar6"].orientation, cfg.bars["Bar6"].rows, cfg.bars["Bar6"].buttons, cfg.bars["Bar6"].button_size, cfg.bars["Bar6"].button_spacing)
-- due to new ActionBarController introduced in WoW 5.0 we have to update the extra bar independently and lock it to page 1
	extrabar:RegisterEvent("PLAYER_LOGIN")
	extrabar:SetScript("OnEvent", function(self, event, ...)
		for id = 1, NUM_ACTIONBAR_BUTTONS do
			local name = "ExtraBarButton"..id
			self:SetFrameRef(name, _G[name])
		end
		self:Execute(([[
			buttons = table.new()
			for id = 1, %s do
				buttons[id] = self:GetFrameRef("ExtraBarButton"..id)
			end
		]]):format(NUM_ACTIONBAR_BUTTONS))
		self:SetAttribute('_onstate-page', ([[
			if not newstate then return end
			for id = 1, %s do
				buttons[id]:SetAttribute("actionpage", 1)
			end
		]]):format(NUM_ACTIONBAR_BUTTONS))
		RegisterStateDriver(self, "page", 1)
	end)

-- apply alpha and mouseover functionality
yaB.SetBarAlpha(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "Bar1")
yaB.SetBarAlpha(bottomleftbar, "MultiBarBottomLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar2")
yaB.SetBarAlpha(bottomrightbar, "MultiBarBottomRightButton", NUM_ACTIONBAR_BUTTONS, "Bar3")
yaB.SetBarAlpha(leftbar, "MultiBarLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar4")
yaB.SetBarAlpha(rightbar, "MultiBarRightButton", NUM_ACTIONBAR_BUTTONS, "Bar5")
yaB.SetBarAlpha(extrabar, "ExtraBarButton", NUM_ACTIONBAR_BUTTONS, "Bar6")
yaB.SetBarAlpha(stancebar, "StanceButton", NUM_STANCE_SLOTS, "StanceBar")
yaB.SetBarAlpha(petbar, "PetActionButton", NUM_PET_ACTION_SLOTS, "PetBar")

-- apply visibility conditions
yaB.SetVisibility("Bar1",mainbar)
yaB.SetVisibility("Bar2",bottomleftbar)
yaB.SetVisibility("Bar3",bottomrightbar)
yaB.SetVisibility("Bar4",leftbar)
yaB.SetVisibility("Bar5",rightbar)
yaB.SetVisibility("Bar6",extrabar)
yaB.SetVisibility("StanceBar",stancebar)
yaB.SetVisibility("PetBar",petbar)

-- hiding default frames and textures
local FramesToHide = {
	MainMenuBar,
	--MainMenuBarArtFrame,
	MainMenuBarArtFrameBackground,
	MainMenuBarArtFrame.LeftEndCap,
	MainMenuBarArtFrame.RightEndCap,
	MainMenuBarArtFrame.PageNumber,
	MainMenuBarPageNumber,
	ActionBarDownButton,
	ActionBarUpButton,
	--OverrideActionBar,
	OverrideActionBarExpBar,
	OverrideActionBarHealthBar,
	OverrideActionBarPowerBar,
	OverrideActionBarPitchFrame,
	OverrideActionBarLeaveFrameLeaveButton,
	--BonusActionBarFrame,
	--PossessBarFrame
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,

	StanceBarLeft,
	StanceBarMiddle,
	StanceBarRight,
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	PossessBackground1,
	PossessBackground2,
	MainMenuBarTexture0,
	MainMenuBarTexture1,
	MainMenuBarTexture2,
	MainMenuBarTexture3,
	MainMenuBarLeftEndCap,
	MainMenuBarRightEndCap,
	}
local frameHider = CreateFrame("Frame", nil)
frameHider:Hide()
for _, f in pairs(FramesToHide) do
    if f:GetObjectType() == "Texture" then
      --f:UnregisterAllEvents()
	  f:SetTexture(nil)
	else
	  f:SetParent(frameHider)
    end
end
local OverrideTexList =  {
	"_BG",
	"_MicroBGMid",
	"_Border",
	"EndCapL",
	"EndCapR",
	"Divider1",
	"Divider2",
	"Divider3",
	"ExitBG",
	"MicroBGL",
	"MicroBGR",
	"ButtonBGL",
	"ButtonBGR",
	"_ButtonBGMid",
	}
for _, t in pairs(OverrideTexList) do
	OverrideActionBar[t]:SetAlpha(0)
end


-- ExtraBar button implementation
extrabtn = CreateFrame("Frame", "ExtraBtn_holder", UIParent)
if not cfg.bars["ExtraButton"].disable then
	extrabtn:SetPoint(cfg.bars["ExtraButton"].position.a, cfg.bars["ExtraButton"].position.x, cfg.bars["ExtraButton"].position.y)
	extrabtn:SetSize(160, 80)

	ExtraActionBarFrame:SetParent(extrabtn)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", extrabtn, "CENTER", 0, 0)

	--ExtraActionButton1.noResize = true
	ExtraActionBarFrame.ignoreFramePositionManager = true
end

-- exit vehicle button for the lazy ones
local ve = CreateFrame("BUTTON", "ExitVehicle_holder", UIParent, "SecureHandlerClickTemplate")
ve:SetSize(cfg.bars["Bar1"].button_size+10,cfg.bars["Bar1"].button_size+10)
if cfg.bars["ExitVehicleButton"].user_placed then
	ve:SetPoint(cfg.bars["ExitVehicleButton"].position.a, cfg.bars["ExitVehicleButton"].position.x, cfg.bars["ExitVehicleButton"].position.y)
	if cfg.bars["ExitVehicleButton"].button_size then ve:SetSize(cfg.bars["ExitVehicleButton"].button_size+10,cfg.bars["ExitVehicleButton"].button_size+10) end
else
	local btn = 'ActionButton'..cfg.bars["Bar1"].buttons
	ve:SetPoint("CENTER", btn, "CENTER", cfg.bars["Bar1"].button_spacing/2, 0)
end
ve:RegisterForClicks("AnyUp")
ve:SetScript("OnClick", function() VehicleExit() end)
ve:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
ve:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
ve:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
ve:SetAlpha(0)

-- adding border so it fits our bars general style
local veh = CreateFrame("Frame",nil,ve)
veh:SetAllPoints(ve)
veh:SetParent(ve)
veh:SetFrameLevel(31)
veh:EnableMouse(false)
local veb = veh:CreateTexture(cfg.yaB.media.textures_normal)
veb:SetTexture(cfg.yaB.media.textures_normal)
veb:SetPoint("TOPLEFT",4,-5)
veb:SetPoint("BOTTOMRIGHT",-6,5)
veb:SetVertexColor(0,0,0)
ve:Hide()
if not cfg.bars["ExitVehicleButton"].disable then
	ve:Show()
	RegisterStateDriver(ve, "visibility", "[vehicleui] show;hide")
	ve:RegisterEvent("UNIT_ENTERING_VEHICLE")
	ve:RegisterEvent("UNIT_ENTERED_VEHICLE")
	ve:RegisterEvent("UNIT_EXITING_VEHICLE")
	ve:RegisterEvent("UNIT_EXITED_VEHICLE")
	ve:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	ve:SetScript("OnEvent", function(self, event, ...)
		local arg1 = ...;
		if(((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
			ve:SetAlpha(1)
			ve:SetScript("OnEnter", function(self)
				veb:SetVertexColor(unpack(cfg.buttons.colors.highlight))
			end)
			ve:SetScript("OnLeave", function(self) veb:SetVertexColor(unpack(cfg.buttons.colors.normal)) end)
		elseif (((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") or (event=="ZONE_CHANGED_NEW_AREA" and not UnitHasVehicleUI("player")) then
			ve:SetAlpha(0)
		end
	end)
end

-- MicroMenu


local MicroMenu = yaB.CreateHolder("MicroMenu_holder", {a= cfg.bars["MicroMenu"].position.a, x=cfg.bars["MicroMenu"].position.x*(2-cfg.bars["MicroMenu"].scale), y= cfg.bars["MicroMenu"].position.y*(2-cfg.bars["MicroMenu"].scale)})
MicroMenu:SetSize(305,40)
MicroMenu:SetScale(cfg.bars["MicroMenu"].scale)
local MICRO_BUTTONS = MICRO_BUTTONS
local MicroButtons = {}
	-- check the MICRO_BUTTONS table
for _, buttonName in pairs(MICRO_BUTTONS) do
	local button = _G[buttonName]
	if button then
		tinsert(MicroButtons, button)
	end
end
local SetMicroButtons = function()
    for _, b in pairs(MicroButtons) do
		b:SetParent(MicroMenu)
    end
    CharacterMicroButton:ClearAllPoints();
    CharacterMicroButton:SetPoint("BOTTOMLEFT", 0, 0)
end
SetMicroButtons()
-- gotta run this function each time we respec so we don't loose our micromenu bar
-- seems to be fixed in WoW5.0
--[[ MicroMenu:RegisterEvent("PLAYER_TALENT_UPDATE")
MicroMenu:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
MicroMenu:SetScript("OnEvent", function(self,event)
      if  not InCombatLockdown() and (event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
          SetMicroButtons()
      end
end) ]]
-- micro menu on mouseover
if cfg.bars["MicroMenu"].show_on_mouseover then
	local switcher = -1
	local function mmalpha(alpha)
		for _, f in pairs(MicroButtons) do
			f:SetAlpha(alpha)
			switcher = alpha
		end
	end
	MicroMenu:EnableMouse(true)
	MicroMenu:SetScript("OnEnter", function(self) mmalpha(1) end)
	MicroMenu:SetScript("OnLeave", function(self) mmalpha(0) end)
	for _, f in pairs(MicroButtons) do
		f:SetAlpha(0)
		f:HookScript("OnEnter", function(self) mmalpha(1) end)
		f:HookScript("OnLeave", function(self) mmalpha(0) end)
	end
	MicroMenu:SetScript("OnEvent", function(self)
		mmalpha(0)
	end)
	MicroMenu:RegisterEvent("PLAYER_ENTERING_WORLD")
	--fix for the talent button display while micromenu onmouseover
	local function TalentSwitchAlphaFix(self,alpha)
		if switcher ~= alpha then
			switcher = 0
			self:SetAlpha(0)
		end
		SetMicroButtons()
	end
	hooksecurefunc(TalentMicroButton, "SetAlpha", TalentSwitchAlphaFix)
end
if cfg.bars["MicroMenu"].hide_bar then MicroMenu:Hide() end
if cfg.bars["MicroMenu"].lock_to_CharacterFrame then
	MicroMenu:SetParent(PaperDollFrame)
	MicroMenu:SetPoint("BOTTOMLEFT", PaperDollFrame, "TOPLEFT",65,2)
end

-- fix main bar keybind not working after a talent switch
hooksecurefunc('TalentFrame_LoadUI', function()
	PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
end)

-- hiding extra bars
local bars_visible = false
-- making this global function to hook in my broker toggler
yaBars_Toggle_Extra_Bars = function()
	if InCombatLockdown() then return print("yaBars: You can't toggle bars while in combat!") end
	if bars_visible then
		if cfg.bars["Bar1"].hide_bar then mainbar:Hide() end
		if cfg.bars["Bar2"].hide_bar then bottomleftbar:Hide() end
		if cfg.bars["Bar3"].hide_bar then bottomrightbar:Hide() end
		if cfg.bars["Bar4"].hide_bar then leftbar:Hide() end
		if cfg.bars["Bar5"].hide_bar then rightbar:Hide() end
		if cfg.bars["Bar6"].hide_bar then extrabar:Hide() end
		if cfg.bars["StanceBar"].hide_bar then stancebar:Hide() end
		if cfg.bars["MicroMenu"].hide_bar then MicroMenu:Hide() end
		if WorldMarkerBar_holder and cfg.bars["RaidIconBar"].hide_bar then WorldMarkerBar_holder:Hide() end
		if RaidIconBar_holder and cfg.bars["WorldMarkerBar"].hide_bar then RaidIconBar_holder:Hide() end
		bars_visible = false
	else
		if cfg.bars["Bar1"].hide_bar then mainbar:Show() end
		if cfg.bars["Bar2"].hide_bar then bottomleftbar:Show() end
		if cfg.bars["Bar3"].hide_bar then bottomrightbar:Show() end
		if cfg.bars["Bar4"].hide_bar then leftbar:Show() end
		if cfg.bars["Bar5"].hide_bar then rightbar:Show() end
		if cfg.bars["Bar6"].hide_bar then extrabar:Show() end
		if cfg.bars["StanceBar"].hide_bar then stancebar:Show() end
		if cfg.bars["MicroMenu"].hide_bar then MicroMenu:Show() end
		if WorldMarkerBar_holder and cfg.bars["RaidIconBar"].hide_bar then WorldMarkerBar_holder:Show() end
		if RaidIconBar_holder and cfg.bars["WorldMarkerBar"].hide_bar then RaidIconBar_holder:Show() end
		bars_visible = true
	end
end

-- and making slash command to show them
SlashCmdList["EXTRA"] = function() yaBars_Toggle_Extra_Bars() end
SLASH_EXTRA1 = "/extra"
SLASH_EXTRA2 = "/eb"

-- adding testmode to make bar positioning easier
local testmodeON
yaBars_Toggle_Test_Mode = function()
	local def_back		= "interface\\Tooltips\\UI-Tooltip-Background"
	local backdrop_tab = {
		bgFile = def_back,
		edgeFile = nil,
		tile = false, tileSize = 0, edgeSize = 5,
		insets = {left = 0, right = 0, top = 0, bottom = 0,},}
	local ShowHolder = function(holder, switch)
		if not _G[holder:GetName().."_overlay"] then
			local f = CreateFrame("Frame", holder:GetName().."_overlay", UIParent, "BackdropTemplate")
			f:SetAllPoints(holder)
			f:SetBackdrop(backdrop_tab);
			f:SetBackdropColor(.1,.1,.2,.8)
			f:SetFrameStrata("HIGH")
			local name = f:CreateFontString(nil)
			name:SetFont(cfg.yaB.media.button_font, 8)
			name:SetText(holder:GetName())
			name:SetPoint("BOTTOMLEFT",f,"TOPLEFT")
		end

		if switch then
			_G[holder:GetName().."_overlay"]:Show()
		else
			_G[holder:GetName().."_overlay"]:Hide()
		end
	end
	if testmodeON then
		testmodeON = false
	else
		testmodeON = true
	end
	local holders = {
		Bar1_holder,
		Bar2_holder,
		Bar3_holder,
		Bar4_holder,
		Bar5_holder,
		StanceBar_holder,
		PetBar_holder,
		MicroMenu_holder,
		RaidIconBar_holder,
		WorldMarkerBar_holder,
		ExitVehicle_holder,
		Bar6_holder,
		ExtraBtn_holder
		}
	for _, f in pairs(holders) do
		ShowHolder(f,testmodeON)
	end
end
SlashCmdList["TESTMODE"] = function() yaBars_Toggle_Test_Mode() end
SLASH_TESTMODE1 = "/yaB"
SLASH_TESTMODE2 = "/yaBars"