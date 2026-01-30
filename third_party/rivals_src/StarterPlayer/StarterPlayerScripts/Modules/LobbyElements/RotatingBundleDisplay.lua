local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.MonetizationLibrary)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers.LobbyController)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_8 = {
    "starter_bundle",
    "medkit_bundle",
    "exogun_bundle",
    "heavyduty_bundle",
    "classic_bundle",
    "standardweapons_bundle",
    "pixel_bundle",
    "energy_bundle",
    "rpg_bundle"
}
local v_u_9 = v3.LocalPlayer.PlayerScripts.Assets:WaitForChild("PhysicalBundles")
local v_u_10 = setmetatable({}, v_u_7)
v_u_10.__index = v_u_10
function v_u_10._new(...)
    local v11 = v_u_7.new(...)
    local v12 = v_u_10
    local v13 = setmetatable(v11, v12)
    v13._bundles_pool = {}
    v13._current_index = 1
    v13._bundle_display_model = nil
    v13._bundle_display_pivot = nil
    v13:_Init()
    return v13
end
function v_u_10.SetIndex(p14, p15)
    p14._current_index = #p14._bundles_pool == 0 and 1 or (p15 - 1) % #p14._bundles_pool + 1
    p14._bundle_display_pivot = p14._bundle_display_pivot or (v_u_2:GetTagged("LobbyBundleDisplay")[1] and v_u_2:GetTagged("LobbyBundleDisplay")[1].CFrame or nil)
    if p14._bundle_display_model then
        p14._bundle_display_model:Destroy()
        p14._bundle_display_model = nil
    end
    local v16 = p14._bundles_pool[p14._current_index] or "keybundle_3"
    p14._bundle_display_model = v_u_9:WaitForChild(v16):Clone()
    p14._bundle_display_model.PrimaryPart = p14._bundle_display_model.Prompt
    local v17 = p14._bundle_display_model.Prompt
    v17.CFrame = v17.CFrame + Vector3.new(0, 2, 0)
    for _, v18 in pairs(p14._bundle_display_model:GetDescendants()) do
        if v18:IsA("BasePart") then
            v18.Anchored = true
            v18.CanCollide = false
            v18.CanQuery = false
            v18.CanTouch = false
            v18.Massless = true
        end
    end
    p14._bundle_display_model.Parent = workspace
    for _, v19 in pairs(p14._bundle_display_model:GetDescendants()) do
        if v19:IsA("BasePart") then
            v19.CanCollide = false
            v19.CanTouch = false
            v19.CanQuery = false
            v19.Anchored = true
        end
    end
    local v20 = Instance.new("ProximityPrompt")
    v20.ActionText = "View"
    v20.ClickablePrompt = true
    v20.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
    v20.GamepadKeyCode = Enum.KeyCode.ButtonX
    v20.HoldDuration = 0
    v20.MaxActivationDistance = 16
    v20.KeyboardKeyCode = Enum.KeyCode.Q
    v20.ObjectText = "Special Offer"
    v20.RequiresLineOfSight = false
    v20.Style = Enum.ProximityPromptStyle.Custom
    v20:AddTag("LobbyOpenPagePrompt")
    v20:SetAttribute("PageName", "Shop")
    v20:SetAttribute("ShopViewBundleName", v16)
    v20.Parent = p14._bundle_display_model.Prompt
end
function v_u_10.Update(p21, _)
    if p21._bundle_display_model then
        local v22 = tick() * 0.25
        local v23 = math.sin(v22) ^ 30 * 1
        local v24 = tick() * 0.1 % 6.283185307179586
        local v25 = CFrame.new(0, v23, 0) * CFrame.Angles(0, v24, 0)
        p21._bundle_display_model:PivotTo((p21._bundle_display_pivot or CFrame.identity) * v25)
    end
end
function v_u_10._UpdatePool(p26)
    for v27 in pairs(v_u_5:Get("GamepassBundlesClaimed")) do
        local v28 = v_u_4.Gamepasses[v27]
        if v28 and v28.BundleName then
            local v29 = table.find(p26._bundles_pool, v28.BundleName)
            if v29 then
                table.remove(p26._bundles_pool, v29)
            end
        end
    end
    p26:SetIndex(1)
end
function v_u_10._Setup(p30)
    for _, v31 in pairs(v_u_8) do
        local v32 = p30._bundles_pool
        local v33 = math.random(1, #p30._bundles_pool + 1)
        table.insert(v32, v33, v31)
    end
end
function v_u_10._Init(p_u_34)
    v_u_6.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        if not v_u_6.LocalFighter:Get("IsInDuel") then
            p_u_34:SetIndex(p_u_34._current_index + 1)
        end
    end)
    v_u_5:GetDataChangedSignal("GamepassBundlesClaimed"):Connect(function()
        p_u_34:_UpdatePool()
    end)
    v_u_5:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_34:_UpdatePool()
    end)
    p_u_34:_Setup()
    p_u_34:_UpdatePool()
    p_u_34:SetIndex(1)
end
return v_u_10._new()