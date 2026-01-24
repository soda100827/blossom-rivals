--!strict
local RunService = game:GetService("RunService")
local Fusion = require("@pkg/fusion")
local Window = require("src/ui/components/Window")
local Toggle = require("src/ui/components/Toggle")

local New = Fusion.New
local Children = Fusion.Children

local Interface = {}

function Interface:Init(Client)
	self.Client = Client
	self.Logger = Client.Logger

	local success, target = pcall(function()
		return game:GetService("CoreGui")
	end)

	if not success then
		target = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end
	self.Target = target

	self:Mount()
end

function Interface:Mount()
	if self.Target:FindFirstChild("BlossomUI") then
		self.Target.BlossomUI:Destroy()
	end

	local App = New("ScreenGui")({
		Name = "BlossomUI",
		Parent = self.Target,
		ResetOnSpawn = false,
		DisplayOrder = 100, -- Ensure it's on top

		[Children] = {
			Window({
				Title = "Blossom " .. self.Client.Version,

				[Children] = {
					Toggle({
						Title = "Movement Assist",
						Callback = function(state)
							local mod = self.Client.Modules.Movement
							if mod and mod.Toggle then
								mod:Toggle(state)
							end
						end,
					}),

					Toggle({
						Title = "Visuals (ESP)",
						Callback = function(state)
							local mod = self.Client.Modules.Visuals
							if mod and mod.Toggle then
								mod:Toggle(state)
							end
						end,
					}),
				},
			}),
		},
	})

	self.Instance = App
	self.Logger:Info("UI mounted successfully")
end

function Interface:Cleanup()
	if self.Instance then
		self.Instance:Destroy()
	end
end

return Interface
