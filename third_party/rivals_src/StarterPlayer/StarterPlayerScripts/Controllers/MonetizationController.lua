local v_u_1 = game:GetService("MarketplaceService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.MonetizationLibrary)
local v_u_5 = require(v_u_2.Modules.Utility)
local v_u_6 = require(v_u_2.Modules.Signal)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10.PurchaseStarted = v_u_6.new()
    v10.PurchaseFinished = v_u_6.new()
    v10._fetch_robux_price_hashes = {}
    v10:_Init()
    return v10
end
function v_u_8.PromptProductPurchase(p11, p12)
    local v13 = typeof(p12) == "number"
    local v14 = "Argument 1 invalid, expected a number, got " .. tostring(p12)
    assert(v13, v14)
    v_u_1:PromptProductPurchase(v_u_3.LocalPlayer, p12)
    p11:_StartPrompt()
end
function v_u_8.PromptGamePassPurchase(p15, p16)
    local v17 = typeof(p16) == "number"
    local v18 = "Argument 1 invalid, expected a number, got " .. tostring(p16)
    assert(v17, v18)
    if not v_u_7:HasGamepass(v_u_4:GetGamepassName(p16)) then
        v_u_1:PromptGamePassPurchase(v_u_3.LocalPlayer, p16)
        p15:_StartPrompt()
    end
end
function v_u_8.PromptSubscriptionPurchase(p19, p20)
    local v21 = typeof(p20) == "string"
    local v22 = "Argument 1 invalid, expected a string, got " .. tostring(p20)
    assert(v21, v22)
    v_u_1:PromptSubscriptionPurchase(v_u_3.LocalPlayer, p20)
    p19:_StartPrompt()
end
function v_u_8.PromptCurrencyBundlePurchase(p23, p24, p25)
    local v26 = p24 - v_u_7:Get(p25)
    if v26 <= 0 then
        return
    else
        local v27 = p25 == "WeaponKeys" and v_u_4.NUM_KEY_BUNDLES or (p25 == "EventCurrency" and v_u_4.NUM_EVENT_CURRENCY_BUNDLES or nil)
        local v28 = p25 == "WeaponKeys" and "keybundle_" or (p25 == "EventCurrency" and "eventcurrencybundle_" or nil)
        if v27 and v28 then
            for v29 = 1, v27 do
                local v30 = v_u_4.Bundles[v28 .. v29]
                if v26 <= v30.Rewards[1].Quantity then
                    p23:PromptProductPurchase(v30.ProductID)
                    return true
                end
            end
        end
    end
end
function v_u_8.FetchRobuxPrice(_, p31, p32)
    local v34, v34 = pcall(v_u_1.GetProductInfo, v_u_1, p31, p32 or Enum.InfoType.Product)
    if not v34 then
        warn("Failed to fetch robux price:", v34)
    end
    if v34 then
        if v34 then
            v34 = v34.PriceInRobux
        end
    end
    return v34
end
function v_u_8.SetRobuxText(p_u_35, p_u_36, p_u_37, p_u_38)
    p_u_35._fetch_robux_price_hashes[p_u_36] = (p_u_35._fetch_robux_price_hashes[p_u_36] or 0) + 1
    local v_u_39 = p_u_35._fetch_robux_price_hashes[p_u_36]
    p_u_36.Text = "\226\128\162 \226\128\162 \226\128\162"
    task.spawn(function()
        local v40 = p_u_35:FetchRobuxPrice(p_u_37, p_u_38)
        if v40 and v_u_39 == p_u_35._fetch_robux_price_hashes[p_u_36] then
            p_u_36.Text = utf8.char(57346) .. " " .. v_u_5:PrettyNumber(v40)
        end
    end)
end
function v_u_8._StartPrompt(p41)
    p41.PurchaseStarted:Fire()
end
function v_u_8._FinishPrompt(p42, p43)
    p42.PurchaseFinished:Fire(p43)
end
function v_u_8._Init(p_u_44)
    v_u_2.Remotes.Misc.StartPurchasePrompt.OnClientEvent:Connect(function()
        p_u_44:_StartPrompt()
    end)
    v_u_2.Remotes.Misc.FinishPurchasePrompt.OnClientEvent:Connect(function(p45)
        p_u_44:_FinishPrompt(p45)
    end)
end
return v_u_8._new()