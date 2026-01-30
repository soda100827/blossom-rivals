local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ItemLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.EquipmentMetricCard)
local v_u_6 = require(script:WaitForChild("MetricsGuide"))
v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentMetricSlot")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.Right = p8
    v10.MetricCard = v_u_5.new("Overview", "rbxassetid://18404346057")
    v10._set_opened_hash = 0
    v10._cleanup = {}
    v10._last_weapon_data = nil
    v10:_Init()
    return v10
end
function v_u_7.OnStateChanged(p11)
    p11:_UpdateInformation()
end
function v_u_7.OnOpen(p12)
    p12:_UpdateInformation()
end
function v_u_7._UpdateInformation(p13)
    if not p13.Right.Interface.Equipment.IsOpen or p13.Right.Interface.Equipment:IsCustomizing() then
        return
    end
    local v14 = p13.Right.Interface.Equipment:GetSelectedWeapon()
    local v15 = v_u_4:GetWeaponData(v14)
    if v15 == p13._last_weapon_data then
        return
    end
    p13.MetricCard:Clear()
    p13._last_weapon_data = v15
    if not v15 then
        return
    end
    local v16 = v_u_3.Items[v14]
    for _, v17 in pairs(v_u_6) do
        local v18, v19, v20, v21 = table.unpack(v17)
        local v22 = nil
        for _, v23 in pairs(v19) do
            if v16[v23] then
                v22 = v16[v23]
                break
            end
        end
        if v22 or #v19 <= 0 then
            local v24
            if v20 == "Custom" then
                v24 = v21(v14, v22)
            elseif v20 == "Time" then
                v24 = string.format("%.2f", v22) .. "s"
            elseif v20 == nil then
                v24 = string.format("%.0f", v22)
            else
                v24 = assert(false, v18)
            end
            if v24 then
                p13.MetricCard:Add(v18, v24)
            end
        end
    end
end
function v_u_7._Init(p_u_25)
    p_u_25.MetricCard.Clicked:Connect(function()
        p_u_25.Right:SetMetricCardVisible("Overview", false)
    end)
    v_u_4:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_25:_UpdateInformation()
    end)
    p_u_25.MetricCard:SetParent(p_u_25.Right.Container)
end
return v_u_7