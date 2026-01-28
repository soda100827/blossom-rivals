local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels:WaitForChild("Sniper"))
local v_u_5 = ColorSequence.new(Color3.fromRGB(198, 99, 255))
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._reload_start_attachment = v9.ItemModel:WaitForChild("Body"):WaitForChild("Black"):WaitForChild("Start")
    v9._reload_finish_attachment = v9.ItemModel:WaitForChild("Body"):WaitForChild("Black"):WaitForChild("Finish")
    v9:_Init()
    return v9
end
function v_u_6.GetFriendlyTracerColor(_)
    return v_u_5
end
function v_u_6.PlayReloadStartParticles(p10)
    v_u_3:PlayParticles(p10._reload_start_attachment)
end
function v_u_6.PlayReloadFinishParticles(p11)
    v_u_3:PlayParticles(p11._reload_finish_attachment)
end
function v_u_6._Init(_) end
return v_u_6