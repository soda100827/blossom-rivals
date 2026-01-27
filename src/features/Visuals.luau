--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any
-- local VoltTypes = require("src/types/Volt") -- We can accept it exists contextually, or define generic types.
-- Since the file is merely a type definition returning nil, we use it for type extraction.
local ExploitTypes = require("../types/ExploitTypes")

--// Constants
local LOCAL_PLAYER = Players.LocalPlayer
local DRAWING = rawget(_G, "Drawing") :: ExploitTypes.DrawingLibrary

local DEFAULT_SETTINGS = {
	isEspEnabled = false,
	shouldShowNames = true,
	shouldShowWeapon = false,
	shouldShowDistance = false,
	shouldShowBoxes = true,
	shouldShowSkeleton = false,
	shouldShowHealthbar = false,
	shouldShowHighlight = false,
	shouldCheckTeam = false,
	maxDistance = 2000,
	boxColor = Color3.new(1, 1, 1),
	textColor = Color3.new(1, 1, 1),
	weaponColor = Color3.new(1, 1, 1),
	distanceColor = Color3.new(1, 1, 1),
	skeletonColor = Color3.new(1, 1, 1),
	healthbarColor = Color3.new(0, 1, 0),
	healthbarOutlineColor = Color3.new(0, 0, 0),
	nameOutlineColor = Color3.new(0, 0, 0),
	weaponOutlineColor = Color3.new(0, 0, 0),
	distanceOutlineColor = Color3.new(0, 0, 0),
	boxOutlineColor = Color3.new(0, 0, 0),
	skeletonOutlineColor = Color3.new(0, 0, 0),
	highlightFill = Color3.new(1, 0, 0),
	highlightOutline = Color3.new(1, 1, 1),
	boxThickness = 1,
	skeletonThickness = 1,
	textSize = 12,
	shouldOutline = true,
}

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

--// Types
export type Visuals = {
	init: (self: Visuals, client: any) -> (),
	cleanup: (self: Visuals) -> (),
	toggle: (self: Visuals, isEnabled: boolean) -> (),
	setEspEnabled: (self: Visuals, isEnabled: boolean) -> (),
	setShowNames: (self: Visuals, shouldShow: boolean) -> (),
	setShowWeapon: (self: Visuals, shouldShow: boolean) -> (),
	setShowDistance: (self: Visuals, shouldShow: boolean) -> (),
	setShowBoxes: (self: Visuals, shouldShow: boolean) -> (),
	setShowSkeleton: (self: Visuals, shouldShow: boolean) -> (),
	setShowHealthbar: (self: Visuals, shouldShow: boolean) -> (),
	setShowHighlight: (self: Visuals, shouldShow: boolean) -> (),
	setTeamCheck: (self: Visuals, isEnabled: boolean) -> (),
	setMaxDistance: (self: Visuals, value: number) -> (),
	setBoxColor: (self: Visuals, color: Color3) -> (),
	setTextColor: (self: Visuals, color: Color3) -> (),
	setWeaponColor: (self: Visuals, color: Color3) -> (),
	setDistanceColor: (self: Visuals, color: Color3) -> (),
	setSkeletonColor: (self: Visuals, color: Color3) -> (),
	setHealthbarColor: (self: Visuals, color: Color3) -> (),
	setHealthbarOutlineColor: (self: Visuals, color: Color3) -> (),
	setNameOutlineColor: (self: Visuals, color: Color3) -> (),
	setWeaponOutlineColor: (self: Visuals, color: Color3) -> (),
	setDistanceOutlineColor: (self: Visuals, color: Color3) -> (),
	setBoxOutlineColor: (self: Visuals, color: Color3) -> (),
	setSkeletonOutlineColor: (self: Visuals, color: Color3) -> (),
	setHighlightFill: (self: Visuals, color: Color3) -> (),
	setHighlightOutline: (self: Visuals, color: Color3) -> (),
	setBoxThickness: (self: Visuals, value: number) -> (),
	setSkeletonThickness: (self: Visuals, value: number) -> (),
	setTextSize: (self: Visuals, value: number) -> (),
	setOutline: (self: Visuals, isEnabled: boolean) -> (),
}

