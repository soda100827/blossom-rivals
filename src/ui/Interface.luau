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

	mainGroup:AddToggle("VisualsToggle", {
		Text = "Visuals (ESP)",
		Default = false,
		Callback = function(state)
			local mod = self.Client.Modules.Visuals
			if mod and mod.Toggle then
				mod:Toggle(state)
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
	miscGroup:AddToggle("AutoLoad", {
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
