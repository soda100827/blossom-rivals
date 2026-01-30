local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.StatisticsLibrary)
local v_u_5 = require(v1.Modules.ShopLibrary)
local v_u_6 = require(v1.Modules.ItemLibrary)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_11 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentDetailsDescription")
local v_u_12 = { "Lookin\' good!" }
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13.new(p14)
    local v15 = v_u_13
    local v16 = setmetatable({}, v15)
    v16.Right = p14
    v16.Frame = v16.Right.Container:WaitForChild("Details")
    v16.Container = v16.Frame:WaitForChild("Container")
    v16.Title = v16.Container:WaitForChild("Title")
    v16.Icon = v16.Container:WaitForChild("Icon")
    v16.Headshot = v16.Container:WaitForChild("Headshot")
    v16.DescriptionsFrame = v16.Container:WaitForChild("Descriptions")
    v16.DescriptionsLayout = v16.DescriptionsFrame:WaitForChild("Layout")
    v16.FavoritedFrame = v16.Container:WaitForChild("Favorited")
    v16.FavoritedButton = v16.FavoritedFrame:WaitForChild("Button")
    v16.FavoritedFilled = v16.FavoritedButton:WaitForChild("Filled")
    v16.FavoritedEmpty = v16.FavoritedButton:WaitForChild("Empty")
    v16._cleanup = {}
    v16:_Init()
    return v16
end
function v_u_13.OnStateChanged(p17)
    p17:_Generate()
end
function v_u_13._Generate(p18)
    for _, v19 in pairs(p18._cleanup) do
        v_u_9:ClearStatusElements(v19)
        v19:Destroy()
    end
    p18._cleanup = {}
    v_u_9:ClearStatusElements(p18.Title)
    local v20 = p18.Right.Interface.Equipment:IsCareerPageOpen()
    local v21 = p18.Right.Interface.Equipment:GetSelectedWeapon()
    local _, _, v22, _ = v_u_5:GetWeaponKeyPriceInfo(v21, v_u_8:Get("UnlockTokens"), v_u_8:Get("FreeWeaponUnlockCheck"))
    local v23 = v_u_5:GetTimeUntilWeaponRelease(v21)
    local v24 = not v22
    if v24 then
        v24 = v23 > 0
    end
    local v25
    if v20 then
        v25 = v20
    elseif v21 then
        v25 = not v24
    else
        v25 = v21
    end
    p18.Frame.Visible = v25
    if v25 then
        local v26
        if v21 then
            v26 = v_u_8:GetWeaponData(v21) ~= nil
        else
            v26 = v21
        end
        local v27
        if v21 then
            v27 = v_u_8:GetFavoritedWeapons()[v21]
        else
            v27 = v21
        end
        p18.FavoritedFrame.Visible = v26
        p18.FavoritedFilled.Visible = v27
        p18.FavoritedEmpty.Visible = not v27
        if v20 then
            p18.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, v_u_2.LocalPlayer.UserId)
            p18.Icon.Image = ""
            p18.Title.AutoLocalize = false
            p18.Title.Text = v_u_7:GetName(v_u_2.LocalPlayer)
            if v_u_2.LocalPlayer.Name ~= v_u_2.LocalPlayer.DisplayName then
                local v28 = "\226\128\162 Also known as @" .. v_u_2.LocalPlayer.Name
                p18:_CreateDescription(v28, #v28 > 34 and 2 or 1)
            end
            p18:_CreateDescription("\226\128\162 " .. v_u_12[math.random(#v_u_12)], 1)
        elseif v21 then
            local v29 = v_u_6.Items[v21]
            local v30 = v_u_4.Items[v21]
            local v31 = v_u_8:GetWeaponData(v21)
            p18.Headshot.Image = ""
            p18.Icon.Image = v31 and v_u_6:GetViewModelImageFromWeaponData(v31) or ""
            p18.Title.Text = v21
            p18.Title.AutoLocalize = true
            v_u_9:ApplyItemStatusToText(p18.Title, v29.Status)
            v_u_9:ApplyItemStatusToText(p18:_CreateDescription("\226\128\162 " .. v29.Status .. " " .. v29.Class, 1), v29.Status)
            for _, v32 in pairs(v30 and v30.Descriptions or {}) do
                local v33, v34 = table.unpack(v32)
                p18:_CreateDescription("\226\128\162 " .. v34, v33)
            end
        end
    else
        return
    end
end
function v_u_13._CreateDescription(p35, p36, p37)
    local v38 = v_u_11:Clone()
    v38.Text = p36
    v38.Size = UDim2.new(0.75, 0, 0.05 * p37, 0)
    v38.LayoutOrder = #p35._cleanup
    v38.Parent = p35.DescriptionsFrame
    local v39 = p35._cleanup
    table.insert(v39, v38)
    return v38
end
function v_u_13._Update(p40)
    p40.Frame.Size = UDim2.new(1, 0, 0, (p40.DescriptionsFrame.AbsolutePosition.Y - p40.Frame.AbsolutePosition.Y) * 1.25 + p40.DescriptionsLayout.AbsoluteContentSize.Y)
end
function v_u_13._Init(p_u_41)
    p_u_41.DescriptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_41:_Update()
    end)
    p_u_41.FavoritedButton.MouseButton1Click:Connect(function()
        p_u_41.Right.Interface.Equipment:FavoriteWeapon()
    end)
    v_u_8:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_41:_Generate()
    end)
    p_u_41:_Update()
    v_u_10:Add(p_u_41.FavoritedButton)
end
return v_u_13