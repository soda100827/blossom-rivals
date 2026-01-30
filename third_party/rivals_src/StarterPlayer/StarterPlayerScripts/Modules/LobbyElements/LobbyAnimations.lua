local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4._new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4._ObjectAdded(_, p8)
    while true do
        local v9 = Instance.new("Animation")
        v9.AnimationId = p8:GetAttribute("IdleAnimation")
        local v10, v11 = pcall(p8.LoadAnimation, p8, v9)
        if v10 and pcall(v11.Play, v11) then
            break
        end
        wait(1)
    end
end
function v_u_4._Init(p_u_12)
    v_u_1:GetInstanceAddedSignal("LobbyAnimation"):Connect(function(p13)
        p_u_12:_ObjectAdded(p13)
    end)
    for _, v14 in pairs(v_u_1:GetTagged("LobbyAnimation")) do
        task.defer(p_u_12._ObjectAdded, p_u_12, v14)
    end
end
return v_u_4._new()