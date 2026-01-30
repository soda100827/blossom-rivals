local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.MonetizationLibrary)
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.MonetizationController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.VideoAdRewards)
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_13 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_14 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("StarterBundleGui")
Color3.fromRGB(114, 140, 255)
local v_u_15 = setmetatable({}, v_u_12)
v_u_15.__index = v_u_15
function v_u_15._new(...)
    local v16 = v_u_12.new(...)
    local v17 = v_u_15
    local v18 = setmetatable(v16, v17)
    v18._boards = {}
    v18:_Init()
    return v18
end
function v_u_15._BoardAdded(p19, p20)
    local v21 = {
        ["Gui"] = v_u_14:Clone(),
        ["VideoAdRewards"] = v_u_10.new(9493813237310),
        ["Connections"] = {}
    }
    local v_u_22 = v21.Gui.StarterBundle
    local v_u_23 = v_u_4.Bundles.starter_bundle
    for v24, v25 in pairs(v_u_23.Rewards) do
        local v26 = v_u_5.Rewards[v25.Name]
        if not v26 or (v26.Type ~= "Lootbox" or not v_u_7:ArePaidRandomItemsRestricted()) then
            local v27 = v_u_13.new(v25)
            v27.Frame.LayoutOrder = v24
            v27:SetParent(v_u_22.MainFrame.Rewards)
            v27:OnClick(function()
                if not v_u_9.PageSystem.CurrentPage then
                    v_u_9.PageSystem:OpenPage("Shop")
                    v_u_9.PageSystem:WaitForPage("Shop"):SetPage("Bundles")
                    v_u_9.PageSystem:WaitForPage("Shop"):InspectBundle("starter_bundle")
                end
            end)
        end
    end
    local function v29()
        local v28 = v_u_8:Get("GamepassBundlesClaimed")[v_u_23.GamepassName]
        v_u_22.MainFrame.Button.Visible = not v28
        v_u_22.MainFrame.Owned.Visible = v28
    end
    local v30 = v21.Connections
    local v31 = v_u_8:GetDataChangedSignal("GamepassBundlesClaimed")
    table.insert(v30, v31:Connect(v29))
    local v32 = v_u_8:Get("GamepassBundlesClaimed")[v_u_23.GamepassName]
    v_u_22.MainFrame.Button.Visible = not v32
    v_u_22.MainFrame.Owned.Visible = v32
    v_u_22.MainFrame.Button.MouseButton1Click:Connect(function()
        if not v_u_9.PageSystem.CurrentPage then
            v_u_6:PromptGamePassPurchase(v_u_4.Gamepasses[v_u_23.GamepassName].GamepassID)
        end
    end)
    v_u_6:SetRobuxText(v_u_22.MainFrame.Button.Title, v_u_4.Gamepasses[v_u_23.GamepassName].GamepassID, Enum.InfoType.GamePass)
    v_u_11:Add(v_u_22.MainFrame.Button)
    local v33 = v21.Gui.VideoAdRewards
    v_u_22.Visible = true
    v33.Visible = false
    v21.Gui.Adornee = p20
    v21.Gui.Parent = v_u_3.LocalPlayer.PlayerGui
    p19._boards[p20] = v21
end
function v_u_15._BoardRemoved(p34, p35)
    local v36 = p34._boards[p35]
    if v36 then
        for _, v37 in pairs(v36.Connections) do
            v37:Disconnect()
        end
        v36.Gui:Destroy()
        v36.VideoAdRewards:Destroy()
        p34._boards[p35] = nil
    end
end
function v_u_15._Init(p_u_38)
    v_u_2:GetInstanceAddedSignal("LobbyStarterBundleBoard"):Connect(function(p39)
        p_u_38:_BoardAdded(p39)
    end)
    v_u_2:GetInstanceRemovedSignal("LobbyStarterBundleBoard"):Connect(function(p40)
        p_u_38:_BoardRemoved(p40)
    end)
    for _, v41 in pairs(v_u_2:GetTagged("LobbyStarterBundleBoard")) do
        task.defer(p_u_38._BoardAdded, p_u_38, v41)
    end
end
return v_u_15._new()