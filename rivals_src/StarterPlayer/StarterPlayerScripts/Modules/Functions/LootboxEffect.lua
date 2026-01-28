local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v_u_6 = require(v1.Modules.BetterDebris)
local v_u_7 = require(v1.Modules.ItemLibrary)
local v_u_8 = require(v1.Modules.Utility)
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_10 = v_u_3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("LootboxCollectParticles"):WaitForChild("Attachment")
local v_u_11 = v_u_3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("UnboxEffect")
local v_u_12 = v_u_3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Lootboxes")
local v_u_13 = {
    ["Common"] = { "rbxassetid://18182950485", 0.5 },
    ["Rare"] = { "rbxassetid://18182950836", 0.375 },
    ["Legendary"] = { "rbxassetid://18182950182", 0.375 },
    ["Standard"] = { "rbxassetid://18182950485", 0.5 },
    ["Prime"] = { "rbxassetid://18182950182", 0.375 }
}
local v_u_14 = 0
return function(p15, p_u_16, p17, p18, p_u_19, p20, _)
    if p18 and p18 > 0 then
        wait(p18)
    end
    v_u_14 = v_u_14 + 1
    local v21 = v_u_14 * 3.141592653589793 * 2 / 8
    local v22 = (v_u_14 - 1) / 8
    local v23 = v21 + math.floor(v22) * 3.141592653589793 / 8
    local v24 = v_u_14 - 1
    local v25 = math.floor(v24) * 5
    local v26 = v23 + math.rad(v25)
    local v27 = (v_u_14 % 64 - 1) / 8
    local v28 = math.floor(v27) * 1
    local v_u_29 = v_u_12[p_u_16]:Clone()
    v_u_29.Parent = workspace
    v_u_6:AddItem(v_u_29, 15)
    v_u_8:CreateSound("rbxassetid://18183233381", 0.5, 1 + 0.25 * math.random(), v_u_29.HumanoidRootPart, true)
    local v_u_30 = CFrame.new(p15) * CFrame.Angles(0, v26, 0)
    local v_u_31 = CFrame.new(p15) * CFrame.Angles(0, v26, 0) * CFrame.new(0, -3, v28 + 7)
    v_u_8:RenderstepForLoop(0, 100, 2, function(p32)
        local v33 = p32 / 100
        local v34 = 1 - (1 - v33) ^ 5
        local v35 = 9.42477796076938 * (v33 + 0.25)
        local v36 = math.cos(v35) * (v33 - 1) / 0.707
        local v37 = math.abs(v36)
        local v38 = v_u_30:Lerp(v_u_31, v34)
        v_u_29:PivotTo(CFrame.new(v38.X, v_u_31.Y + (v_u_30.Y - v_u_31.Y) * v37, v38.Z) * v38.Rotation)
    end)
    v_u_6:AddItem(v_u_29, v_u_29.Animation:GetAttribute("Duration"))
    task.spawn(v_u_4.IS_STUDIO and task.defer or pcall, function()
        v_u_29.AnimationController:LoadAnimation(v_u_29.Animation):Play()
        require(script[v_u_5.Rewards[p_u_16].SoundProfile])(v_u_29)
    end)
    wait(v_u_29.Animation:GetAttribute("RevealDelay"))
    local v_u_39 = v_u_11:Clone()
    v_u_39.CFrame = v_u_31 + Vector3.new(0, 8, 0)
    v_u_39.Parent = workspace
    v_u_6:AddItem(v_u_39, 15)
    local v40 = v_u_39.BillboardGui
    v40.Adornee = v_u_39
    v40.Parent = v_u_3.LocalPlayer.PlayerGui
    v_u_6:AddItem(v40, 15)
    for _, v41 in pairs(p17) do
        local v42 = v_u_9.new(v41.RewardData, true)
        v42:SetInteractable(false)
        v42:SetParent(v40.Container)
    end
    v40.Container.Size = UDim2.new(0.25, 0, 0.25, 0)
    v40.Container.Position = UDim2.new(0.5, 0, 0.75, 0)
    v40.Container:TweenSizeAndPosition(UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.5, true)
    local v43 = p17[1]
    if v43 then
        v43 = v_u_5.Cosmetics[p17[1].RewardData.Name]
    end
    local v44 = p17[1]
    if v44 then
        v44 = v_u_5.Rewards[p17[1].RewardData.Name]
    end
    local v45 = nil
    local v46 = nil
    if v43 then
        v45 = v43.Rarity
        v46 = v_u_5.Rarities[v43.Rarity].Color
    elseif v44 then
        local v47 = v_u_7.Items[v44.Name]
        v45 = v47.Status
        v46 = v_u_7.Statuses[v47.Status].Color
    end
    if v45 and v46 then
        v_u_39.Trail.Color = ColorSequence.new(v46)
        local v48 = v_u_13[v45]
        if v48 then
            v_u_8:CreateSound(v48[1], v48[2] * (p20 == v_u_3.LocalPlayer and 1 or 0.5), 1, v_u_39, true)
        end
    end
    local v49 = v40.Container
    wait(4)
    if v49:IsDescendantOf(workspace) then
        v49:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 1, true)
    end
    if p_u_19 then
        local v_u_50 = v_u_39.CFrame
        v_u_8:RenderstepForLoop(0, 100, 1.9, function(p51)
            local v52 = v_u_2:GetValue(p51 / 100, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            v_u_39.CFrame = v_u_50:Lerp(p_u_19.CFrame, v52)
        end)
        local v53 = v_u_10:Clone()
        v53.Parent = p_u_19
        for _, v54 in pairs(v53:GetChildren()) do
            v54:SetAttribute("IgnoreVisibilityCheck", true)
            v54.Color = v46 and ColorSequence.new(v46) or v54.Color
        end
        v_u_8:PlayParticles(v53)
        v_u_8:CreateSound("rbxassetid://109954155299965", 0.75, 1 + 0.25 * math.random(), p_u_19, true)
        v_u_39:Destroy()
        v40:Destroy()
    end
end