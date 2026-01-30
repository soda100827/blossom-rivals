local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.CurrencyLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9, p10)
    local v11 = v_u_8
    local v12 = setmetatable({}, v11)
    v12.ShopEntry = p9
    v12.FirstRewardData = v12.ShopEntry.Rewards[1]
    v12.IsOwned = v_u_3:OwnsCosmetic(v_u_7:Get("CosmeticInventory"), v12.FirstRewardData.Name, v12.FirstRewardData.Weapon)
    local v13 = v12.FirstRewardData.Weapon
    if v13 then
        if v12.FirstRewardData.Weapon == "IsRandom" or v12.FirstRewardData.Weapon == "IsUniversal" then
            v13 = false
        else
            v13 = not v_u_7:GetWeaponData(v12.FirstRewardData.Weapon)
        end
    end
    v12.IsLockedRaw = v13
    v12.IsLocked = p10 or false
    v12:_Init()
    return v12
end
function v_u_8.OnClick(_, _)
    assert(false, "Not implemented")
end
function v_u_8.Destroy(_) end
function v_u_8._SetupBuyButton(p14, p15, p16)
    local v17 = v_u_3.Cosmetics[p14.FirstRewardData.Name]
    local v18 = v_u_4.Info[p14.ShopEntry.MainCurrency]
    local v19 = p14.ShopEntry.Prices[p14.ShopEntry.MainCurrency]
    if p16 then
        p16.Visible = p14.IsOwned
    end
    p15.Visible = not p14.IsOwned
    p15.Limited.Visible = false
    local v20 = p15.Locked
    local v21 = not p15.Limited.Visible
    if v21 then
        v21 = p14.IsLocked
    end
    v20.Visible = v21
    local v22 = p15.Price
    local v23 = not p15.Limited.Visible and (not p14.IsLocked and p14.ShopEntry.MainCurrency)
    if v23 then
        v23 = v19 > 0
    end
    v22.Visible = v23
    local v24 = p15.Free
    local v25 = not p15.Limited.Visible and (not p14.IsLocked and p14.ShopEntry.MainCurrency)
    if v25 then
        v25 = v19 == 0
    end
    v24.Visible = v25
    local v26 = p15.Robux
    local v27 = not (p15.Limited.Visible or p14.IsLocked)
    if v27 then
        v27 = p14.ShopEntry.ProductID
    end
    v26.Visible = v27
    p15.Size = v17 and UDim2.new(0.5, 0, 0.25, 0) or UDim2.new(0.625, 0, 0.3125, 0)
    if p15.Price.Visible then
        p15.Price.Value.Text = v_u_5:PrettyNumber(v19)
        p15.Price.Value.Icon.Image = v18.ImageFlatOutline
        p15.Price.Value.Icon.ImageLabel.Image = v18.ImageFlat
        p15.Price.Background.ImageColor3 = v18.Color
        p15.Price.Background.UIGradient.Color = v18.ColorGradient
    end
    if p14.ShopEntry.ProductID then
        v_u_6:SetRobuxText(p15.Robux.Value, p14.ShopEntry.ProductID, Enum.InfoType.Product)
    end
    for _, v28 in pairs({
        "Locked",
        "Price",
        "Free",
        "Robux",
        "Limited"
    }) do
        if not p15[v28].Visible then
            p15[v28]:Destroy()
        end
    end
    if p15:FindFirstChild("Price") then
        local v_u_29 = p15.Price.Value
        local v_u_30 = v_u_29.Icon
        local function v31()
            v_u_30.Position = UDim2.new(0.5, v_u_29.TextBounds.X / 2, 0.5, 0)
        end
        v_u_29:GetPropertyChangedSignal("TextBounds"):Connect(v31)
        p15.AncestryChanged:Connect(v31)
        v_u_30.Position = UDim2.new(0.5, v_u_29.TextBounds.X / 2, 0.5, 0)
    end
end
function v_u_8._Init(_) end
return v_u_8