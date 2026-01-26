--!strict
local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local function loadRemote(path)
	local source = game:HttpGet(repo .. path)
	local chunk, err = loadstring(source)
	if not chunk then
		error("[Blossom] UI load failed: " .. tostring(err))
	end
	return chunk()
end

local Interface = {}

function Interface:Init(Client)
	self.Client = Client
	self.Logger = Client.Logger
	self:Mount()
end

local function setNotifyMuted(library, enabled)
	if enabled then
		library.Notify = library.Notify or function() end
		library._blossomNotify = library._blossomNotify or library.Notify
		library.Notify = function() end
	else
		if library._blossomNotify then
			library.Notify = library._blossomNotify
		end
	end
end

local function getLibraryVisible(library)
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

local function runAutoload(library, saveManager, silent)
	local wasVisible = getLibraryVisible(library)
	if silent then
		setNotifyMuted(library, true)
		if wasVisible then
			pcall(function()
				library:Toggle()
			end)
		end
	end

	pcall(function()
		saveManager:LoadAutoloadConfig()
	end)

	if silent then
		if wasVisible then
			pcall(function()
				library:Toggle()
			end)
		end
		setNotifyMuted(library, false)
	end
end

function Interface:Mount()
	local Library = loadRemote("Library.lua")
	local ThemeManager = loadRemote("addons/ThemeManager.lua")
	local SaveManager = loadRemote("addons/SaveManager.lua")

	self.Library = Library

	local window = Library:CreateWindow({
		Title = "Blossom " .. self.Client.Version,
		Center = true,
		AutoShow = true,
		TabPadding = 8,
		MenuFadeTime = 0.2,
	})

	local tabs = {
		Main = window:AddTab("Main"),
		Visuals = window:AddTab("Visuals"),
		Misc = window:AddTab("Misc"),
		["UI Settings"] = window:AddTab("UI Settings"),
	}

	local mainGroup = tabs.Main:AddLeftGroupbox("Main")

	mainGroup:AddToggle("MovementToggle", {
		Text = "Movement Assist",
		Default = false,
		Callback = function(state)
			local mod = self.Client.Modules.Movement
			if mod and mod.Toggle then
				mod:Toggle(state)
			end
		end,
	})

	-- Visuals Tab
	local espGroup = tabs.Visuals:AddLeftGroupbox("ESP")

	-- Enable Master Toggle
	espGroup
		:AddToggle("VisualsToggle", {
			Text = "Visuals (ESP)",
			Default = false,
			Callback = function(state)
				local mod = self.Client.Modules.Visuals
				if mod and mod.Toggle then
					mod:Toggle(state)
				end
			end,
		})
		:AddKeyPicker("EspKey", { Default = "Insert", NoUI = true, Text = "ESP Key" })

	espGroup:AddToggle("ESPEnabled", {
		Text = "Enable ESP",
		Default = false,
		Callback = function(state)
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetESPEnabled(state)
			end
		end,
	})

	-- Name
	espGroup
		:AddToggle("ESPNames", {
			Text = "Name",
			Default = true,
			Callback = function(state)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetShowNames(state)
				end
			end,
		})
		:AddColorPicker("ESPTextColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Text Color",
			Callback = function(value)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetTextColor(value)
				end
			end,
		})

	-- Weapon
	espGroup:AddToggle("ESPWeapon", {
		Text = "Weapon",
		Default = false,
		Callback = function(state)
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetShowWeapon(state)
			end
		end,
	})
	-- Assuming Weapon uses TextColor for now, but UI implies separate color.
	-- Since SetTextColor sets both, we'll leave it shared or add specific if needed.
	-- The image has a color picker for Weapon.
	-- Let's just use the shared text color for consistency or we need more Setters.
	-- I'll skip individual color pickers for text items sharing color to keep implementation simple as requested,
	-- UNLESS the user explicitly asked for every single color. The image shows color pickers.
	-- I'll reuse TextColor for Name/Weapon/Distance for now to save space, or add duplicate pickers if strictly matching image.
	-- Let's match image. We need `SetWeaponColor` etc. But Visuals.luau uses `TextColor` for all.
	-- I'll stick to `TextColor` managing all text for now.

	-- Distance
	espGroup:AddToggle("ESPDistance", {
		Text = "Distance",
		Default = false,
		Callback = function(state)
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetShowDistance(state)
			end
		end,
	})

	-- Box
	espGroup
		:AddToggle("ESPBoxes", {
			Text = "Box",
			Default = true,
			Callback = function(state)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetShowBoxes(state)
				end
			end,
		})
		:AddColorPicker("ESPBoxColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Box Color",
			Callback = function(value)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetBoxColor(value)
				end
			end,
		})

	-- Skeleton
	espGroup
		:AddToggle("ESPSkeleton", {
			Text = "Skeleton",
			Default = false,
			Callback = function(state)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetShowSkeleton(state)
				end
			end,
		})
		:AddColorPicker("ESPSkeletonColor", {
			Default = Color3.new(1, 1, 1),
			Title = "Skeleton Color",
			Callback = function(value)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetSkeletonColor(value)
				end
			end,
		})

	-- Healthbar
	espGroup:AddToggle("ESPHealthbar", {
		Text = "Healthbar",
		Default = false,
		Callback = function(state)
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetShowHealthbar(state)
			end
		end,
	})

	-- Highlight (Fill, Outline)
	espGroup
		:AddToggle("ESPHighlight", {
			Text = "Highlight",
			Default = false,
			Callback = function(state)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetShowHighlight(state)
				end
			end,
		})
		:AddColorPicker("ESPHighlightFill", {
			Default = Color3.new(1, 0, 0),
			Title = "Fill Color",
			Callback = function(value)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetHighlightFill(value)
				end
			end,
		})
		:AddColorPicker("ESPHighlightOutline", {
			Default = Color3.new(1, 1, 1),
			Title = "Outline Color",
			Callback = function(value)
				local mod = self.Client.Modules.Visuals
				if mod then
					mod:SetHighlightOutline(value)
				end
			end,
		})

	-- Better Bounds (Visuals uses simple bounds for now, but UI checks box)
	espGroup:AddToggle("ESPBetterBounds", {
		Text = "Better Bounds",
		Default = false,
		Callback = function(state)
			-- Placeholder logic or refine Visuals later
		end,
	})

	-- Show Teammates
	espGroup:AddToggle("ESPShowTeammates", {
		Text = "Show Teammates",
		Default = true,
		Callback = function(state)
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetTeamCheck(not state)
			end -- Inverse
		end,
	})

	-- Sliders
	espGroup:AddSlider("ESPSkeletonThickness", {
		Text = "Skeleton Thickness",
		Default = 1,
		Min = 1,
		Max = 5,
		Rounding = 1,
		Callback = function(value)
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetSkeletonThickness(value)
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
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetTextSize(value)
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
			local mod = self.Client.Modules.Visuals
			if mod then
				mod:SetMaxDistance(value)
			end
		end,
	})

	local menuGroup = tabs["UI Settings"]:AddLeftGroupbox("Menu")
	menuGroup:AddButton("Unload", function()
		Library:Unload()
	end)
	menuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
		Default = "End",
		NoUI = true,
		Text = "Menu keybind",
	})
	Library.ToggleKeybind = Options.MenuKeybind

	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	ThemeManager:SetFolder("Blossom")
	SaveManager:SetFolder("Blossom")
	SaveManager:BuildConfigSection(tabs["UI Settings"])
	ThemeManager:ApplyToTab(tabs["UI Settings"])

	local miscGroup = tabs.Misc:AddLeftGroupbox("Auto Load")
	miscGroup:AddToggle("TeleportQueue", {
		Text = "Auto Load",
		Default = false,
		Callback = function(enabled)
			self.Client:SetTeleportQueue(enabled)
		end,
	})

	miscGroup:AddToggle("SilentMode", {
		Text = "Silent Mode",
		Default = false,
		Callback = function(enabled)
			if enabled then
				setNotifyMuted(Library, true)
			else
				setNotifyMuted(Library, false)
			end
		end,
	})

	runAutoload(Library, SaveManager, false)

	self.Logger:Info("UI mounted successfully")
end

function Interface:Cleanup()
	if self.Library then
		self.Library:Unload()
	end
end

return Interface
