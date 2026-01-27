--!strict

--// Services

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants
local REPO_URL = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

--// Types
export type Interface = {
	init: (self: Interface, client: any) -> (),
	cleanup: (self: Interface) -> (),
}

--// Private state
local Interface = {}
Interface.__index = Interface

local _maid = nil :: any
local _state = {
	client = nil :: any,
	logger = nil :: any,
	library = nil :: any,
	themeManager = nil :: any,
	saveManager = nil :: any,
	isMounted = false,
}
local _signals = {}

--// Private helpers
local function _httpGet(url: string): string
	return (game :: any):HttpGet(url)
end

local function _loadRemote(path: string, logger: any): any
	local source = _httpGet(REPO_URL .. path)
	local chunk, err = loadstring(source)
	if not chunk then
		if logger then
			logger:error("UI load failed:", err)
		end
		error("UI load failed: " .. tostring(err))
	end
	return chunk()
end

local function _setNotifyMuted(library: any, shouldMute: boolean)
	if shouldMute then
		library.Notify = library.Notify or function() end
		library._blossomNotify = library._blossomNotify or library.Notify
		library.Notify = function() end
		return
	end
	if library._blossomNotify then
		library.Notify = library._blossomNotify
	end
end

local function _getLibraryVisible(library: any): boolean
	if type(library.Opened) == "boolean" then
		return library.Opened
	end
	if type(library.Visible) == "boolean" then
		return library.Visible
	end
	if type(library.IsOpen) == "boolean" then
		return library.IsOpen
	end
	return true
end

local function _runAutoload(library: any, saveManager: any, isSilent: boolean)
	local wasVisible = _getLibraryVisible(library)
	if isSilent then
		_setNotifyMuted(library, true)
		if wasVisible then
			pcall(function()
				library:Toggle()
			end)
		end
	end

	pcall(function()
		saveManager:LoadAutoloadConfig()
	end)

	if isSilent then
		if wasVisible then
			pcall(function()
				library:Toggle()
			end)
		end
		_setNotifyMuted(library, false)
	end
end

local function _connect()
	_maid:DoCleaning()
end

