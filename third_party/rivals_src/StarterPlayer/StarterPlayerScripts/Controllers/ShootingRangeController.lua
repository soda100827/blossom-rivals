local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v_u_2.Modules.CONSTANTS)
local v_u_6 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ShootingRangeDisplay"))
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_9 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new()
    local v11 = v_u_10
    local v12 = setmetatable({}, v11)
    v12._enter_cooldown = 0
    v12._exit_cooldown = 0
    v12._shooting_range_displays = {}
    v12:_Init()
    return v12
end
function v_u_10.Enter(_, ...)
    v_u_8.PageSystem:CloseCurrentPage()
    v_u_2.Remotes.Misc.ShootingRangeEnter:FireServer(...)
end
function v_u_10.Leave(_, p13)
    v_u_2.Remotes.Misc.ShootingRangeLeave:FireServer(p13)
end
function v_u_10._TrashPromptAdded(_, p14)
    local v15 = p14:WaitForChild("Primary"):WaitForChild("ProximityPrompt")
    local v_u_16 = p14:WaitForChild("MeshPart"):WaitForChild("Close")
    local v_u_17 = p14:WaitForChild("MeshPart"):WaitForChild("Open")
    local v_u_18 = p14:WaitForChild("Lid")
    local v_u_19 = nil
    local function v_u_21(p20)
        if v_u_19 then
            v_u_19:Pause()
            v_u_19:Destroy()
        end
        v_u_19 = v_u_3:Create(v_u_18, v_u_9, {
            ["CFrame"] = p20
        })
        v_u_19:Play()
    end
    v15.PromptShown:Connect(function()
        v_u_21(v_u_17.WorldCFrame)
    end)
    v15.PromptHidden:Connect(function()
        v_u_21(v_u_16.WorldCFrame)
    end)
    v15.Triggered:Connect(function(p22)
        if p22 == v_u_4.LocalPlayer then
            v_u_2.Remotes.Misc.ShootingRangeTrashItems:FireServer()
        end
    end)
end
function v_u_10._EntranceAdded(p_u_23, p24)
    p24.Touched:Connect(function(p25)
        if tick() > p_u_23._enter_cooldown and (p25 and (p25.AssemblyRootPart and (p25.AssemblyRootPart.Parent and v_u_4:GetPlayerFromCharacter(p25.AssemblyRootPart.Parent) == v_u_4.LocalPlayer))) then
            p_u_23._enter_cooldown = tick() + 1
            p_u_23:Enter()
        end
    end)
    p_u_23._shooting_range_displays[p24] = v_u_7.new(p24)
end
function v_u_10._ExitAdded(p_u_26, p27)
    p27.Touched:Connect(function(p28)
        if tick() > p_u_26._exit_cooldown and (p28 and (p28.AssemblyRootPart and (p28.AssemblyRootPart.Parent and v_u_4:GetPlayerFromCharacter(p28.AssemblyRootPart.Parent) == v_u_4.LocalPlayer))) then
            p_u_26._exit_cooldown = tick() + 1
            p_u_26:Leave()
        end
    end)
end
function v_u_10._HookLocalFighter(p_u_29)
    local v_u_30 = v_u_6:WaitForLocalFighter()
    local function v33()
        local v31 = not v_u_30:Get("IsInDuel")
        if v31 then
            v31 = not v_u_30:Get("IsInShootingRange")
        end
        for _, v32 in pairs(p_u_29._shooting_range_displays) do
            v32:SetEnabled(v31)
        end
    end
    v_u_30:GetDataChangedSignal("IsInShootingRange"):Connect(v33)
    v_u_30:GetDataChangedSignal("IsInDuel"):Connect(v33)
    v33()
end
function v_u_10._ShootingRangeVisuals(_)
    local function v37(p34)
        local v35 = p34:WaitForChild("Doors")
        local v36 = p34:WaitForChild("Sign")
        if v_u_5.SHOOTING_RANGE_ACTIVE then
            task.defer(v35.Destroy, v35)
        else
            task.defer(v36.Destroy, v36)
            v35:PivotTo(v35:GetPivot() + Vector3.new(0, 100, 0))
        end
    end
    v_u_1:GetInstanceAddedSignal("LobbyShootingRangeVisuals"):Connect(v37)
    for _, v38 in pairs(v_u_1:GetTagged("LobbyShootingRangeVisuals")) do
        task.defer(v37, v38)
    end
end
function v_u_10._Init(p_u_39)
    task.defer(p_u_39._ShootingRangeVisuals, p_u_39)
    if v_u_5.SHOOTING_RANGE_ACTIVE then
        v_u_1:GetInstanceAddedSignal("ShootingRangeEntrance"):Connect(function(p40)
            p_u_39:_EntranceAdded(p40)
        end)
        v_u_1:GetInstanceAddedSignal("ShootingRangeTrashPrompt"):Connect(function(p41)
            p_u_39:_TrashPromptAdded(p41)
        end)
        v_u_1:GetInstanceAddedSignal("ShootingRangeExit"):Connect(function(p42)
            p_u_39:_ExitAdded(p42)
        end)
        for _, v43 in pairs(v_u_1:GetTagged("ShootingRangeEntrance")) do
            task.defer(p_u_39._EntranceAdded, p_u_39, v43)
        end
        for _, v44 in pairs(v_u_1:GetTagged("ShootingRangeTrashCan")) do
            task.defer(p_u_39._TrashPromptAdded, p_u_39, v44)
        end
        for _, v45 in pairs(v_u_1:GetTagged("ShootingRangeExit")) do
            task.defer(p_u_39._ExitAdded, p_u_39, v45)
        end
        task.spawn(p_u_39._HookLocalFighter, p_u_39)
    end
end
return v_u_10._new()