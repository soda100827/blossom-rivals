--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LOCAL_PLAYER = Players.LocalPlayer

local Visuals = {
	Enabled = false,
	Connections = {},
	Drawings = {},
	Settings = {
		ESPEnabled = false,
		ShowNames = true,
		ShowBoxes = true,
		MaxDistance = 2000,
	},
}

function Visuals:Init(Client)
	self.Client = Client
	self.Logger = Client.Logger
end

function Visuals:Toggle(state: boolean)
	if self.Enabled == state then
		return
	end
	self.Enabled = state
	if state then
		self:Enable()
	else
		self:Disable()
	end
end

function Visuals:SetESPEnabled(state: boolean)
	self.Settings.ESPEnabled = state
	if not state then
		self:ClearDrawings()
	end
end

function Visuals:SetShowNames(state: boolean)
	self.Settings.ShowNames = state
end

function Visuals:SetShowBoxes(state: boolean)
	self.Settings.ShowBoxes = state
end

function Visuals:Enable()
	if not Drawing or type(Drawing.new) ~= "function" then
		self.Logger:Warn("Drawing API not available; Visuals disabled.")
		self.Enabled = false
		return
	end

	local function onPlayerRemoving(player)
		self:RemovePlayerDrawings(player)
	end

	local function onPlayerAdded(player)
		if player == LOCAL_PLAYER then
			return
		end
		self:EnsurePlayerDrawings(player)
	end

	table.insert(self.Connections, Players.PlayerAdded:Connect(onPlayerAdded))
	table.insert(self.Connections, Players.PlayerRemoving:Connect(onPlayerRemoving))

	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end

	table.insert(
		self.Connections,
		RunService.RenderStepped:Connect(function()
			self:Render()
		end)
	)
end

function Visuals:Disable()
	for _, conn in ipairs(self.Connections) do
		conn:Disconnect()
	end
	self.Connections = {}

	self:ClearDrawings()
end

function Visuals:Cleanup()
	self:Disable()
end

function Visuals:ClearDrawings()
	for player, group in pairs(self.Drawings) do
		self:DestroyDrawingGroup(group)
		self.Drawings[player] = nil
	end
end

function Visuals:EnsurePlayerDrawings(player)
	if self.Drawings[player] then
		return
	end

	self.Drawings[player] = {
		Name = Drawing.new("Text"),
		Box = Drawing.new("Square"),
	}

	local group = self.Drawings[player]
	group.Name.Size = 14
	group.Name.Center = true
	group.Name.Outline = true
	group.Name.Color = Color3.new(1, 1, 1)
	group.Name.Visible = false

	group.Box.Thickness = 1
	group.Box.Filled = false
	group.Box.Color = Color3.new(1, 0.6, 0.8)
	group.Box.Visible = false
end

function Visuals:RemovePlayerDrawings(player)
	local group = self.Drawings[player]
	if not group then
		return
	end
	self:DestroyDrawingGroup(group)
	self.Drawings[player] = nil
end

function Visuals:DestroyDrawingGroup(group)
	for _, drawing in pairs(group) do
		pcall(function()
			drawing:Remove()
		end)
	end
end

function Visuals:Render()
	if not self.Settings.ESPEnabled then
		self:ClearDrawings()
		return
	end

	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end

	for player, group in pairs(self.Drawings) do
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not character or not humanoid or humanoid.Health <= 0 or not root then
			group.Name.Visible = false
			group.Box.Visible = false
		else
			local distance = (root.Position - camera.CFrame.Position).Magnitude
			if distance > self.Settings.MaxDistance then
				group.Name.Visible = false
				group.Box.Visible = false
			else
				local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
				if not onScreen then
					group.Name.Visible = false
					group.Box.Visible = false
				else
					local scale = math.clamp(1 - (distance / self.Settings.MaxDistance), 0.25, 1)
					local boxWidth = 60 * scale
					local boxHeight = 90 * scale

					if self.Settings.ShowBoxes then
						group.Box.Size = Vector2.new(boxWidth, boxHeight)
						group.Box.Position = Vector2.new(screenPos.X - boxWidth / 2, screenPos.Y - boxHeight / 2)
						group.Box.Visible = true
					else
						group.Box.Visible = false
					end

					if self.Settings.ShowNames then
						group.Name.Text = player.DisplayName or player.Name
						group.Name.Position = Vector2.new(screenPos.X, screenPos.Y - boxHeight / 2 - 14)
						group.Name.Visible = true
					else
						group.Name.Visible = false
					end
				end
			end
		end
	end
end

return Visuals