local function _mount()
	if _state.isMounted then
		return
	end
	_state.isMounted = true

	local logger = _state.logger
	local library = _loadRemote("Library.lua", logger)
	local themeManager = _loadRemote("addons/ThemeManager.lua", logger)
	local saveManager = _loadRemote("addons/SaveManager.lua", logger)

	_state.library = library
	_state.themeManager = themeManager
	_state.saveManager = saveManager

	local window = library:CreateWindow({
		Title = "Blossom " .. _state.client.Version,
		Center = true,
		AutoShow = not _state.client.IsSilent,
		TabPadding = 8,
		MenuFadeTime = 0.2,
	})

	local tabs = {
		visuals = window:AddTab("Visuals"),
		misc = window:AddTab("Misc"),
		uiSettings = window:AddTab("UI Settings"),
	}

	local espGroup = tabs.visuals:AddLeftGroupbox("ESP")
	espGroup
		:AddToggle("VisualsToggle", {
			Text = "Visuals (ESP)",
			Default = false,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.toggle then
					mod:toggle(state)
					if mod.setEspEnabled then
						mod:setEspEnabled(state)
					end
				end
			end,
		})
		:AddKeyPicker("EspKey", { Default = "Insert", NoUI = true, Text = "ESP Key" })

	espGroup
		:AddToggle("ESPNames", {
			Text = "Name",
			Default = true,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setShowNames then
					mod:setShowNames(state)
				end
			end,
		})
		:AddColorPicker("ESPTextColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Text Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setTextColor then
					mod:setTextColor(value)
				end
			end,
		})
		:AddColorPicker("ESPNameOutlineColor", {
			Default = Color3.new(0, 0, 0),
			Title = "Name Outline",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setNameOutlineColor then
					mod:setNameOutlineColor(value)
				end
			end,
		})

	espGroup
		:AddToggle("ESPWeapon", {
			Text = "Weapon",
			Default = false,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setShowWeapon then
					mod:setShowWeapon(state)
				end
			end,
		})
		:AddColorPicker("ESPWeaponColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Weapon Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setWeaponColor then
					mod:setWeaponColor(value)
				end
			end,
		})
		:AddColorPicker("ESPWeaponOutlineColor", {
			Default = Color3.new(0, 0, 0),
			Title = "Weapon Outline",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setWeaponOutlineColor then
					mod:setWeaponOutlineColor(value)
				end
			end,
		})

	espGroup
		:AddToggle("ESPDistance", {
			Text = "Distance",
			Default = false,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setShowDistance then
					mod:setShowDistance(state)
				end
			end,
		})
		:AddColorPicker("ESPDistanceColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Distance Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setDistanceColor then
					mod:setDistanceColor(value)
				end
			end,
		})
		:AddColorPicker("ESPDistanceOutlineColor", {
			Default = Color3.new(0, 0, 0),
			Title = "Distance Outline",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setDistanceOutlineColor then
					mod:setDistanceOutlineColor(value)
				end
			end,
		})

	espGroup
		:AddToggle("ESPBoxes", {
			Text = "Box",
			Default = true,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setShowBoxes then
					mod:setShowBoxes(state)
				end
			end,
		})
		:AddColorPicker("ESPBoxColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Box Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setBoxColor then
					mod:setBoxColor(value)
				end
			end,
		})
		:AddColorPicker("ESPBoxOutlineColor", {
			Default = Color3.new(0, 0, 0),
			Title = "Box Outline",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setBoxOutlineColor then
					mod:setBoxOutlineColor(value)
				end
			end,
		})

	espGroup
		:AddToggle("ESPSkeleton", {
			Text = "Skeleton",
			Default = false,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setShowSkeleton then
					mod:setShowSkeleton(state)
				end
			end,
		})
		:AddColorPicker("ESPSkeletonColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Skeleton Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setSkeletonColor then
					mod:setSkeletonColor(value)
				end
			end,
		})
		:AddColorPicker("ESPSkeletonOutlineColor", {
			Default = Color3.new(0, 0, 0),
			Title = "Skeleton Outline",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setSkeletonOutlineColor then
					mod:setSkeletonOutlineColor(value)
				end
			end,
		})

	espGroup
		:AddToggle("ESPHealthbar", {
			Text = "Healthbar",
			Default = false,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setShowHealthbar then
					mod:setShowHealthbar(state)
				end
			end,
		})
		:AddColorPicker("ESPHealthbarColor", {
			Default = Color3.new(0, 1, 0),
			Title = "Health Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setHealthbarColor then
					mod:setHealthbarColor(value)
				end
			end,
		})
		:AddColorPicker("ESPHealthbarOutlineColor", {
			Default = Color3.new(0, 0, 0),
			Title = "Outline Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setHealthbarOutlineColor then
					mod:setHealthbarOutlineColor(value)
				end
			end,
		})

	espGroup
		:AddToggle("ESPHighlight", {
			Text = "Highlight",
			Default = false,
			Callback = function(state)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setShowHighlight then
					mod:setShowHighlight(state)
				end
			end,
		})
		:AddColorPicker("ESPHighlightFill", {
			Default = Color3.new(1, 0, 0),
			Title = "Fill Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setHighlightFill then
					mod:setHighlightFill(value)
				end
			end,
		})
		:AddColorPicker("ESPHighlightOutline", {
			Default = Color3.new(1, 1, 1),
			Title = "Outline Color",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setHighlightOutline then
					mod:setHighlightOutline(value)
				end
			end,
		})

	espGroup:AddToggle("ESPBetterBounds", {
		Text = "Better Bounds",
		Default = false,
		Callback = function(_stateValue) end,
	})

	espGroup:AddToggle("ESPShowTeammates", {
		Text = "Show Teammates",
		Default = true,
		Callback = function(state)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setTeamCheck then
				mod:setTeamCheck(not state)
			end
		end,
	})

	espGroup:AddSlider("ESPSkeletonThickness", {
		Text = "Skeleton Thickness",
		Default = 1,
		Min = 1,
		Max = 5,
		Rounding = 1,
		Callback = function(value)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setSkeletonThickness then
				mod:setSkeletonThickness(value)
			end
		end,
	})

	espGroup:AddSlider("ESPTextSize", {
		Text = "Text Size",
		Default = 12,
		Min = 10,
		Max = 24,
		Rounding = 0,
		Callback = function(value)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setTextSize then
				mod:setTextSize(value)
			end
		end,
	})

	espGroup:AddSlider("ESPMaxDistance", {
		Text = "Max Distance",
		Default = 2000,
		Min = 100,
		Max = 10000,
		Rounding = 0,
		Callback = function(value)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setMaxDistance then
				mod:setMaxDistance(value)
			end
		end,
	})

	local menuGroup = tabs.uiSettings:AddLeftGroupbox("Menu")
	menuGroup:AddButton("Unload", function()
		library:Unload()
	end)
	menuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
		Default = "End",
		NoUI = true,
		Text = "Menu keybind",
	})
	-- LinoriaLib exports Options to the global environment
	local GlobalOptions = (getgenv and getgenv().Options) or _G.Options
	if GlobalOptions and GlobalOptions.MenuKeybind then
		library.ToggleKeybind = GlobalOptions.MenuKeybind
	end

	themeManager:SetLibrary(library)
	saveManager:SetLibrary(library)
	saveManager:IgnoreThemeSettings()
	themeManager:SetFolder("Blossom")
	saveManager:SetFolder("Blossom")
	saveManager:BuildConfigSection(tabs.uiSettings)
	themeManager:ApplyToTab(tabs.uiSettings)

	local miscGroup = tabs.misc:AddLeftGroupbox("Auto Load")
	miscGroup:AddToggle("TeleportQueue", {
		Text = "Auto Load",
		Default = false,
		Callback = function(enabled)
			_state.client:setTeleportQueue(enabled)
		end,
	})

	miscGroup:AddToggle("SilentMode", {
		Text = "Silent Mode",
		Default = false,
		Callback = function(enabled)
			_setNotifyMuted(library, enabled)
			_state.client:setSilent(enabled)
		end,
	})

	_runAutoload(library, saveManager, false)
	logger:info("UI mounted successfully")
end

--// Public API
function Interface.init(self: Interface, client: any): ()
	_state.client = client
	_state.logger = client.Logger
	_maid = Maid.new()
	_connect()
	_mount()
end

function Interface.cleanup(self: Interface): ()
	_maid:DoCleaning()
	if _state.library then
		_state.library:Unload()
	end
	_state.isMounted = false
end

return Interface
