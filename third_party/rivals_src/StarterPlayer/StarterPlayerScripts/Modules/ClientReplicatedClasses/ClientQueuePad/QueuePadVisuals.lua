local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.DuelLibrary)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("QueuePadPlayerSlot")
local v_u_7 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("QueuePadTeamSlot")
local v_u_8 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("QueuePadBoardGui")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.ClientQueuePad = p10
    v12._visuals_folder = v12.ClientQueuePad:Get("Model"):WaitForChild("Visuals")
    v12._teammate_slots = {}
    v12._team_slots = {}
    v12._pads = {}
    v12._surface_guis = {}
    v12:_Init()
    return v12
end
function v_u_9.Destroy(p13)
    for _, v14 in pairs(p13._surface_guis) do
        v14:Destroy()
    end
end
function v_u_9._UpdateQueueName(p15)
    local v16 = p15.ClientQueuePad:Get("NumTeams")
    local v17 = p15.ClientQueuePad:Get("PlayersPerTeam")
    local v18 = p15.ClientQueuePad:Get("InfinitePlayersPerTeam")
    local v19 = p15.ClientQueuePad:GetActualQueueName()
    local v20 = v_u_4.MatchmakingQueues[v19]
    for v21, v22 in pairs(p15._surface_guis) do
        local v23 = v22.MainFrame.Warning
        local v24 = v21 == 1 and not (v20 and v20.AreStreaksDisabled())
        if v24 then
            v24 = v_u_3.IS_PUBLIC_SERVER
        end
        v23.Visible = v24
    end
    if v20 then
        v20 = v20.TitleName
    end
    local v25 = string.rep((v18 and "\226\136\158" or v17) .. "v", v16)
    local v26 = #v25 - 1
    local v27 = string.sub(v25, 1, v26)
    p15._visuals_folder:WaitForChild("QueueName"):WaitForChild("Players"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel").Text = v27
    p15._visuals_folder:WaitForChild("QueueName"):WaitForChild("Title"):WaitForChild("SurfaceGui"):WaitForChild("Frame"):WaitForChild("TextLabel").Text = v20 or ""
    p15._visuals_folder:WaitForChild("QueueName"):WaitForChild("Title"):WaitForChild("SurfaceGui").Enabled = v20
    p15._visuals_folder:WaitForChild("QueueName"):WaitForChild("Title").Transparency = v20 and 0.4 or 1
end
function v_u_9._Update(p28)
    for _, v29 in pairs(p28._teammate_slots) do
        v29:Destroy()
    end
    p28._teammate_slots = {}
    local v30 = p28.ClientQueuePad:Get("PlayersPerTeam")
    local v31 = p28.ClientQueuePad:Get("InfinitePlayersPerTeam")
    local v32 = p28.ClientQueuePad:GetClientFightersWaiting()
    for v33, v34 in pairs(v32) do
        local v35 = p28._team_slots[v33]
        local v36 = v31 and (#v34 or v30) or v30
        v35.Slot.Title.Text = #v34 .. "/" .. (v31 and "\226\136\158" or v30)
        local v37 = v35.Slot.Full
        local v38
        if v30 <= #v34 then
            v38 = not v31
        else
            v38 = false
        end
        v37.Visible = v38
        v35.SetCellSize(v36)
        v35.CreatePlayerSlots(v36)
        for v39, v40 in pairs(v34) do
            local v41 = v35.PlayerSlots[v39]
            if v41 then
                local v42 = v_u_5.new(v40.Player.UserId, v40:Get("Controls"), 1, false, true, v40.Player:GetAttribute("StatisticDuelsWinStreak"), v40.Player:GetAttribute("Level"))
                v42.SlotFrame.Container.Background.Visible = false
                v42.SlotFrame.Parent = v41
                local v43 = p28._teammate_slots
                table.insert(v43, v42)
            end
        end
    end
    for v44, v45 in pairs(p28._pads) do
        local v46 = #v32[v44] > 0
        local v47 = v_u_4.Teams[v44]
        local v48 = v46 and 0.02 or 1
        local v49 = not v46
        if not (v46 and v47.PadColor) then
            Color3.fromRGB(202, 203, 209)
        end
        if not (v46 and v47.PadColor2) then
            Color3.fromRGB(252, 250, 255)
        end
        v45.Outer.Anchored = v49
        v45.Inner.Anchored = v49
        v45.Glow.Transparency = v48
        v45.Outer.Transparency = v48
        v45.Inner.Transparency = v48
        v45.Extra.Ribbon.Transparency = v46 and 0 or 1
    end
    p28:_UpdateQueueName()
end
function v_u_9._SetupSurfaceGui(p50, p51)
    local v52 = v_u_4.Teams[p51]
    local v53 = v_u_8:Clone()
    v53.Name = v53.Name .. p50.ClientQueuePad:Get("Model").Name
    local v_u_54 = v_u_7:Clone()
    v_u_54.Logo.Image = v52.Logo
    v_u_54.LayoutOrder = p51
    v_u_54.Parent = v53.MainFrame.TeamSlotContainer
    local v_u_55 = {}
    local function v60(p56)
        for _, v57 in pairs(v_u_55) do
            v57:Destroy()
        end
        table.clear(v_u_55)
        for v58 = 1, p56 do
            local v59 = v_u_6:Clone()
            v59.LayoutOrder = v58
            v59.Parent = v_u_54.Players
            v_u_55[v58] = v59
        end
    end
    v53.Adornee = p50._visuals_folder:WaitForChild("Board" .. p51)
    v53.Parent = v_u_2.LocalPlayer.PlayerGui
    p50._surface_guis[p51] = v53
    p50._team_slots[p51] = {
        ["Slot"] = v_u_54,
        ["PlayerSlots"] = v_u_55,
        ["SetCellSize"] = function(p61)
            local v62 = math.max(p61, 1)
            local v63 = math.sqrt(v62)
            local v64 = 1 / math.ceil(v63)
            v_u_54.Players.Layout.CellSize = UDim2.new(v64, -1, v64, -1)
        end,
        ["CreatePlayerSlots"] = v60
    }
end
function v_u_9._SetupPad(p65, p66)
    p65.ClientQueuePad:Get("Model"):WaitForChild("Important"):WaitForChild("Team" .. p66).Transparency = 1
    local v67 = p65._visuals_folder:WaitForChild("Team" .. p66)
    local v68 = v67:Clone()
    v68.Outer.CanCollide = false
    v68.Outer.CanTouch = false
    v68.Outer.CanQuery = false
    v68.Outer.Anchored = true
    local v69 = Instance.new("Attachment")
    v69.CFrame = CFrame.Angles(0, 0, 1.5707963267948966)
    v69.Parent = v68.Outer
    local v70 = Instance.new("AlignPosition")
    v70.RigidityEnabled = true
    v70.Mode = Enum.PositionAlignmentMode.OneAttachment
    v70.Position = v68.Outer.Position
    v70.Attachment0 = v69
    v70.Parent = v68.Outer
    local v71 = Instance.new("AlignOrientation")
    v71.CFrame = v69.WorldCFrame
    v71.Mode = Enum.OrientationAlignmentMode.OneAttachment
    v71.AlignType = Enum.AlignType.PrimaryAxisParallel
    v71.RigidityEnabled = true
    v71.Attachment0 = v69
    v71.Parent = v68.Outer
    local v72 = Instance.new("AngularVelocity")
    local v73 = 2 * (p66 % 2 == 0 and 1 or -1)
    v72.AngularVelocity = Vector3.new(0, v73, 0)
    v72.MaxTorque = 10000
    v72.Attachment0 = v69
    v72.Parent = v68.Outer
    v68.Inner.CanCollide = false
    v68.Inner.CanTouch = false
    v68.Inner.CanQuery = false
    v68.Inner.Anchored = true
    local v74 = Instance.new("Attachment")
    v74.CFrame = CFrame.Angles(0, 0, 1.5707963267948966)
    v74.Parent = v68.Inner
    local v75 = Instance.new("AlignPosition")
    v75.RigidityEnabled = true
    v75.Mode = Enum.PositionAlignmentMode.OneAttachment
    v75.Position = v68.Inner.Position
    v75.Attachment0 = v74
    v75.Parent = v68.Inner
    local v76 = Instance.new("AlignOrientation")
    v76.CFrame = v74.WorldCFrame
    v76.Mode = Enum.OrientationAlignmentMode.OneAttachment
    v76.AlignType = Enum.AlignType.PrimaryAxisParallel
    v76.RigidityEnabled = true
    v76.Attachment0 = v74
    v76.Parent = v68.Inner
    local v77 = Instance.new("AngularVelocity")
    local v78 = -2 * (p66 % 2 == 0 and 1 or -1)
    v77.AngularVelocity = Vector3.new(0, v78, 0)
    v77.MaxTorque = 10000
    v77.Attachment0 = v74
    v77.Parent = v68.Inner
    v68.Parent = v67.Parent
    p65._pads[p66] = v68
    v67:Destroy()
end
function v_u_9._Setup(p79)
    for v80 = 1, p79.ClientQueuePad:Get("NumTeams") do
        p79:_SetupSurfaceGui(v80)
        p79:_SetupPad(v80)
    end
    p79:_Update()
end
function v_u_9._Init(p_u_81)
    p_u_81.ClientQueuePad.Activity:Connect(function()
        p_u_81:_Update()
    end)
    task.spawn(p_u_81._Setup, p_u_81)
end
return v_u_9