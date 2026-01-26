--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LOCAL_PLAYER = Players.LocalPlayer

local Camera = Workspace.CurrentCamera

local Visuals = {
	Enabled = false,
	Connections = {},
	Drawings = {},
	Highlights = {},
	Settings = {
		ESPEnabled = false,
		ShowNames = true,
		ShowWeapon = false,
		ShowDistance = false,
		ShowBoxes = true,
		ShowSkeleton = false,
		ShowHealthbar = false,
		ShowHighlight = false,
		TeamCheck = false,
		MaxDistance = 2000,

		-- Colors
		BoxColor = Color3.new(1, 1, 1),
		TextColor = Color3.new(1, 1, 1),
		SkeletonColor = Color3.new(1, 1, 1),
		HealthbarColor = Color3.new(0, 1, 0), -- Dynamic usually, but base color
		HighlightFill = Color3.new(1, 0, 0),
		HighlightOutline = Color3.new(1, 1, 1),

		BoxThickness = 1,
		SkeletonThickness = 1,
		TextSize = 12,
		Outline = true,
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

-- Settings Setters
function Visuals:SetESPEnabled(state: boolean)
	self.Settings.ESPEnabled = state
	if not state then
		self:Clear()
	end
end
function Visuals:SetShowNames(state: boolean)
	self.Settings.ShowNames = state
end
function Visuals:SetShowWeapon(state: boolean)
	self.Settings.ShowWeapon = state
end
function Visuals:SetShowDistance(state: boolean)
	self.Settings.ShowDistance = state
end
function Visuals:SetShowBoxes(state: boolean)
	self.Settings.ShowBoxes = state
end
function Visuals:SetShowSkeleton(state: boolean)
	self.Settings.ShowSkeleton = state
end
function Visuals:SetShowHealthbar(state: boolean)
	self.Settings.ShowHealthbar = state
end
function Visuals:SetShowHighlight(state: boolean)
	self.Settings.ShowHighlight = state
	if not state then
		self:ClearHighlights()
	end
end
function Visuals:SetTeamCheck(state: boolean)
	self.Settings.TeamCheck = state
end
function Visuals:SetMaxDistance(value: number)
	self.Settings.MaxDistance = value
end

function Visuals:SetBoxColor(color: Color3)
	self.Settings.BoxColor = color
end
function Visuals:SetTextColor(color: Color3)
	self.Settings.TextColor = color
end
function Visuals:SetSkeletonColor(color: Color3)
	self.Settings.SkeletonColor = color
end
function Visuals:SetHighlightFill(color: Color3)
	self.Settings.HighlightFill = color
end
function Visuals:SetHighlightOutline(color: Color3)
	self.Settings.HighlightOutline = color
end

function Visuals:SetBoxThickness(value: number)
	self.Settings.BoxThickness = value
end
function Visuals:SetSkeletonThickness(value: number)
	self.Settings.SkeletonThickness = value
end
function Visuals:SetTextSize(value: number)
	self.Settings.TextSize = value
end
function Visuals:SetOutline(state: boolean)
	self.Settings.Outline = state
end

function Visuals:Enable()
	if not Drawing then
		self.Logger:Warn("Drawing API not available; Visuals disabled.")
		self.Enabled = false
		return
	end

	local function onPlayerRemoving(player)
		self:RemovePlayer(player)
	end

	local function onPlayerAdded(player)
		if player == LOCAL_PLAYER then
			return
		end
		-- We let Render loop handle creation to avoid issues if char isn't ready
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
	self:Clear()
end

function Visuals:Cleanup()
	self:Disable()
end

function Visuals:Clear()
	self:ClearDrawings()
	self:ClearHighlights()
end

function Visuals:ClearDrawings()
	for player, group in pairs(self.Drawings) do
		self:DestroyDrawingGroup(group)
		self.Drawings[player] = nil
	end
end

function Visuals:ClearHighlights()
	for player, hl in pairs(self.Highlights) do
		hl:Destroy()
		self.Highlights[player] = nil
	end
end

function Visuals:RemovePlayer(player)
	if self.Drawings[player] then
		self:DestroyDrawingGroup(self.Drawings[player])
		self.Drawings[player] = nil
	end
	if self.Highlights[player] then
		self.Highlights[player]:Destroy()
		self.Highlights[player] = nil
	end
end

function Visuals:DestroyDrawingGroup(group)
	for _, drawing in pairs(group) do
		if type(drawing) == "table" then -- Skeleton lines
			for _, line in pairs(drawing) do
				line:Remove()
			end
		else
			drawing:Remove()
		end
	end
end

function Visuals:EnsurePlayerDrawings(player)
	if self.Drawings[player] then
		return self.Drawings[player]
	end

	local group = {
		Name = Drawing.new("Text"),
		Weapon = Drawing.new("Text"),
		Distance = Drawing.new("Text"),
		Box = Drawing.new("Square"),
		BoxOutline = Drawing.new("Square"),
		Healthbar = Drawing.new("Square"),
		HealthbarOutline = Drawing.new("Square"),
		Skeleton = {},
	}

	-- Init Text
	for _, key in ipairs({ "Name", "Weapon", "Distance" }) do
		group[key].Center = true
		group[key].Outline = true
		group[key].Visible = false
	end

	-- Init Boxes
	for _, key in ipairs({ "Box", "BoxOutline", "Healthbar", "HealthbarOutline" }) do
		group[key].Visible = false
		group[key].Filled = false
	end
	group.Box.Filled = false
	group.BoxOutline.Filled = false
	group.Healthbar.Filled = true
	group.HealthbarOutline.Filled = true -- Used as background

	-- Init Skeleton (15 lines max usually)
	for i = 1, 16 do
		local line = Drawing.new("Line")
		line.Visible = false
		table.insert(group.Skeleton, line)
	end

	self.Drawings[player] = group
	return group
end

function Visuals:UpdateHighlight(player, character)
	if not self.Settings.ShowHighlight then
		if self.Highlights[player] then
			self.Highlights[player]:Destroy()
			self.Highlights[player] = nil
		end
		return
	end

	if not self.Highlights[player] then
		local hl = Instance.new("Highlight")
		hl.Name = "BlossomHighlight"
		hl.FillTransparency = 0.5
		hl.OutlineTransparency = 0
		hl.Parent = game:GetService("CoreGui") -- Or match parent logic
		self.Highlights[player] = hl
	end

	local hl = self.Highlights[player]
	if hl.Adornee ~= character then
		hl.Adornee = character
	end
	hl.FillColor = self.Settings.HighlightFill
	hl.OutlineColor = self.Settings.HighlightOutline
	hl.Enabled = true
end

function Visuals:Render()
	if not self.Settings.ESPEnabled then
		self:Clear()
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LOCAL_PLAYER then
			continue
		end

		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not character or not root or not humanoid or humanoid.Health <= 0 then
			self:RemovePlayer(player)
			continue
		end

		if self.Settings.TeamCheck and player.Team == LOCAL_PLAYER.Team then
			self:RemovePlayer(player)
			continue
		end

		local group = self:EnsurePlayerDrawings(player)
		local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
		local distance = (root.Position - Camera.CFrame.Position).Magnitude

		if not onScreen or distance > self.Settings.MaxDistance then
			for _, d in pairs(group) do
				if type(d) == "table" then
					for _, l in pairs(d) do
						l.Visible = false
					end
				else
					d.Visible = false
				end
			end
			if self.Highlights[player] then
				self.Highlights[player].Enabled = false
			end
			continue
		end

		-- Update Highlight
		self:UpdateHighlight(player, character)

		-- Calculate Box
		local scale = math.clamp(1000 / distance, 0.1, 1) -- Simple scaling
		local width, height = 30 * scale, 50 * scale -- Basic box size estimation, better to use part bounds but this is simple

		-- Helper to get bounds
		local cf, size = character:GetBoundingBox()
		local tl = Camera:WorldToViewportPoint((cf * CFrame.new(size.X / 2, size.Y / 2, 0)).Position)
		local tr = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X / 2, size.Y / 2, 0)).Position)
		local bl = Camera:WorldToViewportPoint((cf * CFrame.new(size.X / 2, -size.Y / 2, 0)).Position)
		local br = Camera:WorldToViewportPoint((cf * CFrame.new(-size.X / 2, -size.Y / 2, 0)).Position)

		-- Simplistic 2D box from RootPart for stability or use BoundingBox if preferred.
		-- Let's stick to the previous simple method refined:
		local rootPos = Camera:WorldToViewportPoint(root.Position)
		local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
		local headPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2, 0))

		height = math.abs(headPos.Y - legPos.Y) * 1.5
		width = height * 0.6

		local boxPos = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
		local boxSize = Vector2.new(width, height)

		-- Box
		if self.Settings.ShowBoxes then
			group.Box.Size = boxSize
			group.Box.Position = boxPos
			group.Box.Color = self.Settings.BoxColor
			group.Box.Thickness = self.Settings.BoxThickness
			group.Box.Visible = true
			-- Outline could be added here if needed, usually black 1px bigger
		else
			group.Box.Visible = false
		end

		-- Healthbar
		if self.Settings.ShowHealthbar then
			local healthPerc = humanoid.Health / humanoid.MaxHealth
			local barHeight = height * healthPerc
			group.HealthbarOutline.Size = Vector2.new(2, height)
			group.HealthbarOutline.Position = Vector2.new(boxPos.X - 5, boxPos.Y)
			group.HealthbarOutline.Color = Color3.new(0, 0, 0)
			group.HealthbarOutline.Visible = true

			group.Healthbar.Size = Vector2.new(2, barHeight)
			group.Healthbar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (height - barHeight))
			group.Healthbar.Color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPerc)
			group.Healthbar.Visible = true
		else
			group.Healthbar.Visible = false
			group.HealthbarOutline.Visible = false
		end

		local textYOffset = 0
		-- Name
		if self.Settings.ShowNames then
			group.Name.Text = player.DisplayName or player.Name
			group.Name.Size = self.Settings.TextSize
			group.Name.Color = self.Settings.TextColor
			group.Name.Outline = self.Settings.Outline
			group.Name.Position = Vector2.new(rootPos.X, boxPos.Y - self.Settings.TextSize - 2)
			group.Name.Visible = true
		else
			group.Name.Visible = false
		end

		-- Weapon
		if self.Settings.ShowWeapon then
			local tool = character:FindFirstChildOfClass("Tool")
			if tool then
				group.Weapon.Text = tool.Name
				group.Weapon.Size = self.Settings.TextSize
				group.Weapon.Color = self.Settings.TextColor
				group.Weapon.Outline = self.Settings.Outline
				group.Weapon.Position = Vector2.new(rootPos.X, boxPos.Y + height + 2 + textYOffset)
				group.Weapon.Visible = true
				textYOffset = textYOffset + self.Settings.TextSize
			else
				group.Weapon.Visible = false
			end
		else
			group.Weapon.Visible = false
		end

		-- Distance
		if self.Settings.ShowDistance then
			group.Distance.Text = math.floor(distance) .. " studs"
			group.Distance.Size = self.Settings.TextSize
			group.Distance.Color = self.Settings.TextColor
			group.Distance.Outline = self.Settings.Outline
			group.Distance.Position = Vector2.new(rootPos.X, boxPos.Y + height + 2 + textYOffset)
			group.Distance.Visible = true
			textYOffset = textYOffset + self.Settings.TextSize
		else
			group.Distance.Visible = false
		end

		-- Skeleton
		if self.Settings.ShowSkeleton then
			self:UpdateSkeleton(group.Skeleton, character)
		else
			for _, l in pairs(group.Skeleton) do
				l.Visible = false
			end
		end
	end
