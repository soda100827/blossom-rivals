local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"):WaitForChild("DialogPage"))
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4._new()
    local v5 = v_u_3.new(script.Name)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.Open(p8, ...)
    v_u_3.Open(p8, ...)
    task.defer(p8._FetchDialog, p8, v_u_1.Remotes.Misc.FetchDialogShadyChicken)
end
function v_u_4._Init(_) end
return v_u_4._new()