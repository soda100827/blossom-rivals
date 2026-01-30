game:GetService("CollectionService")
local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_4 = require(v1.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_5
    local v7 = setmetatable({}, v6)
    v7._connections = {}
    v7._local_fighter = nil
    v7:_Init()
    return v7
end
function v_u_5._ObjectAdded(_, p8)
    if v_u_3.CurrentSubject and v_u_3.CurrentSubject.FighterInterface then
        if p8:IsDescendantOf(workspace) and p8.Parent:IsA("BasePart") then
            v_u_3.CurrentSubject.FighterInterface.AudioVisualizers:Create(p8, p8.RollOffMinDistance, p8.RollOffMaxDistance)
        end
    else
        return
    end
end
function v_u_5._UpdateEnabled(p9)
    for _, v10 in pairs(p9._connections) do
        v10:Disconnect()
    end
    p9._connections = {}
end
function v_u_5._HookLocalFighter(p_u_11)
    p_u_11._local_fighter = v_u_4:WaitForLocalFighter()
    p_u_11._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_11:_UpdateEnabled()
    end)
    p_u_11._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_11:_UpdateEnabled()
    end)
    p_u_11:_UpdateEnabled()
end
function v_u_5._Init(p_u_12)
    v_u_2:GetDataChangedSignal("Settings Audio Visualizers"):Connect(function()
        p_u_12:_UpdateEnabled()
    end)
    p_u_12:_UpdateEnabled()
    task.defer(p_u_12._HookLocalFighter, p_u_12)
end
return v_u_5._new()