end

function Visuals:UpdateSkeleton(skeletonLines, character)
	local R15_JOINTS = {
		{ "Head", "UpperTorso" },
		{ "UpperTorso", "LowerTorso" },
		{ "LowerTorso", "LeftUpperLeg" },
		{ "LeftUpperLeg", "LeftLowerLeg" },
		{ "LeftLowerLeg", "LeftFoot" },
		{ "LowerTorso", "RightUpperLeg" },
		{ "RightUpperLeg", "RightLowerLeg" },
		{ "RightLowerLeg", "RightFoot" },
		{ "UpperTorso", "LeftUpperArm" },
		{ "LeftUpperArm", "LeftLowerArm" },
		{ "LeftLowerArm", "LeftHand" },
		{ "UpperTorso", "RightUpperArm" },
		{ "RightUpperArm", "RightLowerArm" },
		{ "RightLowerArm", "RightHand" },
	}
	-- R6 is simpler, but let's assume R15 or standard names.

	local lineIdx = 1
	for _, pair in ipairs(R15_JOINTS) do
		local p1 = character:FindFirstChild(pair[1])
		local p2 = character:FindFirstChild(pair[2])

		if p1 and p2 then
			local v1, o1 = Camera:WorldToViewportPoint(p1.Position)
			local v2, o2 = Camera:WorldToViewportPoint(p2.Position)

			if o1 and o2 then
				local line = skeletonLines[lineIdx]
				if line then
					line.From = Vector2.new(v1.X, v1.Y)
					line.To = Vector2.new(v2.X, v2.Y)
					line.Color = self.Settings.SkeletonColor
					line.Thickness = self.Settings.SkeletonThickness
					line.Visible = true
					lineIdx = lineIdx + 1
				end
			end
		end
	end

	-- Hide unused lines
	for i = lineIdx, #skeletonLines do
		skeletonLines[i].Visible = false
	end
end

return Visuals
