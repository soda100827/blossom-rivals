--!strict

--// Services
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any

--// Constants
local REPO_URL = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local WATERMARK_TEMPLATE = "Blossom | %d fps | %d ms"
local WATERMARK_UPDATE_INTERVAL = 1

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
	controlBindings = nil :: any,
	watermark = {
		lastSample = 0,
		frameCount = 0,
	},
}
local _signals = {}

--// Private helpers
local function _getLinoriaGlobals(): (any, any)
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local getgenvFunc = env.getgenv
	local toggles = (getgenvFunc and getgenvFunc().Toggles) or _G.Toggles
	local options = (getgenvFunc and getgenvFunc().Options) or _G.Options
	return toggles, options
end

local function _getPingMs(): number
	local pingMs = 0
	local success, value = pcall(function()
		local stat = Stats.Network.ServerStatsItem["Data Ping"]
		return stat:GetValue()
	end)
	if success and type(value) == "number" then
		pingMs = math.floor(value + 0.5)
	end
	return pingMs
end

local function _setKeybindListVisible(isVisible: boolean)
	local library = _state.library
	if not library then
		return
	end
	local keybindFrame = library.KeybindFrame
	if keybindFrame then
		keybindFrame.Visible = isVisible
	end
end

local function _setWatermarkVisible(isVisible: boolean)
	local library = _state.library
	if not library or not library.SetWatermarkVisibility then
		return
	end
	library:SetWatermarkVisibility(isVisible)
end

local function _syncUiVisibility()
	local toggles = _getLinoriaGlobals()
	if not toggles then
		return
	end
	local keybindsToggle = toggles.UIShowKeybindList
	if keybindsToggle then
		_setKeybindListVisible(keybindsToggle.Value == true)
	end
	local watermarkToggle = toggles.UIShowWatermark
	if watermarkToggle then
		_setWatermarkVisible(watermarkToggle.Value == true)
	end
end

local function _updateWatermark()
	local library = _state.library
	if not library or not library.SetWatermark then
		return
	end

	local toggles = _getLinoriaGlobals()
	local isVisible = true
	if toggles and toggles.UIShowWatermark then
		isVisible = toggles.UIShowWatermark.Value == true
	end
	if not isVisible then
		return
	end

	local watermark = _state.watermark
	watermark.frameCount += 1

	local now = os.clock()
	if watermark.lastSample <= 0 then
		watermark.lastSample = now
		return
	end
	if (now - watermark.lastSample) < WATERMARK_UPDATE_INTERVAL then
		return
	end

	local fps = math.floor(watermark.frameCount / (now - watermark.lastSample))
	watermark.frameCount = 0
	watermark.lastSample = now

	library:SetWatermark(string.format(WATERMARK_TEMPLATE, fps, _getPingMs()))
end

local function _updateControlBindings()
	if not _state.controlBindings then
		return
	end
	local toggles, options = _getLinoriaGlobals()
	if not toggles or not options then
	end
	for _, control in ipairs(_state.controlBindings) do
		local toggle = toggles and toggles[control.toggleId]
		local gate = toggle and toggle.Value == true
		local active = false
		if gate then
			local keybind = options and options[control.keybindId]
			if keybind and keybind.GetState then
				active = keybind:GetState()
			else
				active = false
			end
		end
		if control.last ~= active then
			control.last = active
			control.setter(active)
		end
	end
end