--// Private state
local Visuals = {}
Visuals.__index = Visuals

local _maid = nil :: any
local _state: {
	client: any,
	logger: any,
	isEnabled: boolean,
	drawings: { [Player]: any },
	highlights: { [Player]: Highlight? },
	settings: typeof(DEFAULT_SETTINGS),
} =
	{
		client = nil :: any,
		logger = nil :: any,
		isEnabled = false,
		drawings = {},
		highlights = {},
		settings = table.clone(DEFAULT_SETTINGS),
	}
local _signals = {}

--// Private helpers
local function _getCamera(): Camera
	local camera = Workspace.CurrentCamera
	if not camera then
		camera = Workspace:WaitForChild("Camera") :: Camera
	end
	return camera
end

local function _clearDrawings()
	for player, group in pairs(_state.drawings) do
		for _, drawing in pairs(group) do
			if type(drawing) == "table" then
				for _, line in pairs(drawing) do
					line:Remove()
				end
			else
				drawing:Remove()
			end
		end
		_state.drawings[player] = nil
	end
end

local function _clearHighlights()
	for player, highlight in pairs(_state.highlights) do
		if highlight ~= nil then
			(highlight :: Highlight):Destroy()
		end
		_state.highlights[player] = nil
	end
end

local function _clear()
	_clearDrawings()
	_clearHighlights()
end

local function _removePlayer(player: Player)
	local group = _state.drawings[player]
	if group then
		for _, drawing in pairs(group) do
			if type(drawing) == "table" then
				for _, line in pairs(drawing) do
					line:Remove()
				end
			else
				drawing:Remove()
			end
		end
		_state.drawings[player] = nil
	end
	local highlight = _state.highlights[player]
	if highlight ~= nil then
		(highlight :: Highlight):Destroy()
		_state.highlights[player] = nil
	end
end

local function _ensurePlayerDrawings(player: Player): any
	local existing = _state.drawings[player]
	if existing then
		return existing
	end

	local group = {
		name = DRAWING.new("Text"),
		weapon = DRAWING.new("Text"),
		distance = DRAWING.new("Text"),
		boxOutline = DRAWING.new("Square"),
		box = DRAWING.new("Square"),
		healthbarOutline = DRAWING.new("Square"),
		healthbar = DRAWING.new("Square"),
		skeleton = {},
		skeletonOutline = {},
	}

	for _, key in ipairs({ "name", "weapon", "distance" }) do
		group[key].Center = true
		group[key].Outline = true
		group[key].Visible = false
	end

	for _, key in ipairs({ "box", "boxOutline", "healthbar", "healthbarOutline" }) do
		group[key].Visible = false
		group[key].Filled = false
	end
	group.healthbar.Filled = true
	group.healthbarOutline.Filled = true

	for _ = 1, 16 do
		local line = DRAWING.new("Line")
		line.Visible = false
		table.insert(group.skeleton, line)

		local outline = DRAWING.new("Line")
		outline.Visible = false
		table.insert(group.skeletonOutline, outline)
	end

	_state.drawings[player] = group
	return group
end

local function _updateHighlight(player: Player, character: Instance)
	if not _state.settings.shouldShowHighlight then
		local highlight = _state.highlights[player]
		if highlight then
			highlight:Destroy()
			_state.highlights[player] = nil
		end
		return
	end

	local highlight = _state.highlights[player]
	if not highlight then
		local created = Instance.new("Highlight")
		created.Name = "BlossomHighlight"
		created.FillTransparency = 0.5
		created.OutlineTransparency = 0
		created.Parent = game:GetService("CoreGui")
		_state.highlights[player] = created
		highlight = created
	end
	if not highlight then
		return
	end
	local activeHighlight = highlight :: Highlight

	local adornee = character
	if adornee:IsA("Model") then
		local rootPart = adornee:FindFirstChild("HumanoidRootPart")
		if rootPart and rootPart:IsA("BasePart") then
			adornee = rootPart
		end
	end
	if activeHighlight.Adornee ~= adornee then
		activeHighlight.Adornee = adornee
	end
	activeHighlight.FillColor = _state.settings.highlightFill
	activeHighlight.OutlineColor = _state.settings.highlightOutline
	activeHighlight.Enabled = true
