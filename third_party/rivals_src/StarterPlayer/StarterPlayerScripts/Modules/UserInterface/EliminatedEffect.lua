local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.DuelLibrary)
local v_u_5 = require(v1.Modules.ItemLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v1.Modules.Signal)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_10 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_11 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController"))
local v_u_12 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_13 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("TeammateSlot"))
local v_u_14 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_15 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EliminatedCard")
local v_u_16 = {}
v_u_16.__index = v_u_16
function v_u_16._new()
    local v17 = v_u_16
    local v18 = setmetatable({}, v17)
    v18.VisibilityChanged = v_u_7.new()
    v18.Frame = v_u_14:GetTo("MainFrame", "EliminatedEffect")
    v18._last_eliminated_card = nil
    v18:_Init()
    return v18
end
function v_u_16.IsVisible(p19)
    return p19._last_eliminated_card ~= nil
end
function v_u_16.Play(p20, p21, p22, p23, p24, p25)
    if p20._last_eliminated_card then
        p20._last_eliminated_card:Destroy()
    end
    v_u_6:CreateSound("rbxassetid://17016581922", 0.75, 1 + 0.1 * math.random(), script, true, 10)
    local v26 = typeof(p21) == "Instance"
    local v27
    if typeof(p21) == "table" then
        v27 = p21
    else
        v27 = false
    end
    local v_u_28 = v_u_15:Clone()
    v_u_28.Frame.Container.Clip.Container.Description.Text = "eliminated " .. (p21 == v_u_2.LocalPlayer and "yourself" or "you") .. (p24 and (" with " .. p24 or "") or "")
    v_u_28.Frame.Container.Clip.Container.Username.Text = (p21 == v_u_2.LocalPlayer or (not v26 or p21.Name == p21.DisplayName)) and "" or ("@" .. p21.Name or "")
    v_u_28.Frame.Container.Clip.Container.Player.Text = p21 == v_u_2.LocalPlayer or v26 and v_u_8:GetName(p21) or (v27 and (v27.DisplayName or "???") or "???")
    v_u_28.Frame.Container.Clip.Container.Player.Position = v_u_28.Frame.Container.Clip.Container.Username.Text == "" and UDim2.new(0.2, 0, 0.35, 0) or UDim2.new(0.2, 0, 0.225, 0)
    v_u_28.Frame.Container.Clip.Container.Weapon.Image = v_u_5:GetViewModelImage(p24, p25, true) or ""
    v_u_28.Frame.Container.Clip.Container.Background.ImageColor3 = v26 and v_u_4:GetTeamColor(p21:GetAttribute("TeamID")) or v_u_4.EMPTY_TEAM_COLOR
    v_u_28.Frame.Container.Clip.Container.PlayerSlot.FakeEliminator.Image = v27 and v27.Image or ""
    v_u_28.Frame.Container.Weapon.Image = v_u_28.Frame.Container.Clip.Container.Weapon.Image
    if p24 and v_u_5.Items[p24] then
        v_u_12:ApplyItemStatusToText(v_u_28.Frame.Container.Clip.Container.Description, v_u_5.Items[p24].Status)
    end
    v_u_28.Parent = p20.Frame
    v_u_3:AddItem(v_u_28, 10)
    p20:_SetLastEliminatedCard(v_u_28)
    if v26 then
        local v29 = v_u_11:GetDuel(v_u_2.LocalPlayer)
        if v29 then
            v29 = v29.IsRanked
        end
        local v30
        if v29 then
            v30 = nil
        else
            v30 = p21:GetAttribute("StatisticDuelsWinStreak")
        end
        local v31
        if v29 then
            v31 = nil
        else
            v31 = p21:GetAttribute("Level")
        end
        local v32 = p21:GetAttribute("DisplayELO")
        local v33 = v_u_13.new(p21.UserId, p22, p23, nil, nil, v30, v31)
        v33.SlotFrame.Parent = v_u_28.Frame.Container.Clip.Container.PlayerSlot
        if v29 then
            v33:SetDisplayELO(v32)
        end
    end
    v_u_28.Frame.Container.Size = UDim2.new(0, 0, 1, 0)
    v_u_28.Frame.Container:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quint", 1, true)
    wait(5)
    v_u_6:RenderstepForLoop(0, 100, 5, function(p34)
        v_u_28.GroupTransparency = (p34 / 100) ^ 5
    end)
    v_u_28:Destroy()
    if p20._last_eliminated_card == v_u_28 then
        p20:_SetLastEliminatedCard(nil)
    end
end
function v_u_16._SetLastEliminatedCard(p35, p36)
    p35._last_eliminated_card = p36
    p35.VisibilityChanged:Fire()
end
function v_u_16._HookLocalFighter(p_u_37)
    v_u_10:WaitForLocalFighter().EntityAdded:Connect(function()
        if p_u_37._last_eliminated_card and v_u_9.CurrentControls == "Touch" then
            p_u_37._last_eliminated_card:Destroy()
            p_u_37:_SetLastEliminatedCard(nil)
        end
    end)
end
function v_u_16._Init(p38)
    task.defer(p38._HookLocalFighter, p38)
end
return v_u_16._new()