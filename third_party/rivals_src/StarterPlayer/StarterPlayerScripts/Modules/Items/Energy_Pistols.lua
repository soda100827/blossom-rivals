local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local v_u_3 = v1.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("EnergyTracerEffect")
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4._ImpactMarker(_, _) end
function v_u_4._Tracers(p8, p9)
    local v12 = {
        ["PlayFlyBySound"] = function(_, _) end,
        ["Template"] = v_u_3,
        ["InitCallback"] = function(p10, _)
            for _, v11 in pairs(p10:GetDescendants()) do
                if v11:IsA("Beam") then
                    v11.Width1 = 0
                end
            end
        end
    }
    return v_u_2._Tracers(p8, p9, v12)
end
function v_u_4._Init(_) end
return v_u_4