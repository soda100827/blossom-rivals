local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_10 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CosmeticSlotEmpty")
local v_u_11 = setmetatable({}, v_u_9)
v_u_11.__index = v_u_11
function v_u_11._new()
    local v12 = v_u_9.new(script.Name)
    local v13 = v_u_11
    local v14 = setmetatable(v12, v13)
    v14.CloseButton = v14.PageFrame:WaitForChild("Close")
    v14.PromptsFrame = v14.PageFrame:WaitForChild("Prompts")
    v14.List = v14.PageFrame:WaitForChild("List")
    v14.Container = v14.List:WaitForChild("Container")
    v14.Layout = v14.Container:WaitForChild("Layout")
    v14.SlotsFrame = v14.Container:WaitForChild("Slots")
    v14.SlotsContainer = v14.SlotsFrame:WaitForChild("Container")
    v14.SlotsLayout = v14.SlotsContainer:WaitForChild("Layout")
    v14.PromptSystem = v_u_7.new(v14.PromptsFrame)
    v14._slots = {}
    v14._generation_queued = false
    v14:_Init()
    return v14
end
function v_u_11.Open(p15, ...)
    v_u_9.Open(p15, ...)
    p15:_Generate()
end
function v_u_11.Close(p16, ...)
    v_u_9.Close(p16, ...)
    p16:_Generate()
end
function v_u_11._Generate(p_u_17)
    for _, v18 in pairs(p_u_17._slots) do
        v18:Destroy()
    end
    p_u_17._slots = {}
    if p_u_17:IsOpen() then
        local v19 = v_u_5:Get("UnclaimedRewards")
        if #v19 == 0 then
            p_u_17.Closed:Fire()
        else
            local v20 = table.clone(v19)
            table.sort(v20, function(p21, p22)
                local v23 = v_u_3.Rewards[p21.Name] ~= nil
                local v24 = v_u_3.Rewards[p22.Name] ~= nil
                if v23 == v24 then
                    local v25 = not v23
                    if v25 then
                        v25 = v_u_3.Rarities[v_u_3.Cosmetics[p21.Name].Rarity].Value
                    end
                    local v26 = not v24
                    if v26 then
                        v26 = v_u_3.Rarities[v_u_3.Cosmetics[p22.Name].Rarity].Value
                    end
                    if v25 == v26 then
                        local v27 = not v23
                        if v27 then
                            v27 = v_u_3.Types[v_u_3.Cosmetics[p21.Name].Type].Value
                        end
                        local v28 = not v24
                        if v28 then
                            v28 = v_u_3.Types[v_u_3.Cosmetics[p22.Name].Type].Value
                        end
                        if v27 == v28 then
                            local v29 = p21.Quantity or 1
                            local v30 = p22.Quantity or 1
                            local v31
                            if v29 == v30 then
                                v31 = nil
                            else
                                v31 = v30 < v29
                            end
                            local v32
                            if p21.Name == p22.Name then
                                v32 = nil
                            else
                                v32 = v_u_4:StringLessThan(p21.Name, p22.Name)
                            end
                            if v23 then
                                v23 = v_u_3.Rewards[p21.Name].Type == "Lootbox"
                            end
                            if v24 then
                                v24 = v_u_3.Rewards[p22.Name].Type == "Lootbox"
                            end
                            if v23 == v24 then
                                if v23 and v24 then
                                    if v32 ~= nil then
                                        return v32
                                    end
                                    if v31 ~= nil then
                                        return v31
                                    end
                                else
                                    if v31 ~= nil then
                                        return v31
                                    end
                                    if v32 ~= nil then
                                        return v32
                                    end
                                end
                                local v33 = p21.Weapon
                                local v34 = p22.Weapon
                                if v33 == v34 then
                                    return false
                                elseif v33 and not v34 then
                                    return false
                                else
                                    return not v33 and v34 and true or v_u_4:StringLessThan(p21.Weapon, p22.Weapon)
                                end
                            else
                                return v24
                            end
                        else
                            return v28 < v27
                        end
                    else
                        return v26 < v25
                    end
                else
                    return v24
                end
            end)
            for v35, v36 in pairs(v20) do
                local v_u_37 = table.find(v19, v36)
                local v38 = v_u_3.Rewards[v36.Name]
                if v38 then
                    local _ = v38.Type == "Lootbox"
                end
                local v39 = v_u_8.new(v36)
                v39.Frame.LayoutOrder = v35
                v39:SetParent(p_u_17.SlotsContainer)
                local v40 = p_u_17._slots
                table.insert(v40, v39)
                v39:OnClick(function()
                    p_u_17.PromptSystem:Open("InspectBackpackReward", v_u_37)
                end)
            end
            for _ = 1, 12 - ((#p_u_17._slots - 1) % 6 + 1) do
                local v41 = v_u_10:Clone()
                v41.Background.BackgroundTransparency = 0.5
                v41.LayoutOrder = 9999999
                v41.Parent = p_u_17.SlotsContainer
                local v42 = p_u_17._slots
                table.insert(v42, v41)
            end
        end
    else
        return
    end
end
function v_u_11._QueueGenerate(p_u_43)
    if not p_u_43._generation_queued then
        p_u_43._generation_queued = true
        task.defer(function()
            p_u_43._generation_queued = false
            p_u_43:_Generate()
        end)
    end
end
function v_u_11._Init(p_u_44)
    p_u_44.CloseButton.MouseButton1Click:Connect(function()
        p_u_44:CloseRequest()
    end)
    p_u_44.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_44.List.CanvasSize = UDim2.new(0, 0, 0, p_u_44.Layout.AbsoluteContentSize.Y)
        p_u_44.List.Active = p_u_44.Layout.AbsoluteContentSize.Y >= p_u_44.List.AbsoluteSize.Y
    end)
    p_u_44.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_44.SlotsFrame.Size = UDim2.new(1, 0, 0, p_u_44.SlotsLayout.AbsoluteContentSize.Y)
    end)
    p_u_44.PromptSystem.PromptAdded:Connect(function(p45)
        if p45.ClosePage then
            p45.ClosePage:Connect(function()
                p_u_44.Closed:Fire()
            end)
        end
    end)
    v_u_5:GetDataChangedSignal("UnclaimedRewards"):Connect(function()
        p_u_44:_QueueGenerate()
    end)
    p_u_44:_Generate()
    v_u_6:Add(p_u_44.CloseButton)
end
return v_u_11._new()