local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("HttpService")
local v_u_3 = game:GetService("Players")
require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.BetterDebris)
local v_u_5 = require(v_u_1.Modules.Signal)
require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MechanicsController"))
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController"))
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("GameComponents"):WaitForChild("OutOfBoundsParts"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_12 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("TableViewer"))
local v_u_13 = require(script:WaitForChild("DebugState"))
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14._new()
    local v15 = v_u_14
    local v16 = setmetatable({}, v15)
    v16._are_hitboxes_visible = false
    v16._are_map_barriers_visible = false
    v16._are_map_barriers_visible_changed_internal = v_u_5.new()
    v16:_Init()
    return v16
end
function v_u_14.Command(p17, p18, p19)
    if p17[p18] then
        p17[p18](p17, p19)
    else
        p17:_Command(p18, p19)
    end
end
function v_u_14.SetHandicapsEnabled(_, p20)
    v_u_13:SetReplicate("AreHandicapsEnabled", p20)
end
function v_u_14.DisableTransparentHats(_, p21)
    v_u_13:SetReplicate("DisableTransparentHats", p21)
end
function v_u_14.SpectateNilDuel(_)
    v_u_7:SpectateDuelRequest(nil)
end
function v_u_14.ShowClientEnvironment(_)
    v_u_12.new(require(v_u_3.LocalPlayer.PlayerScripts.Client)).ScreenGui.Parent = v_u_3.LocalPlayer.PlayerGui
end
function v_u_14.GetMatchmakingData(p22)
    p22:_JSONDump(p22:_Command("GetMatchmakingData", true))
end
function v_u_14.SetMapBarriersVisible(p23, p24)
    p23._are_map_barriers_visible = p24
    p23._are_map_barriers_visible_changed_internal:Fire()
    p23:_SetupMapBarriersLogic()
end
function v_u_14.SetOOBVisible(_, p25)
    v_u_10:SetVisible(p25)
end
function v_u_14.DisableDeviceAutoSwitch(_, p26)
    v_u_6:DisableVerification(p26)
end
function v_u_14.SetHitboxesVisible(p27, p28)
    p27._are_hitboxes_visible = p28
    p27:_UpdateAllClientFighterCharacterHitboxes()
end
function v_u_14.SendOfflineGiftRewards(_)
    v_u_11.PageSystem:OpenPage("Debug", true)
    v_u_11.PageSystem:WaitForPage("Debug").PromptSystem:Open("SendOfflineGiftRewards")
end
function v_u_14._SetupMapBarriersLogic(p_u_29)
    if not p_u_29._map_barrier_logic_setup then
        p_u_29._map_barrier_logic_setup = true
        v_u_9.ObjectAdded:Connect(function(p_u_30)
            local function v32()
                if p_u_30.Map then
                    for _, v31 in pairs(p_u_30.Map.Model.Barriers:GetDescendants()) do
                        if v31:IsA("BasePart") and not v31:HasTag("OutOfBoundsPart") then
                            v31.Transparency = p_u_29._are_map_barriers_visible and 0.5 or 1
                            v31.Material = Enum.Material.SmoothPlastic
                            v31.Color = v31:HasTag("KillBrick") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(127, 127, 127)
                            v31.CastShadow = false
                        end
                    end
                end
            end
            p_u_29._are_map_barriers_visible_changed_internal:Connect(v32)
            p_u_30.MapAdded:Connect(v32)
            v32()
        end)
        for _, v_u_33 in pairs(v_u_9.Objects) do
            local function v35()
                if v_u_33.Map then
                    for _, v34 in pairs(v_u_33.Map.Model.Barriers:GetDescendants()) do
                        if v34:IsA("BasePart") and not v34:HasTag("OutOfBoundsPart") then
                            v34.Transparency = p_u_29._are_map_barriers_visible and 0.5 or 1
                            v34.Material = Enum.Material.SmoothPlastic
                            v34.Color = v34:HasTag("KillBrick") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(127, 127, 127)
                            v34.CastShadow = false
                        end
                    end
                end
            end
            p_u_29._are_map_barriers_visible_changed_internal:Connect(v35)
            v_u_33.MapAdded:Connect(v35)
            v35()
        end
    end
end
function v_u_14._JSONDump(_, ...)
    local v36 = Instance.new("ScreenGui")
    v36.Parent = v_u_3.LocalPlayer.PlayerGui
    v_u_4:AddItem(v36, 60)
    local v37 = Instance.new("UIListLayout")
    v37.HorizontalAlignment = Enum.HorizontalAlignment.Center
    v37.VerticalAlignment = Enum.VerticalAlignment.Center
    v37.FillDirection = Enum.FillDirection.Horizontal
    v37.Parent = v36
    local v38 = { ... }
    for v39, v40 in pairs(v38) do
        local v41 = #v40 / 199999
        for v42 = 1, math.ceil(v41) do
            local v43 = (v42 - 1) * 199999
            local v44 = 1 + v43
            local v45 = 199999 + v43
            local v46 = string.sub(v40, v44, v45)
            local v47 = Instance.new("TextBox")
            v47.BackgroundColor3 = Color3.fromHSV(v39 / #v38, 0.75, 1)
            v47.Size = UDim2.new(0, 200, 0, 200)
            v47.ClearTextOnFocus = false
            v47.TextEditable = false
            v47.Text = v46
            v47.TextWrapped = true
            v47.Parent = v36
        end
    end
end
function v_u_14._Encode(_, p48)
    local v_u_49 = {}
    local function v_u_54(p50)
        local v51 = {}
        for v52, v53 in pairs(p50) do
            if v_u_49[v53] then
                v51[v52] = "*** cyclic table detected ***"
            elseif typeof(v53) == "table" then
                v_u_49[v53] = true
                v51[v52] = v_u_54(v53)
            else
                v51[v52] = v53
            end
        end
        return v51
    end
    return v_u_2:JSONEncode((v_u_54(p48)))
end
function v_u_14._Command(_, ...)
    return v_u_1.Remotes.Debug.Command:InvokeServer(...)
end
function v_u_14._UpdateClientFighterCharacterHitboxes(p55, p56)
    p56:SetHitboxesVisible(p55._are_hitboxes_visible)
end
function v_u_14._UpdateAllClientFighterCharacterHitboxes(p57)
    for _, v58 in pairs(v_u_8.Objects) do
        if v58.Entity then
            p57:_UpdateClientFighterCharacterHitboxes(v58.Entity)
        end
    end
end
function v_u_14._SetupHitboxesVisualizer(p_u_59)
    local function v62(p60)
        p60.EntityAdded:Connect(function(p61)
            p_u_59:_UpdateClientFighterCharacterHitboxes(p61)
        end)
        if p60.Entity then
            p_u_59:_UpdateClientFighterCharacterHitboxes(p60.Entity)
        end
    end
    v_u_8.ObjectAdded:Connect(v62)
    for _, v63 in pairs(v_u_8.Objects) do
        task.defer(v62, v63)
    end
end
function v_u_14._Init(p64)
    task.defer(p64._SetupHitboxesVisualizer, p64)
end
return v_u_14._new()