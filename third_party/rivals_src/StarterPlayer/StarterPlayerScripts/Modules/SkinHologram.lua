local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.ShopController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Part = p7
    v9.HologramViewModel = nil
    v9.SkinViewModel = nil
    v9._connections = {}
    v9._index = 0
    v9._next_increment = 0
    v9._last_change = 0
    v9:_Init()
    return v9
end
function v_u_6.Set(p10, p11)
    if p10.HologramViewModel then
        p10.HologramViewModel:Destroy()
        p10.HologramViewModel = nil
    end
    if p10.SkinViewModel then
        p10.SkinViewModel:Destroy()
        p10.SkinViewModel = nil
    end
    if p11 then
        p10._last_change = tick()
        p10.HologramViewModel = v_u_5.new(p11)
        p10.HologramViewModel:SetWrap({
            ["Name"] = "Hologram"
        })
        p10.HologramViewModel:ScaleTo(4)
        p10.SkinViewModel = v_u_5.new(p11)
        p10.SkinViewModel:ScaleTo(4)
        p10:Update(0)
    end
end
function v_u_6.Increment(p12, p13)
    local v14 = p12:_GetSkinNames()
    if #v14 == 0 then
        p12:Set(nil)
    else
        local v15
        if p13 then
            v15 = (p12._index - 1) % #v14 + 1
        else
            v15 = p12._index % #v14 + 1
        end
        p12._index = v15
        p12:Set(v14[p12._index])
    end
end
function v_u_6.Update(p16, _)
    if tick() > p16._next_increment then
        p16._next_increment = tick() + 10
        p16:Increment()
    end
    local v17 = tick() - p16._last_change
    local v18
    if v17 > 1.5 then
        v18 = false
    else
        local v19 = 10 * v17 - v17 ^ 3
        v18 = math.floor(v19) % 2 == 1
    end
    if p16.HologramViewModel then
        p16.HologramViewModel:PivotTo(p16.Part.CFrame)
        local v20 = p16.HologramViewModel
        local v21
        if v18 then
            v21 = p16.Part
        else
            v21 = nil
        end
        v20:SetParent(v21)
    end
    if p16.SkinViewModel then
        p16.SkinViewModel:PivotTo(p16.Part.CFrame)
        local v22 = p16.SkinViewModel
        local v23
        if v18 then
            v23 = nil
        else
            v23 = p16.Part
        end
        v22:SetParent(v23)
    end
end
function v_u_6.Destroy(p24)
    for _, v25 in pairs(p24._connections) do
        v25:Disconnect()
    end
    p24._connections = {}
    p24:Set(nil)
end
function v_u_6._GetSkinNames(_)
    local v26 = {}
    for _, v27 in pairs(v_u_4:GetDailyShop()) do
        local v28 = v27.Rewards[1]
        if v_u_3.Cosmetics[v28.Name].Type == "Skin" then
            local v29 = v28.Name
            table.insert(v26, v29)
        end
    end
    return v26
end
function v_u_6._Init(p_u_30)
    local v31 = p_u_30._connections
    local v32 = v_u_4.DailyShopRefreshed
    table.insert(v31, v32:Connect(function()
        p_u_30:Increment(true)
    end))
end
return v_u_6