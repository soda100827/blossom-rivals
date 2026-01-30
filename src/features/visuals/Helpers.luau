--!strict

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local ExploitTypes = require("../../types/ExploitTypes")
local TeamUtils = require("../../utils/TeamUtils")
local Constants = require("./Constants")
local State = require("./State")

--// Constants

--// Types

--// Private state
local Helpers = {}

--// Private helpers
function Helpers.getGlobal(name: string): any
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local genv = (env.getgenv and env.getgenv()) or env
	return genv[name] or env[name]
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
	local camera = Helpers.getCamera()
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
function Helpers.getDrawingLib(): ExploitTypes.DrawingLibrary
	local getfenvAny = getfenv :: any
	local g = getfenvAny(0) :: any
	local lib = g.Drawing
	if not lib and g.getgenv then
		lib = g.getgenv().Drawing
	end
	if not lib then
		lib = rawget(_G, "Drawing")
	end
	return lib
end

function Helpers.getCamera(): Camera
	local camera = Workspace.CurrentCamera
	if not camera then
		camera = Workspace:WaitForChild("Camera") :: Camera
	end
	return camera
end

function Helpers.clearDrawings()
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
	end
end

function Helpers.clearHighlights()
	for player, highlight in pairs(State.highlights) do
		if highlight ~= nil then
			(highlight :: Highlight):Destroy()
		end
		State.highlights[player] = nil
	end
end

function Helpers.clearAll()
	Helpers.clearDrawings()
	Helpers.clearHighlights()
end

function Helpers.removePlayer(player: Player)
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
end

function Helpers.ensurePlayerDrawings(player: Player): any
	local existing = State.drawings[player]
	if existing then
		return existing
	end

	local lib = Helpers.getDrawingLib()
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

function Helpers.updateHighlight(player: Player, character: Instance)
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

function Helpers.render()
	if not State.settings.isEspEnabled then
		Helpers.clearAll()
		return
	end

	local camera = Helpers.getCamera()
	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		return
	end
	if not TeamUtils.isInDuel(localPlayer) then
		Helpers.clearAll()
		return
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

		if not State.settings.shouldShowTeammates and TeamUtils.isSameTeam(player, localPlayer) then
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

		if State.settings.shouldShowBoxes then
			group.boxOutline.Size = boxSize
			group.boxOutline.Position = boxPos
			group.boxOutline.Color = State.settings.boxOutlineColor
			group.boxOutline.Thickness = State.settings.boxThickness + 2
			group.boxOutline.Visible = true
			group.boxOutline.ZIndex = 1

			group.box.Size = boxSize
			group.box.Position = boxPos
			group.box.Color = State.settings.boxColor
			group.box.Thickness = State.settings.boxThickness
			group.box.Visible = true
			group.box.ZIndex = 2
		else
			group.box.Visible = false
			group.boxOutline.Visible = false
		end

		if State.settings.shouldShowHealthbar then
			local healthPerc = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
			local barHeight = height * healthPerc
			group.healthbarOutline.Size = Vector2.new(4, height + 2)
			group.healthbarOutline.Position = Vector2.new(boxPos.X - 6, boxPos.Y - 1)
			group.healthbarOutline.Color = State.settings.healthbarOutlineColor
			group.healthbarOutline.Filled = true
			group.healthbarOutline.Visible = true
			group.healthbarOutline.ZIndex = 1

			group.healthbar.Size = Vector2.new(2, barHeight)
			group.healthbar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (height - barHeight))
			group.healthbar.Color = State.settings.healthbarColor:Lerp(Color3.new(1, 0, 0), 1 - healthPerc)
			group.healthbar.Filled = true
			group.healthbar.Visible = true
			group.healthbar.ZIndex = 2
		else
			group.healthbar.Visible = false
			group.healthbarOutline.Visible = false
		end

		local textOffset = 0
		if State.settings.shouldShowNames then
			group.name.Text = player.DisplayName or player.Name
			group.name.Size = State.settings.textSize
			group.name.Color = State.settings.textColor
			group.name.Outline = State.settings.shouldOutline
			group.name.OutlineColor = State.settings.nameOutlineColor
			group.name.Position = Vector2.new(rootPos.X, boxPos.Y - State.settings.textSize - 2)
			group.name.Visible = true
		else
			group.name.Visible = false
		end

		if State.settings.shouldShowWeapon then
			local tool = character:FindFirstChildOfClass("Tool")
			if tool then
				group.weapon.Text = tool.Name
				group.weapon.Size = State.settings.textSize
				group.weapon.Color = State.settings.weaponColor
				group.weapon.Outline = State.settings.shouldOutline
				group.weapon.OutlineColor = State.settings.weaponOutlineColor
				group.weapon.Position = Vector2.new(rootPos.X, boxPos.Y + height + 2 + textOffset)
				group.weapon.Visible = true
				textOffset += State.settings.textSize
			else
				group.weapon.Visible = false
			end
		else
			group.weapon.Visible = false
		end

		if State.settings.shouldShowDistance then
			group.distance.Text = tostring(math.floor(distance)) .. " studs"
			group.distance.Size = State.settings.textSize
			group.distance.Color = State.settings.distanceColor
			group.distance.Outline = State.settings.shouldOutline
			group.distance.OutlineColor = State.settings.distanceOutlineColor
			group.distance.Position = Vector2.new(rootPos.X, boxPos.Y + height + 2 + textOffset)
			group.distance.Visible = true
			textOffset += State.settings.textSize
		else
			group.distance.Visible = false
		end

		if State.settings.shouldShowSkeleton then
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

return Helpers
