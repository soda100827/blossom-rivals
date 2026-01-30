local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4._new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4._ModelAdded(_, p8)
    local v9 = p8:WaitForChild("From")
    local v_u_10 = p8:WaitForChild("To")
    local v_u_11 = 0
    v9.Touched:Connect(function(p12)
        if v_u_11 < tick() and (p12 and (p12.AssemblyRootPart and (p12.AssemblyRootPart.Parent and v_u_2:GetPlayerFromCharacter(p12.AssemblyRootPart.Parent) == v_u_2.LocalPlayer))) then
            v_u_11 = tick() + 1
            p12.AssemblyRootPart.Parent.HumanoidRootPart.CFrame = CFrame.new(v_u_10.Position) * p12.AssemblyRootPart.Parent.HumanoidRootPart.CFrame.Rotation
        end
    end)
end
function v_u_4._Init(p_u_13)
    v_u_1:GetInstanceAddedSignal("LobbyTeleporter"):Connect(function(p14)
        p_u_13:_ModelAdded(p14)
    end)
    for _, v15 in pairs(v_u_1:GetTagged("LobbyTeleporter")) do
        task.defer(p_u_13._ModelAdded, p_u_13, v15)
    end
end
return v_u_4._new()