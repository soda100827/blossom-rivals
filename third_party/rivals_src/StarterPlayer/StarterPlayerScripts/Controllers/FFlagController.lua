local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v_u_1.Modules.ReplicatedClass)
local v_u_3 = require(v_u_1.Modules.ItemLibrary)
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_2.new()
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.GetFFlag(p8, p9)
    return p8:Get(p9)
end
function v_u_4.SetFFlag(p10, p11, p12)
    p10:SetReplicate(p11, p12)
end
function v_u_4.IsFreeWeaponsActive(p13)
    for v14 in pairs(v_u_3.Statuses) do
        if p13:GetFFlag("FreeToUse" .. v14 .. "Weapons") then
            return true
        end
    end
end
function v_u_4._Fetch(p15)
    local v16 = v_u_1.Remotes.Misc.RequestFFlags:InvokeServer()
    for v17, v18 in pairs(v16) do
        p15:SetFFlag(v17, v18)
    end
end
function v_u_4._Init(p_u_19)
    v_u_1.Remotes.Misc.UpdateFFlag.OnClientEvent:Connect(function(...)
        p_u_19:SetFFlag(...)
    end)
    task.defer(p_u_19._Fetch, p_u_19)
end
return v_u_4._new()