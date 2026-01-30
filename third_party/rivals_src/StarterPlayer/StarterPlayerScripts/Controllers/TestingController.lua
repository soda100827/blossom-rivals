local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v4 = require(v1.Modules.TestLibrary)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController)
local v_u_6 = v4:GetTestAttribute("StudioFinisherTest")
local v_u_7 = v4:GetTestAttribute("StudioSkinTest")
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10:_Init()
    return v10
end
function v_u_8._SetupFinisherTest(_)
    if v_u_6 then
        v_u_5:Enter("Sniper")
    end
end
function v_u_8._SetupSkinTest(_)
    if v_u_7 then
        v_u_5:Enter(v_u_3.Cosmetics[v_u_7] and v_u_3.Cosmetics[v_u_7].ItemName or v_u_7)
    end
end
function v_u_8._Init(p11)
    task.defer(p11._SetupSkinTest, p11)
    task.defer(p11._SetupFinisherTest, p11)
end
return v_u_8._new()