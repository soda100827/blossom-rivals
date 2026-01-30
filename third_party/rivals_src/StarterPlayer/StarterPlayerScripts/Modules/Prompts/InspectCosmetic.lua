local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.CosmeticLibrary)
local v_u_5 = require(v_u_1.Modules.ItemLibrary)
local v_u_6 = require(v_u_1.Modules.ShopLibrary)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_11 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("UnlockedCosmeticWeaponSlot")
local v_u_12 = setmetatable({}, v_u_10)
v_u_12.__index = v_u_12
function v_u_12.new(p13)
    local v14 = v_u_10.new(script.Name)
    local v15 = v_u_12
    local v16 = setmetatable(v14, v15)
    v16.CloseButton = v16.PromptFrame:WaitForChild("Close")
    v16.TitleText = v16.PromptFrame:WaitForChild("Title")
    v16.List = v16.PromptFrame:WaitForChild("List")
    v16.Container = v16.List:WaitForChild("Container")
    v16.Layout = v16.Container:WaitForChild("Layout")
    v16._cosmetic_name = p13
    v16._cosmetic_info = v_u_4.Cosmetics[v16._cosmetic_name]
    v16._slots = {}
    v16:_Init()
    return v16
end
function v_u_12._IsEquipped(p17, p18)
    local v19 = v_u_7:GetWeaponData(p18)
    local v20 = v19 and v19[p17._cosmetic_info.Type]
    if v20 then
        v20 = v19[p17._cosmetic_info.Type].Name == p17._cosmetic_name
    end
    return v20
end
function v_u_12._UpdateEquipped(p21)
    for v22, v23 in pairs(p21._slots) do
        v23.Button.Equipped.Visible = p21:_IsEquipped(v22)
    end
end
function v_u_12._Setup(p_u_24)
    p_u_24.TitleText.Text = p_u_24._cosmetic_name .. " " .. p_u_24._cosmetic_info.Type
    local v25 = v_u_7:Get("CosmeticInventory")
    for v26, v_u_27 in pairs(v_u_6:GetReleasedOwnableWeapons(v_u_3.WEAPON_EARLY_ACCESS_TIME_OFFSET, v_u_6.OwnableWeaponsAlphabetized)) do
        local v28 = v_u_5.Items[v_u_27]
        if p_u_24._cosmetic_info.Type ~= "Finisher" or v28.CanEliminate then
            local v29 = v_u_7:GetWeaponData(v_u_27)
            local v30 = v_u_4:OwnsCosmetic(v25, p_u_24._cosmetic_name, v_u_27)
            local v_u_31 = v_u_11:Clone()
            v_u_31.LayoutOrder = v26 + (v30 and 0 or 999999)
            v_u_31.Button.Icon.Image = v28.Image
            v_u_31.Button.Icon.ImageColor3 = not v29 and Color3.fromRGB(32, 32, 32) or (not v30 and Color3.fromRGB(32, 32, 32) or Color3.fromRGB(255, 255, 255))
            v_u_31.Button.Title.Visible = v29 ~= nil
            v_u_31.Button.Title.Text = v_u_27
            v_u_31.Button.Title.TextTransparency = v30 and 0 or 0.875
            v_u_31.Button.Locked.Visible = not v29
            v_u_31.ZIndex = v29 and (v30 and 2 or 1) or 0
            v_u_31.Parent = p_u_24.Container
            p_u_24._slots[v_u_27] = v_u_31
            v_u_9:Add(v_u_31.Button)
            v_u_8:ApplyItemStatusToText(v_u_31.Button.Title, v_u_5.Items[v_u_27].Status)
            v_u_31.Button.MouseButton1Click:Connect(function()
                local v32 = v_u_1.Remotes.Data.EquipCosmetic
                local v33 = v_u_27
                local v34 = p_u_24._cosmetic_info.Type
                local v35
                if p_u_24:_IsEquipped(v_u_27) then
                    v35 = nil
                else
                    v35 = p_u_24._cosmetic_name
                end
                v32:FireServer(v33, v34, v35)
                v_u_7:SilenceCosmeticNotification(p_u_24._cosmetic_name, v_u_27)
            end)
            local v_u_36 = false
            local function v38()
                if not v_u_36 then
                    v_u_36 = true
                    local v37 = v_u_31
                    v37.ZIndex = v37.ZIndex + 10
                end
            end
            v_u_31.Button.MouseEnter:Connect(v38)
            local function v40()
                if v_u_36 then
                    v_u_36 = false
                    local v39 = v_u_31
                    v39.ZIndex = v39.ZIndex - 10
                end
            end
            v_u_31.Button.MouseLeave:Connect(v40)
        end
    end
end
function v_u_12._Init(p_u_41)
    p_u_41.CloseButton.MouseButton1Click:Connect(function()
        p_u_41:CloseRequest()
    end)
    p_u_41.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_41.List.CanvasSize = UDim2.new(0, 0, 0, p_u_41.Layout.AbsoluteContentSize.Y)
    end)
    local v42 = p_u_41._connections
    local v43 = v_u_7:GetDataChangedSignal("WeaponInventory")
    table.insert(v42, v43:Connect(function()
        p_u_41:_UpdateEquipped()
    end))
    p_u_41:_Setup()
    p_u_41:_UpdateEquipped()
    v_u_9:Add(p_u_41.CloseButton)
end
return v_u_12