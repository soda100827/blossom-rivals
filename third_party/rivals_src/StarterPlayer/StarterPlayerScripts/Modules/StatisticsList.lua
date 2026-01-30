local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.StatisticsLibrary)
local v_u_4 = require(v1.Modules.ItemLibrary)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_9 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("StatisticParentSlot")
local v_u_10 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("StatisticChildSlot")
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new(p12, p13, p14)
    local v15 = v_u_11
    local v16 = setmetatable({}, v15)
    v16._parent = p12
    v16._layout_order = p13
    v16._expand_all_statistics = p14
    v16._statistic_slots = {}
    v16._dependent_statistic_slots = {}
    v16:_Init()
    return v16
end
function v_u_11.Clear(p17)
    for _, v18 in pairs(p17._statistic_slots) do
        v18:Destroy()
    end
    p17._statistic_slots = {}
    p17._dependent_statistic_slots = {}
end
function v_u_11.Generate(p_u_19, p_u_20, p_u_21, p_u_22)
    p_u_19:Clear()
    local v23 = v_u_3:GetStatisticsDirectoryInfo(p_u_21)
    local v24 = p_u_20 and v_u_3:GetCareerStatistics(v_u_5:GetUnlockedWeapons())
    if not v24 then
        if v23[2][p_u_22] then
            v24 = v23[2][p_u_22].DataNames or nil
        else
            v24 = nil
        end
    end
    if v24 then
        local v_u_25 = 0
        local function v_u_34(p26, p27)
            if p_u_19._statistic_slots[p26] then
                return
            else
                local v28 = v_u_3.Info[p26]
                local v29
                if p_u_20 then
                    v29 = v_u_5:GetStatistic(p26)
                else
                    v29 = v_u_5:GetDirectoryStatistic(p_u_21, p_u_22, p26)
                end
                local v30 = (p26 == "StatisticFavoriteWeapon" or (p26 == "StatisticFavoriteWeaponPrimary" or (p26 == "StatisticFavoriteWeaponSecondary" or p26 == "StatisticFavoriteWeaponMelee"))) and true or p26 == "StatisticFavoriteWeaponUtility"
                local v31 = v30 or p26 == "StatisticFavoriteMap"
                if not v28.OnlyDisplayNonZero or v29 and v29 ~= 0 then
                    local v32 = (v28.ParentDataName and v_u_10 or v_u_9):Clone()
                    v32.TitleContainer.Title.Text = v28.DisplayName
                    v32.TitleContainer.Position = v28.ParentDataName and UDim2.new(0.125, 0, 0.5, 0) or UDim2.new(0.0625, 0, 0.5, 0)
                    v32.Value.Text = v28.IsStatisticFolder and "" or v28.TostringFunction(v29)
                    v32.Value.Size = v31 and UDim2.new(0.35, 0, 1, 0) or v32.Value.Size
                    v32.LayoutOrder = p_u_19._layout_order + p27
                    v32.Visible = v28.IsStatisticFolder and true or false or p_u_19._expand_all_statistics or (not v28.ParentDataName or p_u_20)
                    v32.Parent = p_u_19._parent
                    p_u_19._statistic_slots[p26] = v32
                    v_u_25 = v_u_25 + 1
                    if v30 and v_u_4.Items[v29] then
                        v_u_6:ApplyItemStatusToText(v32.Value, v_u_4.Items[v29].Status)
                    end
                    if v28.ParentDataName then
                        p_u_19._dependent_statistic_slots[v28.ParentDataName] = p_u_19._dependent_statistic_slots[v28.ParentDataName] or {}
                        local v33 = p_u_19._dependent_statistic_slots[v28.ParentDataName]
                        table.insert(v33, v32)
                        v_u_34(v28.ParentDataName, p27 - 1)
                    else
                        v32.Arrow.Visible = false
                    end
                    v_u_8:ScrollingTextLabel(v32.TitleContainer, v32.TitleContainer.Title, v32.Value)
                end
            end
        end
        local v35 = v_u_25
        for v36, v37 in pairs(v24) do
            v_u_34(v37, v36 * 2)
        end
        for v38, v_u_39 in pairs(p_u_19._dependent_statistic_slots) do
            p_u_19._statistic_slots[v38].Visible = true
            local v_u_40 = p_u_19._statistic_slots[v38]
            local v_u_41 = false
            v_u_40.Button.MouseButton1Click:Connect(function()
                v_u_41 = not v_u_41
                v_u_40.Arrow.Image = v_u_41 and "rbxassetid://17654601337" or "rbxassetid://17654548862"
                for _, v42 in pairs(v_u_39) do
                    v42.Visible = v_u_41
                end
            end)
            v_u_41 = p_u_19._expand_all_statistics or p_u_20
            v_u_40.Arrow.Image = v_u_41 and "rbxassetid://17654601337" or "rbxassetid://17654548862"
            local v43 = v_u_41
            for _, v44 in pairs(v_u_39) do
                v44.Visible = v43
            end
            v_u_40.Arrow.Visible = true
            v_u_7:Add(v_u_40.Button, true, {
                ["TargetElement"] = v_u_40.Arrow
            })
        end
        return v35 > 0
    end
end
function v_u_11._Init(_) end
return v_u_11