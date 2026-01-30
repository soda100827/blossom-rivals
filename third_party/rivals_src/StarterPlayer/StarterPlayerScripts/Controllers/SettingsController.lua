local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TeleportService")
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5:_Init()
    return v5
end
function v_u_3.ChangeSetting(p6, p7, p8)
    p6:ChangeSettings({
        { p7, p8 }
    })
end
function v_u_3.ChangeSettings(_, p9)
    v_u_1.Remotes.Data.ChangeSettings:FireServer(p9)
end
function v_u_3._ResetHUDSetting(p10)
    if not v_u_2:GetTeleportSetting("DontResetHUDSetting") then
        v_u_2:SetTeleportSetting("DontResetHUDSetting", true)
        p10:ChangeSetting("Settings Hide HUD", false)
    end
end
function v_u_3._Init(p11)
    task.defer(p11._ResetHUDSetting, p11)
end
return v_u_3._new()