end

local function _setGroupVisible(group, isVisible: boolean)
	for _, drawing in pairs(group) do
		if type(drawing) == "table" then
			for _, line in pairs(drawing) do
				line.Visible = isVisible
			end
		else
			drawing.Visible = isVisible
		end
	end
end

local function _updateSkeleton(skeletonLines, skeletonOutlineLines, character: Model)
	local camera = _getCamera()
	local lineIndex = 1
	for _, pair in ipairs(R15_JOINTS) do
		local p1 = character:FindFirstChild(pair[1])
		local p2 = character:FindFirstChild(pair[2])
		if p1 and p2 and p1:IsA("BasePart") and p2:IsA("BasePart") then
			local v1, o1 = camera:WorldToViewportPoint(p1.Position)
			local v2, o2 = camera:WorldToViewportPoint(p2.Position)
			if o1 and o2 then
				local outline = skeletonOutlineLines[lineIndex]
				if outline then
					outline.From = Vector2.new(v1.X, v1.Y)
					outline.To = Vector2.new(v2.X, v2.Y)
					outline.Color = _state.settings.skeletonOutlineColor
					outline.Thickness = _state.settings.skeletonThickness + 2
					outline.Visible = true
					outline.ZIndex = 1
				end
				local line = skeletonLines[lineIndex]
				if line then
					line.From = Vector2.new(v1.X, v1.Y)
					line.To = Vector2.new(v2.X, v2.Y)
					line.Color = _state.settings.skeletonColor
					line.Thickness = _state.settings.skeletonThickness
					line.Visible = true
					line.ZIndex = 2
					lineIndex += 1
				end
			end
		end
	end

	for i = lineIndex, #skeletonLines do
		skeletonLines[i].Visible = false
	end
	for i = lineIndex, #skeletonOutlineLines do
		skeletonOutlineLines[i].Visible = false
	end
end

