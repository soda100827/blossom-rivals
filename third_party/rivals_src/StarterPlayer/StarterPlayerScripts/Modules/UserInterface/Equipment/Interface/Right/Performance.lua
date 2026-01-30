local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Modules.EquipmentMetricCard)
local v_u_4 = require(v1.LocalPlayer.PlayerScripts.Modules.StatisticsList)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.Right = p6
    v8.MetricCard = v_u_3.new("Statistics", "rbxassetid://17336063541")
    v8.StatisticsList = v_u_4.new(v8.MetricCard.Container, 1, true)
    v8:_Init()
    return v8
end
function v_u_5.OnStateChanged(p9)
    p9:_UpdateInformation()
end
function v_u_5.OnOpen(p10)
    p10:_UpdateInformation()
end
function v_u_5._UpdateInformation(p11)
    if p11.Right.Interface.Equipment.IsOpen and not p11.Right.Interface.Equipment:IsCustomizing() then
        local v12 = p11.Right.Interface.Equipment:IsCareerPageOpen()
        local v13 = p11.Right.Interface.Equipment:GetSelectedWeapon()
        local v14 = v_u_2:GetWeaponData(v13)
        if v12 then
            p11.StatisticsList:Generate(true, nil, nil)
            return
        elseif v14 then
            p11.StatisticsList:Generate(false, "WeaponStatistics", v13)
        else
            p11.StatisticsList:Clear()
        end
    else
        p11.StatisticsList:Clear()
        return
    end
end
function v_u_5._Init(p_u_15)
    p_u_15.MetricCard.Clicked:Connect(function()
        p_u_15.Right:SetMetricCardVisible("Performance", false)
    end)
    v_u_2:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_15:_UpdateInformation()
    end)
    p_u_15.MetricCard:SetParent(p_u_15.Right.Container)
end
return v_u_5