local function _installSaveManagerExtensions(saveManager: any)
	if saveManager._blossomBuildConfigSection then
		return
	end

	saveManager._blossomBuildConfigSection = saveManager.BuildConfigSection
	saveManager.BuildConfigSection = function(self, tab)
		assert(self.Library, "Must set SaveManager.Library")

		local section = tab:AddRightGroupbox("Configuration")

		section:AddInput("SaveManager_ConfigName", { Text = "Config name" })
		section:AddDropdown("SaveManager_ConfigList", {
			Text = "Config list",
			Values = self:RefreshConfigList(),
			AllowNull = true,
		})

		section:AddDivider()

		local _, options = _getLinoriaGlobals()

		section:AddButton("Create config", function()
			if not options then
				return
			end
			local name = options.SaveManager_ConfigName.Value

			if name:gsub(" ", "") == "" then
				return self.Library:Notify("Invalid config name (empty)", 2)
			end

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify("Failed to save config: " .. err)
			end

			self.Library:Notify(string.format("Created config %q", name))

			options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			options.SaveManager_ConfigList:SetValue(nil)
		end):AddButton("Load config", function()
			if not options then
				return
			end
			local name = options.SaveManager_ConfigList.Value

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify("Failed to load config: " .. err)
			end

			self.Library:Notify(string.format("Loaded config %q", name))
		end)

		section:AddButton("Overwrite config", function()
			if not options then
				return
			end
			local name = options.SaveManager_ConfigList.Value

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify("Failed to overwrite config: " .. err)
			end

			self.Library:Notify(string.format("Overwrote config %q", name))
		end)

		section:AddButton("Refresh list", function()
			if not options then
				return
			end
			options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			options.SaveManager_ConfigList:SetValue(nil)
		end)

		section:AddButton("Set as autoload", function()
			if not options then
				return
			end
			local name = options.SaveManager_ConfigList.Value
			writefile(self.Folder .. "/settings/autoload.txt", name)
			self.AutoloadLabel:SetText("Current autoload config: " .. name)
			self.Library:Notify(string.format("Set %q to auto load", name))
		end):AddButton("Remove autoload", function()
			local path = self.Folder .. "/settings/autoload.txt"
			if isfile(path) then
				pcall(delfile, path)
			end
			self.AutoloadLabel:SetText("Current autoload config: none")
			self.Library:Notify("Cleared autoload config")
		end)

		self.AutoloadLabel = section:AddLabel("Current autoload config: none", true)

		if isfile(self.Folder .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/settings/autoload.txt")
			self.AutoloadLabel:SetText("Current autoload config: " .. name)
		end

		self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
	end
end

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

	local updateConn = RunService.RenderStepped:Connect(function()
		_updateControlBindings()
		_updateWatermark()
	end)
	_maid:GiveTask(updateConn)
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

	_installSaveManagerExtensions(saveManager)

	if library and library.AccentColor ~= nil then
		library.AccentColor = Color3.fromRGB(255, 105, 180)
	end

	local window = library:CreateWindow({
		Title = "Blossom " .. _state.client.Version,
		Center = true,
		AutoShow = not _state.client.IsSilent,
		TabPadding = 8,
		MenuFadeTime = 0.2,
	})

	local tabs = {
		combat = window:AddTab("Combat"),
		visuals = window:AddTab("Visuals"),
		misc = window:AddTab("Misc"),
		uiSettings = window:AddTab("UI Settings"),
	}

	local combatGroup = tabs.combat:AddLeftGroupbox("Combat")

	-- Silent Aim Section
	local silentAimToggle = combatGroup:AddToggle("SilentAimEnabled", {
		Text = "Silent Aim",
		Default = false,
		Tooltip = "Redirects shots toward the closest valid target within your silent FOV.",
		Callback = function()
			_updateControlBindings()
		end,
	})
	silentAimToggle:AddKeyPicker("SilentAimKeybind", {
		Default = "MouseButton2",
		NoUI = false,
		Text = "Silent Aim Keybind",
		SyncToggleState = false,
		Callback = function()
			_updateControlBindings()
		end,
	})
	silentAimToggle:AddColorPicker("SilentAimFovColor", {
		Default = Color3.fromRGB(255, 255, 255),
		Transparency = 0,
		Title = "Silent FOV Color",
		Tooltip = "Color of the Silent Aim FOV circle.",
		Callback = function(color, transparency)
			local mod = _state.client.Modules.Combat
			if mod and mod.setSilentAimFovColor then
				mod:setSilentAimFovColor(color)
			end
			if mod and mod.setSilentAimFovTransparency then
				mod:setSilentAimFovTransparency(transparency or 0)
			end
		end,
	})

	combatGroup:AddSlider("SilentHitChance", {
		Text = "Silent Hit Chance",
		Default = 100,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "Chance for Silent Aim to redirect a shot.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setSilentHitChance then
				mod:setSilentHitChance(value)
			end
		end,
	})

	combatGroup:AddSlider("SilentAimFovRadius", {
		Text = "Silent Aim Radius",
		Default = 100,
		Min = 10,
		Max = 800,
		Rounding = 0,
		Suffix = "px",
		Tooltip = "Silent Aim activation radius in pixels.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setSilentAimFovRadius then
				mod:setSilentAimFovRadius(value)
			end
		end,
	})

	-- Aimbot Section
	local combatAimbotToggle = combatGroup:AddToggle("CombatAimbotEnabled", {
		Text = "Aimbot",
		Default = false,
		Tooltip = "Automatically aims at the best target.",
		Callback = function()
			_updateControlBindings()
		end,
	})
	combatAimbotToggle:AddKeyPicker("CombatAimbotKeybind", {
		Default = "MouseButton2",
		NoUI = false,
		Text = "Aimbot Keybind",
		SyncToggleState = false,
		Callback = function()
			_updateControlBindings()
		end,
	})
	combatAimbotToggle:AddColorPicker("CombatFovColor", {
		Default = Color3.fromRGB(255, 255, 255),
		Transparency = 0,
		Title = "Aimbot FOV Color",
		Tooltip = "Color of the Aimbot FOV circle.",
		Callback = function(color, transparency)
			local mod = _state.client.Modules.Combat
			if mod and mod.setFovColor then
				mod:setFovColor(color)
			end
			if mod and mod.setFovTransparency then
				mod:setFovTransparency(transparency or 0)
			end
		end,
	})

	combatGroup:AddSlider("CombatSmoothness", {
		Text = "Aimbot Smoothing",
		Default = 0,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%", -- Matches image style
		Tooltip = "Higher values feel smoother but slower to lock.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setSmoothness then
				mod:setSmoothness((value :: number) / 100) -- Convert to 0-1 for back-end
			end
		end,
	})

	combatGroup:AddSlider("CombatFovRadius", {
		Text = "Aimbot Radius",
		Default = 100,
		Min = 10,
		Max = 800,
		Rounding = 0,
		Suffix = "px",
		Tooltip = "Aimbot activation radius in pixels.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setFovRadius then
				mod:setFovRadius(value)
			end
		end,
	})

	-- Other Settings
	combatGroup:AddToggle("CombatManipulation", {
		Text = "Manipulation",
		Default = false,
		Tooltip = "Enables manipulation-related combat features.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setManipulationEnabled then
				mod:setManipulationEnabled(state)
			end
		end,
	})

	combatGroup:AddToggle("CombatWallCheck", {
		Text = "Visible Only",
		Default = false,
		Tooltip = "Only target enemies you can see (raycast).",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setWallCheckEnabled then
				mod:setWallCheckEnabled(state)
			end
		end,
	})

	combatGroup:AddToggle("CombatAntiKatana", {
		Text = "Anti Katana",
		Default = false,
		Tooltip = "Mitigates katana-related attacks.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setAntiKatanaEnabled then
				mod:setAntiKatanaEnabled(state)
			end
		end,
	})

	combatGroup:AddToggle("CombatClosestPosition", {
		Text = "Closest Position",
		Default = true,
		Tooltip = "Choose the closest body part in the whitelist.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setClosestPositionEnabled then
				mod:setClosestPositionEnabled(state)
			end
		end,
	})

	combatGroup:AddDropdown("CombatClosestWhitelist", {
		Values = {
			"Head",
			"UpperTorso",
			"LowerTorso",
			"LeftUpperArm",
			"RightUpperArm",
			"LeftUpperLeg",
			"RightUpperLeg",
		},
		Default = {
			"Head",
			"UpperTorso",
			"LowerTorso",
			"LeftUpperArm",
			"RightUpperArm",
			"LeftUpperLeg",
			"RightUpperLeg",
		},
		Multi = true,
		Text = "Closest Position Whitelist",
		Tooltip = "Parts to consider for Closest Position",
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setClosestPositionWhitelist then
				local selectedNames = {}
				for name, enabled in pairs(value) do
					if enabled then
						table.insert(selectedNames, name)
					end
				end
				mod:setClosestPositionWhitelist(selectedNames)
			end
		end,
	})

	combatGroup:AddDropdown("CombatTargetPart", {
		Values = {
			"Head",
			"UpperTorso",
			"LowerTorso",
			"LeftUpperArm",
			"RightUpperArm",
			"LeftUpperLeg",
			"RightUpperLeg",
		},
		Default = 1,
		Multi = false,
		Text = "Target Part",
		Tooltip = "Static target part when Closest Position is off",
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setTargetPart then
				mod:setTargetPart(value)
			end
		end,
	})

	local gunModsGroup = tabs.combat:AddRightGroupbox("Gun Mods")

	gunModsGroup:AddToggle("GunModsNoRecoil", {
		Text = "No Recoil",
		Default = false,
		Tooltip = "Eliminates weapon recoil.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setNoRecoilEnabled then
				mod:setNoRecoilEnabled(state)
			end
		end,
	})

	gunModsGroup:AddToggle("GunModsNoSpread", {
		Text = "No Spread",
		Default = false,
		Tooltip = "Eliminates weapon bullet spread.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setNoSpreadEnabled then
				mod:setNoSpreadEnabled(state)
			end
		end,
	})

	gunModsGroup:AddToggle("GunModsNoMuzzleFlash", {
		Text = "No Muzzle Flash",
		Default = false,
		Tooltip = "Removes the muzzle flash effect when shooting.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setNoMuzzleFlashEnabled then
				mod:setNoMuzzleFlashEnabled(state)
			end
		end,
	})

	local meleeModsGroup = tabs.combat:AddRightGroupbox("Melee Mods")

	meleeModsGroup:AddToggle("MeleeModsAura", {
		Text = "Melee Aura",
		Default = false,
		Tooltip = "Automatically attacks nearby enemies.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setMeleeAuraEnabled then
				mod:setMeleeAuraEnabled(state)
			end
		end,
	})

	meleeModsGroup:AddSlider("MeleeModsReach", {
		Text = "Melee Reach",
		Default = 100,
		Min = 10,
		Max = 500,
		Rounding = 0,
		Suffix = " studs",
		Tooltip = "Hit distance for Melee Aura. Higher value increases reach.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setMeleeAuraReach then
				mod:setMeleeAuraReach(value)
			end
		end,
	})

	meleeModsGroup:AddToggle("MeleeModsTeleportAura", {
		Text = "Teleport Aura",
		Default = false,
		Tooltip = "Teleports to nearby enemies and attacks them.",
		Callback = function(state)
			local mod = _state.client.Modules.Combat
			if mod and mod.setTeleportAuraEnabled then
				mod:setTeleportAuraEnabled(state)
			end
		end,
	})

	meleeModsGroup:AddSlider("MeleeModsAttackCooldown", {
		Text = "Attack Cooldown %",
		Default = 100,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "Adjusts melee attack rate (100% is normal).",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setMeleeAttackCooldownMultiplier then
				mod:setMeleeAttackCooldownMultiplier(value)
			end
		end,
	})

	meleeModsGroup:AddSlider("MeleeModsSkillCooldown", {
		Text = "Skill Cooldown %",
		Default = 100,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "Adjusts melee skill cooldown (100% is normal).",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setMeleeSkillCooldownMultiplier then
				mod:setMeleeSkillCooldownMultiplier(value)
			end
		end,
	})

	gunModsGroup:AddSlider("GunModsAttackCooldown", {
		Text = "Attack Cooldown",
		Default = 100,
		Min = 1,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "Weapon fire rate cooldown. 1% is near-instant fire rate.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Combat
			if mod and mod.setAttackCooldownMultiplier then
				mod:setAttackCooldownMultiplier(value)
			end
		end,
	})

	local espGroup = tabs.visuals:AddLeftGroupbox("ESP")
	espGroup:AddToggle("VisualsToggle", {
		Text = "Visuals (ESP)",
		Default = false,
		Tooltip = "Master toggle for all ESP visuals.",
		Callback = function(state)
			local mod = _state.client.Modules.Visuals
			if mod and mod.toggle then
				mod:toggle(state)
			end
			if mod and mod.setEspEnabled then
				mod:setEspEnabled(state)
			end
		end,
	})

	espGroup
		:AddToggle("ESPNames", {
			Text = "Name",
			Default = true,
			Tooltip = "Show player names.",
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
			Tooltip = "Color for ESP name text.",
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
			Tooltip = "Outline color for ESP names.",
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
			Tooltip = "Show equipped weapon name.",
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
			Tooltip = "Color for weapon text.",
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
			Tooltip = "Outline color for weapon text.",
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
			Tooltip = "Show distance to target.",
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
			Tooltip = "Color for distance text.",
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
			Tooltip = "Outline color for distance text.",
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
			Tooltip = "Draw a box around targets.",
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
			Tooltip = "Color of the ESP box.",
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
			Tooltip = "Outline color of the ESP box.",
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
			Tooltip = "Draw a skeleton over targets.",
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
			Tooltip = "Color of skeleton lines.",
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
			Tooltip = "Outline color for skeleton lines.",
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
			Tooltip = "Show target healthbar.",
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
			Tooltip = "Color of health fill.",
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
			Tooltip = "Outline color for the healthbar.",
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
			Tooltip = "Add a Highlight instance to targets.",
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
			Tooltip = "Fill color for Highlight.",
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
			Tooltip = "Outline color for Highlight.",
			Callback = function(value)
				local mod = _state.client.Modules.Visuals
				if mod and mod.setHighlightOutline then
					mod:setHighlightOutline(value)
				end
			end,
		})

	local hitEffectsGroup = tabs.visuals:AddRightGroupbox("Hit Effects")
	hitEffectsGroup:AddToggle("VisualsCustomHitSound", {
		Text = "Custom Hit Sound",
		Default = false,
		Tooltip = "Play a custom sound when hitting an enemy.",
		Callback = function(state)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setCustomHitSoundEnabled then
				mod:setCustomHitSoundEnabled(state)
			end
		end,
	})
	hitEffectsGroup:AddInput("VisualsHitSoundId", {
		Default = "rbxassetid://160432334",
		Numeric = false,
		Finished = true,
		Text = "Hit Sound ID",
		Tooltip = "The sound ID to play on hit.",
		Placeholder = "rbxassetid://...",
		Callback = function(value)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setHitSoundId then
				mod:setHitSoundId(value)
			end
		end,
	})
	hitEffectsGroup:AddToggle("VisualsNoHurtEffect", {
		Text = "No Hurt Effect",
		Default = false,
		Tooltip = "Disables the blood/sparks and red flash on ENEMIES when you hit them.",
		Callback = function(state)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setNoHurtEffectEnabled then
				mod:setNoHurtEffectEnabled(state)
			end
		end,
	})

	espGroup:AddToggle("ESPBetterBounds", {
		Text = "Better Bounds",
		Default = false,
		Tooltip = "Reserved for future bounds improvements.",
		Callback = function(_stateValue) end,
	})

	espGroup:AddToggle("ESPShowTeammates", {
		Text = "Show Teammates",
		Default = true,
		Tooltip = "Show ESP on teammates.",
		Callback = function(state)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setShowTeammates then
				mod:setShowTeammates(state)
			end
		end,
	})

	espGroup:AddSlider("ESPSkeletonThickness", {
		Text = "Skeleton Thickness",
		Default = 1,
		Min = 1,
		Max = 5,
		Rounding = 1,
		Tooltip = "Thickness of skeleton lines.",
		Compact = true,
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
		Tooltip = "Size of ESP text.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Visuals
			if mod and mod.setTextSize then
				mod:setTextSize(value)
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

	local interfaceGroup = tabs.uiSettings:AddRightGroupbox("Interface")
	interfaceGroup:AddToggle("UIShowKeybindList", {
		Text = "Keybind List",
		Default = true,
		Tooltip = "Shows the keybind list panel.",
		Callback = function(isVisible)
			_setKeybindListVisible(isVisible)
		end,
	})
	interfaceGroup:AddToggle("UIShowWatermark", {
		Text = "Watermark",
		Default = true,
		Tooltip = "Shows the watermark display.",
		Callback = function(isVisible)
			_setWatermarkVisible(isVisible)
		end,
	})

	-- LinoriaLib exports Options to the global environment
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local getgenvFunc = env.getgenv
	local GlobalOptions = (getgenvFunc and getgenvFunc().Options) or _G.Options
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

	local playerGroup = tabs.misc:AddLeftGroupbox("Player")
	local exploitsGroup = tabs.misc:AddRightGroupbox("Exploits")

	local playerFlyToggle = playerGroup:AddToggle("PlayerFly", {
		Text = "Fly",
		Default = false,
		Tooltip = "Toggle flight mode.",
		Callback = function(state)
			_updateControlBindings()
		end,
	})
	playerFlyToggle:AddKeyPicker("PlayerFlyKeybind", {
		Default = "F",
		NoUI = false,
		Text = "Fly Keybind",
		SyncToggleState = false,
		Callback = function()
			_updateControlBindings()
		end,
	})

	playerGroup:AddSlider("PlayerFlySpeed", {
		Text = "Fly Speed",
		Default = 50,
		Min = 5,
		Max = 200,
		Rounding = 0,
		Tooltip = "Movement speed while flying.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Player
			if mod and mod.setFlySpeed then
				mod:setFlySpeed(value)
			end
		end,
	})

	local playerNoclipToggle = playerGroup:AddToggle("PlayerNoclip", {
		Text = "Noclip",
		Default = false,
		Tooltip = "Disable collisions for your character.",
		Callback = function(state)
			_updateControlBindings()
		end,
	})
	playerNoclipToggle:AddKeyPicker("PlayerNoclipKeybind", {
		Default = "N",
		NoUI = false,
		Text = "Noclip Keybind",
		SyncToggleState = false,
		Callback = function()
			_updateControlBindings()
		end,
	})

	local playerWalkSpeedToggle = playerGroup:AddToggle("PlayerWalkSpeedEnabled", {
		Text = "Walk Speed",
		Default = false,
		Tooltip = "Toggle custom walk speed.",
		Callback = function(state)
			_updateControlBindings()
		end,
	})
	playerWalkSpeedToggle:AddKeyPicker("PlayerWalkSpeedKeybind", {
		Default = "T",
		NoUI = false,
		Text = "Walk Speed Keybind",
		SyncToggleState = false,
		Callback = function()
			_updateControlBindings()
		end,
	})

	playerGroup:AddSlider("PlayerWalkSpeed", {
		Text = "Walk Speed",
		Default = 16,
		Min = 0,
		Max = 200,
		Rounding = 0,
		Tooltip = "Your character walk speed.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Player
			if mod and mod.setWalkSpeed then
				mod:setWalkSpeed(value)
			end
		end,
	})

	local playerJumpPowerToggle = playerGroup:AddToggle("PlayerJumpPowerEnabled", {
		Text = "Jump Power",
		Default = false,
		Tooltip = "Toggle custom jump power.",
		Callback = function(state)
			_updateControlBindings()
		end,
	})
	playerJumpPowerToggle:AddKeyPicker("PlayerJumpPowerKeybind", {
		Default = "Y",
		NoUI = false,
		Text = "Jump Power Keybind",
		SyncToggleState = false,
		Callback = function()
			_updateControlBindings()
		end,
	})

	playerGroup:AddSlider("PlayerJumpPower", {
		Text = "Jump Power",
		Default = 50,
		Min = 0,
		Max = 200,
		Rounding = 0,
		Tooltip = "Your character jump power.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Player
			if mod and mod.setJumpPower then
				mod:setJumpPower(value)
			end
		end,
	})

	playerGroup:AddToggle("PlayerSlideBoost", {
		Text = "Slide Boost",
		Default = false,
		Tooltip = "Boosts your sliding speed.",
		Callback = function(state)
			local mod = _state.client.Modules.Player
			if mod and mod.setSlideBoostEnabled then
				mod:setSlideBoostEnabled(state)
			end
		end,
	})

	playerGroup:AddSlider("PlayerSlideBoostMultiplier", {
		Text = "Slide Boost Multiplier",
		Default = 1,
		Min = 1,
		Max = 10,
		Rounding = 1,
		Suffix = "x",
		Tooltip = "Multiplier for sliding speed.",
		Compact = true,
		Callback = function(value)
			local mod = _state.client.Modules.Player
			if mod and mod.setSlideBoostMultiplier then
				mod:setSlideBoostMultiplier(value)
			end
		end,
	})

	-- Exploits Group
	exploitsGroup:AddToggle("PlayerAntiFlash", {
		Text = "Anti Flashbang",
		Default = false,
		Tooltip = "Prevents you from being blinded by flashbangs.",
		Callback = function(state)
			local mod = _state.client.Modules.Player
			if mod and mod.setAntiFlashEnabled then
				mod:setAntiFlashEnabled(state)
			end
		end,
	})

	exploitsGroup:AddToggle("PlayerSpoofDeviceEnabled", {
		Text = "Spoof Device",
		Default = false,
		Tooltip = "Toggle device spoofing.",
		Callback = function(state)
			local mod = _state.client.Modules.Player
			if mod and mod.setSpoofDeviceEnabled then
				mod:setSpoofDeviceEnabled(state)
			end
		end,
	})

	exploitsGroup:AddDropdown("PlayerSpoofDevice", {
		Values = { "None", "Touch", "Gamepad", "VR", "MouseKeyboard" },
		Default = 1,
		Multi = false,
		Text = "Device",
		Tooltip = "The device to spoof as.",
		Callback = function(value)
			local mod = _state.client.Modules.Player
			if mod and mod.setSpoofDevice then
				mod:setSpoofDevice(value)
			end
		end,
	})

	exploitsGroup:AddToggle("PlayerSoundSpammer", {
		Text = "Sound Spammer",
		Default = false,
		Tooltip = "Spams mechanics sounds to other players.",
		Callback = function(state)
			local mod = _state.client.Modules.Player
			if mod and mod.setSoundSpammerEnabled then
				mod:setSoundSpammerEnabled(state)
			end
		end,
	})

	exploitsGroup:AddDropdown("PlayerSoundSpammerType", {
		Values = { "DoubleJump", "Slide" },
		Default = 1,
		Multi = false,
		Text = "Sound",
		Tooltip = "The sound to spam.",
		Callback = function(value)
			local mod = _state.client.Modules.Player
			if mod and mod.setSoundSpammerType then
				mod:setSoundSpammerType(value)
			end
		end,
	})

	_state.controlBindings = {
		{
			toggleId = "CombatAimbotEnabled",
			keybindId = "CombatAimbotKeybind",
			last = nil,
			setter = function(active)
				local mod = _state.client.Modules.Combat
				if mod and mod.setAimbotEnabled then
					mod:setAimbotEnabled(active)
				end
			end,
		},
		{
			toggleId = "PlayerFly",
			keybindId = "PlayerFlyKeybind",
			last = nil,
			setter = function(active)
				local mod = _state.client.Modules.Player
				if mod and mod.setFlyEnabled then
					mod:setFlyEnabled(active)
				end
			end,
		},
		{
			toggleId = "PlayerNoclip",
			keybindId = "PlayerNoclipKeybind",
			last = nil,
			setter = function(active)
				local mod = _state.client.Modules.Player
				if mod and mod.setNoclipEnabled then
					mod:setNoclipEnabled(active)
				end
			end,
		},
		{
			toggleId = "PlayerWalkSpeedEnabled",
			keybindId = "PlayerWalkSpeedKeybind",
			last = nil,
			setter = function(active)
				local mod = _state.client.Modules.Player
				if mod and mod.setWalkSpeedEnabled then
					mod:setWalkSpeedEnabled(active)
				end
			end,
		},
		{
			toggleId = "PlayerJumpPowerEnabled",
			keybindId = "PlayerJumpPowerKeybind",
			last = nil,
			setter = function(active)
				local mod = _state.client.Modules.Player
				if mod and mod.setJumpPowerEnabled then
					mod:setJumpPowerEnabled(active)
				end
			end,
		},
		{
			toggleId = "SilentAimEnabled",
			keybindId = "SilentAimKeybind",
			last = nil,
			setter = function(active)
				local mod = _state.client.Modules.Combat
				if mod and mod.setSilentAimEnabled then
					mod:setSilentAimEnabled(active)
				end
			end,
		},
	}
	_updateControlBindings()

	local miscGroup = tabs.misc:AddLeftGroupbox("Auto Load")
	miscGroup:AddToggle("TeleportQueue", {
		Text = "Auto Load",
		Default = false,
		Tooltip = "Auto-load Blossom after teleport.",
		Callback = function(enabled)
			_state.client:setTeleportQueue(enabled)
		end,
	})

	miscGroup:AddToggle("SilentMode", {
		Text = "Silent Mode",
		Default = false,
		Tooltip = "Mutes UI notifications and auto-opens silently.",
		Callback = function(enabled)
			_setNotifyMuted(library, enabled)
			_state.client:setSilent(enabled)
		end,
	})

	_runAutoload(library, saveManager, false)
	_syncUiVisibility()
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