local function _render()
	if not _state.settings.isEspEnabled then
		_clear()
		return
	end

	local camera = _getCamera()
	for _, player in ipairs(Players:GetPlayers()) do
		if player == LOCAL_PLAYER then
			continue
		end

		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not character or not root or not humanoid or humanoid.Health <= 0 then
			_removePlayer(player)
			continue
		end

		if _state.settings.shouldCheckTeam and player.Team == LOCAL_PLAYER.Team then
			_removePlayer(player)
			continue
		end

		local group = _ensurePlayerDrawings(player)
		local rootPart = root :: BasePart
		local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
		local _, onScreen = camera:WorldToViewportPoint(rootPart.Position)
		if not onScreen or distance > _state.settings.maxDistance then
			_setGroupVisible(group, false)
			local highlight = _state.highlights[player]
			if highlight then
				highlight.Enabled = false
			end
			continue
		end

		_updateHighlight(player, character)

		local rootPos = camera:WorldToViewportPoint(rootPart.Position)
		local legPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
		local headPos = camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2, 0))
		local height = math.abs(headPos.Y - legPos.Y) * 1.5
		local width = height * 0.6
		local boxPos = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
		local boxSize = Vector2.new(width, height)

		if _state.settings.shouldShowBoxes then
			group.boxOutline.Size = boxSize
			group.boxOutline.Position = boxPos
			group.boxOutline.Color = _state.settings.boxOutlineColor
			group.boxOutline.Thickness = _state.settings.boxThickness + 2
			group.boxOutline.Visible = true
			group.boxOutline.ZIndex = 1

			group.box.Size = boxSize
			group.box.Position = boxPos
			group.box.Color = _state.settings.boxColor
			group.box.Thickness = _state.settings.boxThickness
			group.box.Visible = true
			group.box.ZIndex = 2
		else
			group.box.Visible = false
			group.boxOutline.Visible = false
		end

		if _state.settings.shouldShowHealthbar then
			local healthPerc = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
			local barHeight = height * healthPerc
			group.healthbarOutline.Size = Vector2.new(4, height + 2)
			group.healthbarOutline.Position = Vector2.new(boxPos.X - 6, boxPos.Y - 1)
			group.healthbarOutline.Color = _state.settings.healthbarOutlineColor
			group.healthbarOutline.Filled = true
			group.healthbarOutline.Visible = true
			group.healthbarOutline.ZIndex = 1

			group.healthbar.Size = Vector2.new(2, barHeight)
			group.healthbar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (height - barHeight))
			group.healthbar.Color = _state.settings.healthbarColor:Lerp(Color3.new(1, 0, 0), 1 - healthPerc)
			group.healthbar.Filled = true
			group.healthbar.Visible = true
			group.healthbar.ZIndex = 2
		else
			group.healthbar.Visible = false
			group.healthbarOutline.Visible = false
		end

		local textOffset = 0
		if _state.settings.shouldShowNames then
			group.name.Text = player.DisplayName or player.Name
			group.name.Size = _state.settings.textSize
			group.name.Color = _state.settings.textColor
			group.name.Outline = _state.settings.shouldOutline
			group.name.OutlineColor = _state.settings.nameOutlineColor
			group.name.Position = Vector2.new(rootPos.X, boxPos.Y - _state.settings.textSize - 2)
			group.name.Visible = true
		else
			group.name.Visible = false
		end

		if _state.settings.shouldShowWeapon then
			local tool = character:FindFirstChildOfClass("Tool")
			if tool then
				group.weapon.Text = tool.Name
				group.weapon.Size = _state.settings.textSize
				group.weapon.Color = _state.settings.weaponColor
				group.weapon.Outline = _state.settings.shouldOutline
				group.weapon.OutlineColor = _state.settings.weaponOutlineColor
				group.weapon.Position = Vector2.new(rootPos.X, boxPos.Y + height + 2 + textOffset)
				group.weapon.Visible = true
				textOffset += _state.settings.textSize
			else
				group.weapon.Visible = false
			end
		else
			group.weapon.Visible = false
		end

		if _state.settings.shouldShowDistance then
			group.distance.Text = tostring(math.floor(distance)) .. " studs"
			group.distance.Size = _state.settings.textSize
			group.distance.Color = _state.settings.distanceColor
			group.distance.Outline = _state.settings.shouldOutline
			group.distance.OutlineColor = _state.settings.distanceOutlineColor
			group.distance.Position = Vector2.new(rootPos.X, boxPos.Y + height + 2 + textOffset)
			group.distance.Visible = true
			textOffset += _state.settings.textSize
		else
			group.distance.Visible = false
		end

		if _state.settings.shouldShowSkeleton then
			_updateSkeleton(group.skeleton, group.skeletonOutline, character)
		else
			for _, line in pairs(group.skeleton) do
				line.Visible = false
			end
			for _, line in pairs(group.skeletonOutline) do
				line.Visible = false
			end
		end
	end
end

local function _connect()
	_maid:DoCleaning()
	local removeConn = Players.PlayerRemoving:Connect(function(player)
		_removePlayer(player)
	end)
	_maid:GiveTask(removeConn)

	local renderConn = RunService.RenderStepped:Connect(function()
		_render()
	end)
	_maid:GiveTask(renderConn)
end

local function _enable()
	if not DRAWING then
		_state.logger:warn("Drawing API not available; Visuals disabled.")
		_state.isEnabled = false
		return
	end
	_connect()
end

local function _disable()
	_maid:DoCleaning()
	_clear()
end

--// Public API
function Visuals.init(self: Visuals, client: any): ()
	_state.client = client
	_state.logger = client.Logger
	_maid = Maid.new()
end

function Visuals.cleanup(self: Visuals): ()
	_state.isEnabled = false
	_disable()
end

