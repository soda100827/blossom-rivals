--!strict

--// Services
local Players = game:GetService("Players")

--// Dependencies (require)
local ExecutorUtils = require("../../../shared/ExecutorUtils")
local PlayerUtils = require("../../../shared/PlayerUtils")
local TeamUtils = require("../../../shared/TeamUtils")
local Constants = require("../Constants")
local State = require("../State")

--// Constants

--// Types

--// Private state
local Helpers = {}
Helpers.__index = Helpers

local _maid = nil :: any
local _signals = {}
local _state = {}

--// Private helpers
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

local function _lerpVector2(a: Vector2, b: Vector2, alpha: number): Vector2
	return a:Lerp(b, alpha)
end

local function _updateSkeleton(skeletonLines, skeletonOutlineLines, character: Model)
	local camera = PlayerUtils.getCamera()
	local lineIndex = 1
	for _, pair in ipairs(Constants.R15_JOINTS) do
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
					outline.Color = State.settings.skeletonOutlineColor
					outline.Thickness = State.settings.skeletonThickness + 2
					outline.Visible = true
					outline.ZIndex = 1
				end
				local line = skeletonLines[lineIndex]
				if line then
					line.From = Vector2.new(v1.X, v1.Y)
					line.To = Vector2.new(v2.X, v2.Y)
					line.Color = State.settings.skeletonColor
					line.Thickness = State.settings.skeletonThickness
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

--// Public API
function Helpers.clearDrawings(): ()
	for player, group in pairs(State.drawings) do
		for _, drawing in pairs(group) do
			if type(drawing) == "table" then
				for _, line in pairs(drawing) do
					line:Remove()
				end
			else
				drawing:Remove()
			end
		end
		State.drawings[player] = nil
		State.smoothCache[player] = nil
	end
end

function Helpers.clearHighlights(): ()
	for player, highlight in pairs(State.highlights) do
		if highlight ~= nil then
			(highlight :: Highlight):Destroy()
		end
		State.highlights[player] = nil
		State.smoothCache[player] = nil
	end
end

function Helpers.clearAll(): ()
	Helpers.clearDrawings()
	Helpers.clearHighlights()
end

function Helpers.removePlayer(player: Player): ()
	local group = State.drawings[player]
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
		State.drawings[player] = nil
	end
	local highlight = State.highlights[player]
	if highlight ~= nil then
		(highlight :: Highlight):Destroy()
		State.highlights[player] = nil
	end
	State.smoothCache[player] = nil
end

