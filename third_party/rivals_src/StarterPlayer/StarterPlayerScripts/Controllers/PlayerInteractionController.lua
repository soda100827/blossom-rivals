local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("MatchmadeOverlay"))
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("MobileButtons"))
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Teleporting"))
require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("PlayerList"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_11 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_12 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PlayerInteractionGui")
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new()
    local v14 = v_u_13
    local v15 = setmetatable({}, v14)
    v15.LocalFighter = nil
    v15._connections = {}
    v15._changed_connections = {}
    v15._bbg = v_u_12:Clone()
    v15._highlight = nil
    v15._next_whitelist = 0
    v15._whitelist = {}
    v15._disabled_until = 0
    v15._hash = 0
    v15:_Init()
    return v15
end
function v_u_13._SetAdornee(p16, p17)
    p16._bbg.Adornee = p17 or nil
    local v18 = p16._bbg
    local v19
    if p17 then
        v19 = v_u_3.LocalPlayer.PlayerGui
    else
        v19 = nil
    end
    v18.Parent = v19
end
function v_u_13._GetWhitelist(p20)
    if tick() > p20._next_whitelist then
        p20._next_whitelist = tick() + 3
        p20._whitelist = v_u_6:GetFighterModels()
    end
    return p20._whitelist
end
function v_u_13._ClearChangedConnections(p21)
    for _, v22 in pairs(p21._changed_connections) do
        v22:Disconnect()
    end
    p21._changed_connections = {}
end
function v_u_13._Verify(p_u_23)
    for _, v24 in pairs(p_u_23._connections) do
        v24:Disconnect()
    end
    p_u_23._connections = {}
    if p_u_23._highlight then
        p_u_23._highlight:Destroy()
        p_u_23._highlight = nil
    end
    p_u_23:_SetAdornee(nil)
    p_u_23:_ClearChangedConnections()
    p_u_23._hash = p_u_23._hash + 1
    local v_u_25 = p_u_23._hash
    if p_u_23.LocalFighter and not (p_u_23.LocalFighter:Get("IsInDuel") or (p_u_23.LocalFighter:Get("IsInShootingRange") or p_u_23.LocalFighter.Entity and p_u_23.LocalFighter.Entity:Get("IsGrabbingSnowball"))) and tick() >= p_u_23._disabled_until then
        if not (v_u_10.PageSystem.CurrentPage or (v_u_5.CurrentDuelSubject or (v_u_8.EditorEnabled or (v_u_9.Enabled or v_u_7:IsVisible())))) then
            p_u_23._highlight = Instance.new("Highlight")
            p_u_23._highlight.Name = "PlayerInteraction"
            p_u_23._highlight.FillColor = Color3.fromRGB(255, 255, 255)
            p_u_23._highlight.Parent = v_u_3.LocalPlayer.PlayerGui
            local function v_u_30()
                local v26 = v_u_11:GetMouseLocation()
                local v27 = workspace.CurrentCamera:ScreenPointToRay(v26.X, v26.Y, 0)
                local v28 = v_u_4:GetCharacterModel(v_u_4:Raycast(v27.Origin, v27.Origin + v27.Direction * 100, 100, p_u_23:_GetWhitelist(), Enum.RaycastFilterType.Include).Instance)
                local v29
                if v28 then
                    v29 = v_u_3:GetPlayerFromCharacter(v28)
                else
                    v29 = v28
                end
                if not v28 or (not v28:FindFirstChild("HumanoidRootPart") or (workspace.CurrentCamera.CFrame.Position - v28.HumanoidRootPart.Position).Magnitude >= 5) then
                    return v29, v28
                end
            end
            local v_u_31 = nil
            local v_u_32 = 0
            if p_u_23._hash == v_u_25 then
                local v33 = tick() - v_u_32 < 0.25
                p_u_23._highlight.FillTransparency = v33 and 0.5 or 0.75
                p_u_23._highlight.OutlineTransparency = v33 and 0 or 0.5
                p_u_23._bbg.Container.Title.Text = v33 and "Tap again to view profile" or "Double tap to view profile"
            end
            local v34 = p_u_23._connections
            local v35 = v_u_2.InputBegan
            local function v47(p_u_36)
                if p_u_36.UserInputType == Enum.UserInputType.MouseButton1 or (p_u_36.UserInputType == Enum.UserInputType.Touch or p_u_36.KeyCode == Enum.KeyCode.ButtonX) then
                    if tick() - v_u_32 > 0.25 then
                        v_u_31 = nil
                    end
                    v_u_32 = tick()
                    if p_u_23._hash == v_u_25 then
                        local v37 = tick() - v_u_32 < 0.25
                        p_u_23._highlight.FillTransparency = v37 and 0.5 or 0.75
                        p_u_23._highlight.OutlineTransparency = v37 and 0 or 0.5
                        p_u_23._bbg.Container.Title.Text = v37 and "Tap again to view profile" or "Double tap to view profile"
                    end
                    task.delay(0.25, function()
                        if p_u_23._hash == v_u_25 then
                            local v38 = tick() - v_u_32 < 0.25
                            p_u_23._highlight.FillTransparency = v38 and 0.5 or 0.75
                            p_u_23._highlight.OutlineTransparency = v38 and 0 or 0.5
                            p_u_23._bbg.Container.Title.Text = v38 and "Tap again to view profile" or "Double tap to view profile"
                        end
                    end)
                    if p_u_36.UserInputType == Enum.UserInputType.Touch then
                        p_u_23:_ClearChangedConnections()
                        local v39 = p_u_23._changed_connections
                        local v40 = p_u_36:GetPropertyChangedSignal("Position")
                        local function v43()
                            local _, v41 = v_u_30()
                            p_u_23._highlight.Adornee = v41
                            local v42 = p_u_23
                            if v41 then
                                v41 = v41:FindFirstChild("HumanoidRootPart")
                            end
                            v42:_SetAdornee(v41)
                        end
                        table.insert(v39, v40:Connect(v43))
                        local v44 = p_u_23._changed_connections
                        local v45 = p_u_36:GetPropertyChangedSignal("UserInputState")
                        local function v46()
                            if p_u_36.UserInputState == Enum.UserInputState.End then
                                p_u_23:_ClearChangedConnections()
                            end
                        end
                        table.insert(v44, v45:Connect(v46))
                    end
                end
            end
            table.insert(v34, v35:Connect(v47))
            local v48 = p_u_23._connections
            local v49 = v_u_2.InputEnded
            local function v52(p50)
                if p50.UserInputType == Enum.UserInputType.MouseButton1 or (p50.UserInputType == Enum.UserInputType.Touch or p50.KeyCode == Enum.KeyCode.ButtonX) then
                    if tick() - v_u_32 > 0.25 then
                        return
                    end
                    local v51 = v_u_30()
                    if not v51 then
                        return
                    end
                    if v_u_31 == v51 then
                        v_u_10.PageSystem:OpenPage("ViewProfile")
                        v_u_10.PageSystem:WaitForPage("ViewProfile"):Fetch(v51)
                        return
                    end
                    v_u_31 = v51
                end
            end
            table.insert(v48, v49:Connect(v52))
            local v53 = p_u_23._connections
            local v54 = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")
            table.insert(v53, v54:Connect(function()
                local _, v55 = v_u_30()
                p_u_23._highlight.Adornee = v55
                local v56 = p_u_23
                if v55 then
                    v55 = v55:FindFirstChild("HumanoidRootPart")
                end
                v56:_SetAdornee(v55)
            end))
            local v57 = p_u_23._connections
            local v58 = v_u_2.InputChanged
            table.insert(v57, v58:Connect(function(p59)
                if p59.UserInputType == Enum.UserInputType.MouseMovement then
                    local _, v60 = v_u_30()
                    p_u_23._highlight.Adornee = v60
                    local v61 = p_u_23
                    if v60 then
                        v60 = v60:FindFirstChild("HumanoidRootPart")
                    end
                    v61:_SetAdornee(v60)
                end
            end))
        end
    else
        return
    end
end
function v_u_13._HookLocalFighter(p_u_62)
    p_u_62.LocalFighter = v_u_6:WaitForLocalFighter()
    p_u_62.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_62:_Verify()
    end)
    p_u_62.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_62:_Verify()
    end)
    local function v64(p63)
        p63:GetDataChangedSignal("IsGrabbingSnowball"):Connect(function()
            p_u_62._disabled_until = tick() + 2
            task.delay(2, p_u_62._Verify, p_u_62)
            p_u_62:_Verify()
        end)
        p_u_62:_Verify()
    end
    p_u_62.LocalFighter.EntityAdded:Connect(v64)
    if p_u_62.LocalFighter.Entity then
        task.defer(v64, p_u_62.LocalFighter.Entity)
    end
    p_u_62:_Verify()
end
function v_u_13._Setup(p65)
    p65._bbg.Name = "PlayerInteraction"
    p65._bbg.Parent = v_u_3.LocalPlayer.PlayerGui
end
function v_u_13._Init(p_u_66)
    v_u_10.PageSystem.PageOpened:Connect(function()
        p_u_66:_Verify()
    end)
    v_u_10.PageSystem.PageClosed:Connect(function()
        p_u_66:_Verify()
    end)
    v_u_5.DuelSubjectChanged:Connect(function()
        p_u_66:_Verify()
    end)
    v_u_9.EnabledChanged:Connect(function()
        p_u_66:_Verify()
    end)
    v_u_8.EditorEnabledChanged:Connect(function()
        p_u_66:_Verify()
    end)
    v_u_7.VisibilityChanged:Connect(function()
        p_u_66:_Verify()
    end)
    p_u_66:_Setup()
    task.defer(p_u_66._Verify, p_u_66)
    task.spawn(p_u_66._HookLocalFighter, p_u_66)
end
return v_u_13._new()