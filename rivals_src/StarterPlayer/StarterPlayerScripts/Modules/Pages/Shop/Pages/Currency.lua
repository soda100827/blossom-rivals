local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CurrencyLibrary)
local v_u_4 = require(v1.Modules.EventLibrary)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Pages = p7
    v9.Frame = v9.Pages.Frame:WaitForChild("Currency")
    v9.WeaponKeysFrame = v9.Frame:WaitForChild("WeaponKeys")
    v9.EventCurrencyFrame = v9.Frame:WaitForChild("EventCurrency")
    v9.EventCurrencyHeaderIcon = v9.EventCurrencyFrame:WaitForChild("Header"):WaitForChild("Icon")
    v9:_Init()
    return v9
end
function v_u_6.Open(_) end
function v_u_6.Close(_) end
function v_u_6.Setup(p10)
    for v11 = 1, 5 do
        local v12 = "keybundle_" .. v11
        p10.Pages.Shop:CreateBundleSlot(p10.WeaponKeysFrame:WaitForChild(v12), v12)
    end
    if v_u_4.IS_ACTIVE then
        for v13 = 1, 5 do
            local v14 = "eventcurrencybundle_" .. v13
            local v15 = p10.EventCurrencyFrame:WaitForChild(v14)
            v15.Container.Icon.Image = v_u_4.EVENT_DETAILS.BUNDLE_BACKGROUND_IMAGES[v13] or v_u_4.EVENT_DETAILS.BUNDLE_BACKGROUND_IMAGES[1]
            v15.Container.Background.ImageColor3 = v_u_3.Info.EventCurrency.Color
            p10.Pages.Shop:CreateBundleSlot(v15, v14)
        end
    end
end
function v_u_6._UpdateEvent(p16)
    local v17 = v_u_4.IS_ACTIVE
    if v17 then
        v17 = v_u_5:GetStatistic("StatisticDuelsPlayed") >= v_u_4.NUM_GAMES_NEEDED_TO_PARTICIPATE
    end
    p16.EventCurrencyFrame.Visible = v17
end
function v_u_6._Setup(p18)
    p18.EventCurrencyHeaderIcon.Image = v_u_4.EVENT_DETAILS.CURRENCY_IMAGE_FLAT
end
function v_u_6._Init(p_u_19)
    v_u_5:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_19:_UpdateEvent()
    end)
    p_u_19:_Setup()
    p_u_19:_UpdateEvent()
end
return v_u_6