function Helpers.ensurePlayerDrawings(player: Player): any
	local existing = State.drawings[player]
	if existing then
		return existing
	end

	local lib = ExecutorUtils.getDrawingLib()
	if not lib then
		return nil
	end

	local group = {
		name = lib.new("Text"),
		weapon = lib.new("Text"),
		distance = lib.new("Text"),
		boxOutline = lib.new("Square"),
		box = lib.new("Square"),
		healthbarOutline = lib.new("Square"),
		healthbar = lib.new("Square"),
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
		local line = lib.new("Line")
		line.Visible = false
		table.insert(group.skeleton, line)

		local outline = lib.new("Line")
		outline.Visible = false
		table.insert(group.skeletonOutline, outline)
	end

	State.drawings[player] = group
	return group
end

function Helpers.updateHighlight(player: Player, character: Instance): ()
	if not State.settings.shouldShowHighlight then
		local highlight = State.highlights[player]
		if highlight then
			highlight:Destroy()
			State.highlights[player] = nil
		end
		return
	end

	local highlight = State.highlights[player]
	if not highlight then
		local created = Instance.new("Highlight")
		created.Name = "BlossomHighlight"
		created.FillTransparency = 0.5
		created.OutlineTransparency = 0
		created.Parent = game:GetService("CoreGui")
		State.highlights[player] = created
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
	activeHighlight.FillColor = State.settings.highlightFill
	activeHighlight.OutlineColor = State.settings.highlightOutline
	activeHighlight.Enabled = true
end

function Helpers.render(): ()
	local settings = State.settings
	local overrideCheck = State.overrideCheck
	if overrideCheck and not overrideCheck() then
		if State.isEspPreviouslyEnabled then
			Helpers.clearAll()
			State.isEspPreviouslyEnabled = false
		end
		return
	end
	if not settings.isEspEnabled then
		if State.isEspPreviouslyEnabled then
			Helpers.clearAll()
			State.isEspPreviouslyEnabled = false
		end
		return
	end
	State.isEspPreviouslyEnabled = true

	local camera = PlayerUtils.getCamera()
	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		return
	end
	if not TeamUtils.isInDuel(localPlayer) then
		if State.isEspPreviouslyEnabled then
			Helpers.clearAll()
			State.isEspPreviouslyEnabled = false
		end
		return
	end

	local now = os.clock()
	local shouldUpdateSkeleton = now - State.lastSkeletonUpdate >= Constants.ESP_SKELETON_INTERVAL
	if shouldUpdateSkeleton then
		State.lastSkeletonUpdate = now
	end
	local shouldUpdateText = now - State.lastTextUpdate >= Constants.ESP_TEXT_INTERVAL
	if shouldUpdateText then
		State.lastTextUpdate = now
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer or (localPlayer.Character and player.Character == localPlayer.Character) then
			continue
		end

		if not TeamUtils.isInSameDuel(localPlayer, player) then
			Helpers.removePlayer(player)
			continue
		end

		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not character or not root or not humanoid or humanoid.Health <= 0 then
			Helpers.removePlayer(player)
			continue
		end

		if not settings.shouldShowTeammates and TeamUtils.isSameTeam(player, localPlayer) then
			Helpers.removePlayer(player)
			continue
		end

		local group = Helpers.ensurePlayerDrawings(player)
		if not group then
			continue
		end
		local rootPart = root :: BasePart
		local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
		local _, onScreen = camera:WorldToViewportPoint(rootPart.Position)
		if not onScreen then
			_setGroupVisible(group, false)
			local highlight = State.highlights[player]
			if highlight then
				highlight.Enabled = false
			end
			continue
		end

		Helpers.updateHighlight(player, character)

		local rootPos = camera:WorldToViewportPoint(rootPart.Position)
		local legPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
		local headPos = camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2, 0))
		local height = math.abs(headPos.Y - legPos.Y) * 1.5
		local width = height * 0.6
		local boxPos = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
		local boxSize = Vector2.new(width, height)

		local smooth = State.smoothCache[player]
		if not smooth then
			smooth = {
				rootPos = Vector2.new(rootPos.X, rootPos.Y),
				boxPos = boxPos,
				boxSize = boxSize,
			}
			State.smoothCache[player] = smooth
		end
		local alpha = Constants.ESP_SMOOTH_ALPHA
		smooth.rootPos = _lerpVector2(smooth.rootPos, Vector2.new(rootPos.X, rootPos.Y), alpha)
		smooth.boxPos = _lerpVector2(smooth.boxPos, boxPos, alpha)
		smooth.boxSize = _lerpVector2(smooth.boxSize, boxSize, alpha)

		local smoothedRootPos = smooth.rootPos
		local smoothedBoxPos = smooth.boxPos
		local smoothedBoxSize = smooth.boxSize

		if settings.shouldShowBoxes then
			group.boxOutline.Size = smoothedBoxSize
			group.boxOutline.Position = smoothedBoxPos
			group.boxOutline.Color = settings.boxOutlineColor
			group.boxOutline.Thickness = settings.boxThickness + 2
			group.boxOutline.Visible = true
			group.boxOutline.ZIndex = 1

			group.box.Size = smoothedBoxSize
			group.box.Position = smoothedBoxPos
			group.box.Color = settings.boxColor
			group.box.Thickness = settings.boxThickness
			group.box.Visible = true
			group.box.ZIndex = 2
		else
			group.box.Visible = false
			group.boxOutline.Visible = false
		end

		if settings.shouldShowHealthbar then
			local healthPerc = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
			local barHeight = smoothedBoxSize.Y * healthPerc
			group.healthbarOutline.Size = Vector2.new(4, smoothedBoxSize.Y + 2)
			group.healthbarOutline.Position = Vector2.new(smoothedBoxPos.X - 6, smoothedBoxPos.Y - 1)
			group.healthbarOutline.Color = settings.healthbarOutlineColor
			group.healthbarOutline.Filled = true
			group.healthbarOutline.Visible = true
			group.healthbarOutline.ZIndex = 1

			group.healthbar.Size = Vector2.new(2, barHeight)
			group.healthbar.Position =
				Vector2.new(smoothedBoxPos.X - 5, smoothedBoxPos.Y + (smoothedBoxSize.Y - barHeight))
			group.healthbar.Color = settings.healthbarColor:Lerp(Color3.new(1, 0, 0), 1 - healthPerc)
			group.healthbar.Filled = true
			group.healthbar.Visible = true
			group.healthbar.ZIndex = 2
		else
			group.healthbar.Visible = false
			group.healthbarOutline.Visible = false
		end

		if shouldUpdateText then
			local textOffset = 0
			if settings.shouldShowNames then
				group.name.Text = player.DisplayName or player.Name
				group.name.Size = settings.textSize
				group.name.Color = settings.textColor
				group.name.Outline = settings.shouldOutline
				group.name.OutlineColor = settings.nameOutlineColor
				group.name.Position = Vector2.new(smoothedRootPos.X, smoothedBoxPos.Y - settings.textSize - 2)
				group.name.Visible = true
			else
				group.name.Visible = false
			end

			if settings.shouldShowWeapon then
				local tool = character:FindFirstChildOfClass("Tool")
				if tool then
					group.weapon.Text = tool.Name
					group.weapon.Size = settings.textSize
					group.weapon.Color = settings.weaponColor
					group.weapon.Outline = settings.shouldOutline
					group.weapon.OutlineColor = settings.weaponOutlineColor
					group.weapon.Position =
						Vector2.new(smoothedRootPos.X, smoothedBoxPos.Y + smoothedBoxSize.Y + 2 + textOffset)
					group.weapon.Visible = true
					textOffset += settings.textSize
				else
					group.weapon.Visible = false
				end
			else
				group.weapon.Visible = false
			end

			if settings.shouldShowDistance then
				group.distance.Text = tostring(math.floor(distance)) .. " studs"
				group.distance.Size = settings.textSize
				group.distance.Color = settings.distanceColor
				group.distance.Outline = settings.shouldOutline
				group.distance.OutlineColor = settings.distanceOutlineColor
				group.distance.Position =
					Vector2.new(smoothedRootPos.X, smoothedBoxPos.Y + smoothedBoxSize.Y + 2 + textOffset)
				group.distance.Visible = true
				textOffset += settings.textSize
			else
				group.distance.Visible = false
			end
		end

		if settings.shouldShowSkeleton then
			if shouldUpdateSkeleton then
				_updateSkeleton(group.skeleton, group.skeletonOutline, character)
			end
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