function Visuals.toggle(self: Visuals, isEnabled: boolean): ()
	if _state.isEnabled == isEnabled then
		return
	end
	_state.isEnabled = isEnabled
	if isEnabled then
		_enable()
	else
		_disable()
	end
end

function Visuals.setEspEnabled(self: Visuals, isEnabled: boolean): ()
	_state.settings.isEspEnabled = isEnabled
	if not isEnabled then
		_clear()
	end
end

function Visuals.setShowNames(self: Visuals, shouldShow: boolean): ()
	_state.settings.shouldShowNames = shouldShow
end

function Visuals.setShowWeapon(self: Visuals, shouldShow: boolean): ()
	_state.settings.shouldShowWeapon = shouldShow
end

function Visuals.setShowDistance(self: Visuals, shouldShow: boolean): ()
	_state.settings.shouldShowDistance = shouldShow
end

function Visuals.setShowBoxes(self: Visuals, shouldShow: boolean): ()
	_state.settings.shouldShowBoxes = shouldShow
end

function Visuals.setShowSkeleton(self: Visuals, shouldShow: boolean): ()
	_state.settings.shouldShowSkeleton = shouldShow
end

function Visuals.setShowHealthbar(self: Visuals, shouldShow: boolean): ()
	_state.settings.shouldShowHealthbar = shouldShow
end

function Visuals.setShowHighlight(self: Visuals, shouldShow: boolean): ()
	_state.settings.shouldShowHighlight = shouldShow
	if not shouldShow then
		_clearHighlights()
	end
end

function Visuals.setTeamCheck(self: Visuals, isEnabled: boolean): ()
	_state.settings.shouldCheckTeam = isEnabled
end

function Visuals.setMaxDistance(self: Visuals, value: number): ()
	_state.settings.maxDistance = value
end

function Visuals.setBoxColor(self: Visuals, color: Color3): ()
	_state.settings.boxColor = color
end

function Visuals.setTextColor(self: Visuals, color: Color3): ()
	_state.settings.textColor = color
end

function Visuals.setWeaponColor(self: Visuals, color: Color3): ()
	_state.settings.weaponColor = color
end

function Visuals.setDistanceColor(self: Visuals, color: Color3): ()
	_state.settings.distanceColor = color
end

function Visuals.setSkeletonColor(self: Visuals, color: Color3): ()
	_state.settings.skeletonColor = color
end

function Visuals.setHealthbarColor(self: Visuals, color: Color3): ()
	_state.settings.healthbarColor = color
end

function Visuals.setHealthbarOutlineColor(self: Visuals, color: Color3): ()
	_state.settings.healthbarOutlineColor = color
end

function Visuals.setNameOutlineColor(self: Visuals, color: Color3): ()
	_state.settings.nameOutlineColor = color
end

function Visuals.setWeaponOutlineColor(self: Visuals, color: Color3): ()
	_state.settings.weaponOutlineColor = color
end

function Visuals.setDistanceOutlineColor(self: Visuals, color: Color3): ()
	_state.settings.distanceOutlineColor = color
end

function Visuals.setBoxOutlineColor(self: Visuals, color: Color3): ()
	_state.settings.boxOutlineColor = color
end

function Visuals.setSkeletonOutlineColor(self: Visuals, color: Color3): ()
	_state.settings.skeletonOutlineColor = color
end

function Visuals.setHighlightFill(self: Visuals, color: Color3): ()
	_state.settings.highlightFill = color
end

function Visuals.setHighlightOutline(self: Visuals, color: Color3): ()
	_state.settings.highlightOutline = color
end

function Visuals.setBoxThickness(self: Visuals, value: number): ()
	_state.settings.boxThickness = value
end

function Visuals.setSkeletonThickness(self: Visuals, value: number): ()
	_state.settings.skeletonThickness = value
end

function Visuals.setTextSize(self: Visuals, value: number): ()
	_state.settings.textSize = value
end

function Visuals.setOutline(self: Visuals, isEnabled: boolean): ()
	_state.settings.shouldOutline = isEnabled
end

return Visuals
