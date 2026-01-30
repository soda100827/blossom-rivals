local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_7 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("JoinQueuePadPlayerSlot")
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("JoinQueuePadTeamSlot")
local v_u_9 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("JoinQueuePadTitleVS")
local v_u_10 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("JoinQueuePadSlot")
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12)
    local v13 = v_u_11
    local v14 = setmetatable({}, v13)
    v14.VisibilityChanged = v_u_4.new()
    v14.ClientQueuePad = p12
    v14.Frame = v_u_10:Clone()
    v14._team_slots = {}
    v14._extra_team_related_objects = {}
    v14._update_hash = 0
    v14:_Init()
    return v14
end
function v_u_11.IsVisible(p15)
    return p15.Frame.Visible
end
function v_u_11._Update(p_u_16)
    local v17 = p_u_16.ClientQueuePad:GetClientFightersWaiting()
    local v18 = 0
    for v19 = 1, p_u_16.ClientQueuePad:Get("NumTeams") do
        for v20 = 1, p_u_16.ClientQueuePad:Get("PlayersPerTeam") do
            local v21 = p_u_16._team_slots[v19].PlayerSlots[v20]
            local v22 = v17[v19][v20]
            if v22 then
                v18 = v18 + 1
                v21.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, v22.Player.UserId)
                v21.Dots:RemoveTag("UILoadingDots")
                v21.Dots.Visible = false
            else
                v21.Headshot.Image = ""
                v21.Dots:AddTag("UILoadingDots")
                v21.Dots.Visible = true
            end
        end
    end
    local v23
    if v18 > 0 then
        v23 = v18 < p_u_16.ClientQueuePad:Get("NumTeams") * p_u_16.ClientQueuePad:Get("PlayersPerTeam")
    else
        v23 = false
    end
    if v23 then
        task.spawn(function()
            local v24 = p_u_16._update_hash
            wait(1)
            if v24 == p_u_16._update_hash and not p_u_16.Frame.Visible then
                local v25 = p_u_16
                v25._update_hash = v25._update_hash + 1
                p_u_16.Frame.Visible = true
                p_u_16.VisibilityChanged:Fire()
                p_u_16.Frame.Container.Position = UDim2.new(4, 0, 0, 0)
                p_u_16.Frame.Container:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quint", 0.5, true)
            end
        end)
    else
        p_u_16._update_hash = p_u_16._update_hash + 1
        p_u_16.Frame.Visible = false
        p_u_16.VisibilityChanged:Fire()
    end
end
function v_u_11._Generate(p26)
    for _, v27 in pairs(p26._team_slots) do
        v27.Slot:Destroy()
    end
    for _, v28 in pairs(p26._extra_team_related_objects) do
        v28:Destroy()
    end
    p26._team_slots = {}
    p26._extra_team_related_objects = {}
    local v29 = p26.ClientQueuePad:Get("PlayersPerTeam")
    local v30 = math.sqrt(v29)
    local v31 = 1 / math.ceil(v30)
    local v32 = 0
    for v33 = 1, p26.ClientQueuePad:Get("NumTeams") do
        v32 = v32 + 1
        local v34 = v_u_8:Clone()
        v34.LayoutOrder = v32
        v34.Container.Layout.CellSize = UDim2.new(v31, 0, v31, 0)
        v34.Container.Layout.StartCorner = p26.ClientQueuePad:Get("NumTeams") == 2 and v33 == 2 and Enum.StartCorner.TopRight or Enum.StartCorner.TopLeft
        v34.Parent = p26.Frame.Container.Details
        local v35 = {}
        for v36 = 1, p26.ClientQueuePad:Get("PlayersPerTeam") do
            local v37 = v_u_7:Clone()
            v37.LayoutOrder = v36
            v37.Parent = v34.Container
            v35[v36] = v37
        end
        p26._team_slots[v33] = {
            ["Slot"] = v34,
            ["PlayerSlots"] = v35
        }
        if v33 < p26.ClientQueuePad:Get("NumTeams") then
            v32 = v32 + 1
            local v38 = v_u_9:Clone()
            v38.LayoutOrder = v32
            v38.Parent = p26.Frame.Container.Details
            local v39 = p26._extra_team_related_objects
            table.insert(v39, v38)
        end
    end
    local v40 = 0.375 * (p26.ClientQueuePad:Get("NumTeams") - 2)
    p26.Frame.Container.Join.Size = UDim2.new(0.6 / (1 + v40 * 1.5), 0, 0.3, 0)
    p26.Frame.Size = UDim2.new(0.6666666666666666 + v40, 0, 1, 0)
end
function v_u_11._Init(p_u_41)
    p_u_41.Frame.Container.Join.MouseButton1Click:Connect(function()
        if v_u_5.LocalFighter and v_u_5.LocalFighter:IsAlive() then
            v_u_5.LocalFighter.Entity.Model:PivotTo(CFrame.new(p_u_41.ClientQueuePad:GetTeleportPosition()) * v_u_5.LocalFighter.Entity.Model:GetPivot().Rotation)
        end
    end)
    p_u_41.ClientQueuePad.Activity:Connect(function(p42)
        if p42 == "PlayersPerTeam" then
            p_u_41:_Generate()
        end
        p_u_41:_Update()
    end)
    p_u_41:_Generate()
    p_u_41:_Update()
    v_u_6:Add(p_u_41.Frame.Container.Join)
end
return v_u_11