function Helpers.getViewModelModule(): any
	local player = PlayerUtils.getLocalPlayer()
	if not player then
		return nil
	end
	local playerScripts = player:WaitForChild("PlayerScripts", 5)
	if not playerScripts then
		return nil
	end
	local modules = playerScripts:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local clientReplicatedClasses = modules:WaitForChild("ClientReplicatedClasses", 5)
	if not clientReplicatedClasses then
		return nil
	end
	local clientFighter = clientReplicatedClasses:WaitForChild("ClientFighter", 5)
	if not clientFighter then
		return nil
	end
	local clientItemScript = clientFighter:WaitForChild("ClientItem", 5)
	if not clientItemScript then
		return nil
	end
	local viewModel = clientItemScript:WaitForChild("ClientViewModel", 5)
	if not viewModel then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(viewModel)
	end)
	return success and result or nil
end

function Helpers.getHitmarkerModule(): any
	local player = PlayerUtils.getLocalPlayer()
	if not player then
		return nil
	end
	local playerScripts = player:WaitForChild("PlayerScripts", 5)
	if not playerScripts then
		return nil
	end
	local modules = playerScripts:WaitForChild("Modules", 5)
	if not modules then
		return nil
	end
	local clientReplicatedClasses = modules:WaitForChild("ClientReplicatedClasses", 5)
	if not clientReplicatedClasses then
		return nil
	end
	local clientFighter = clientReplicatedClasses:WaitForChild("ClientFighter", 5)
	if not clientFighter then
		return nil
	end
	local clientItemScript = clientFighter:WaitForChild("ClientItem", 5)
	if not clientItemScript then
		return nil
	end
	local itemInterface = clientItemScript:WaitForChild("ItemInterface", 5)
	if not itemInterface then
		return nil
	end
	local mouse = itemInterface:WaitForChild("Mouse", 5)
	if not mouse then
		return nil
	end
	local hitmarker = mouse:WaitForChild("Hitmarker", 5)
	if not hitmarker then
		return nil
	end
	local success, result = pcall(function()
		local dynamicRequire = require :: any
		return dynamicRequire(hitmarker)
	end)
	return success and result or nil
end

return Helpers
