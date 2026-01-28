local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.ShopLibrary)
local v_u_4 = require(v_u_1.Modules.Signal)
require(v2.LocalPlayer.PlayerScripts.Controllers.MonetizationController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6._new()
    local v7 = v_u_6
    local v8 = setmetatable({}, v7)
    v8.DailyShopRefreshed = v_u_4.new()
    v8.DailyShop = {}
    v8.DailyShopDay = nil
    v8._fetched_daily_shop = false
    v8._refresh_time = 0
    v8:_Init()
    return v8
end
function v_u_6.GetDailyShopRefreshTimeRemaining(p9)
    local v10 = p9._refresh_time - tick()
    local v11 = math.ceil(v10)
    return math.max(0, v11)
end
function v_u_6.GetDailyShop(p12)
    if not p12._fetched_daily_shop then
        task.defer(p12._FetchDailyShop, p12)
    end
    return p12.DailyShop
end
function v_u_6.GetShopEntry(p13, p14)
    if v_u_3.Entries[p14] then
        return v_u_3.Entries[p14]
    end
    for _, v15 in pairs(p13:GetDailyShop()) do
        if v15.EntryName == p14 then
            return v15
        end
    end
end
function v_u_6.UpdateDailyShop(p16, p17)
    p16.DailyShop = p17 or {}
    p16.DailyShopRefreshed:Fire()
end
function v_u_6.UpdateDailyShopCountdown(p18, p19)
    p18._refresh_time = tick() + (p19 or 0)
end
function v_u_6.PurchaseShopEntry(p20, p21, p22, p23)
    local v24 = p20:GetShopEntry(p21)
    local v25 = v24 ~= nil
    assert(v25)
    if p22 then
        v_u_1.Remotes.Data.BuyShopEntry:FireServer(v24.EntryName, p22, 1, p20:_GetIntendedDailyShopDay())
        return
    elseif p23 and v24.ProductIDTriple then
        v_u_1.Remotes.Data.BuyShopEntryRobux:FireServer(v24.EntryName, true, p20:_GetIntendedDailyShopDay())
    elseif v24.ProductID then
        v_u_1.Remotes.Data.BuyShopEntryRobux:FireServer(v24.EntryName, false, p20:_GetIntendedDailyShopDay())
    end
end
function v_u_6.BuyDailyShopRefresh(p26)
    v_u_1.Remotes.Data.RefreshDailyShop:FireServer(p26:_GetIntendedDailyShopDay())
end
function v_u_6._GetIntendedDailyShopDay(p27)
    if p27.DailyShopDay then
        return p27.DailyShopDay + v_u_5:Get("DailyShopSeedShift")
    end
    warn("self.DailyShopDay is nil")
    task.spawn(p27._FetchDailyShop, p27)
    return -1
end
function v_u_6._UpdateDailyShop(p28, p29)
    local v30 = p29 or {}
    p28.DailyShopDay = v30.Day
    p28:UpdateDailyShopCountdown(v30.TimeRemaining)
    p28:UpdateDailyShop(v30.Data)
end
function v_u_6._FetchDailyShop(p31)
    if not p31._fetched_daily_shop then
        p31._fetched_daily_shop = true
        repeat
            local v32, v33 = pcall(v_u_1.Remotes.Data.RequestDailyShop.InvokeServer, v_u_1.Remotes.Data.RequestDailyShop)
        until v32
        p31:_UpdateDailyShop(v33)
    end
end
function v_u_6._Init(p_u_34)
    v_u_1.Remotes.Data.UpdateDailyShop.OnClientEvent:Connect(function(...)
        p_u_34:_UpdateDailyShop(...)
    end)
end
return v_u_6._new()