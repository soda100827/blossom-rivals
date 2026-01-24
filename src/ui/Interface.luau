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
	SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
	ThemeManager:SetFolder("Blossom")
	SaveManager:SetFolder("Blossom")
	SaveManager:BuildConfigSection(tabs["UI Settings"])
	ThemeManager:ApplyToTab(tabs["UI Settings"])

	self.Logger:Info("UI mounted successfully")
end

function Interface:Cleanup()
	if self.Library then
		self.Library:Unload()
	end
end

return Interface
