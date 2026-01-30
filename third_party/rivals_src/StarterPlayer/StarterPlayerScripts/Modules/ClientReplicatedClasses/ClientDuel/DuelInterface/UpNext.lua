local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.DuelLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.DuelInterface = p7
    v9.Frame = v9.DuelInterface.Frame:WaitForChild("UpNext")
    v9.Container = v9.Frame:WaitForChild("Container"):WaitForChild("SpectateBuffer"):WaitForChild("Container")
    v9.Background = v9.Container:WaitForChild("Background")
    v9.Title = v9.Container:WaitForChild("Title")
    v9:_Init()
    return v9
end
function v_u_6.Update(p10)
    local v11 = not (p10.DuelInterface.Scoreboard:IsOpen() or p10.DuelInterface.Voting:IsOpen() or (v_u_4:IsVisible() or v_u_5.PageSystem.CurrentPage))
    if v11 then
        v11 = p10.DuelInterface.ClientDuel:Get("Status") == "RoundStarted"
    end
    local v12 = p10.DuelInterface.ClientDuel.LocalDueler
    if v12 then
        v12 = p10.DuelInterface.ClientDuel.LocalDueler:GetStaggeredSpawnsTurn()
    end
    if v12 then
        v12 = v12 <= 1
    end
    local v13 = p10.DuelInterface.ClientDuel:Get("PlaySourceName")
    local v14 = v13 and (v_u_3.PlaySources[v13].DuelLogic == "Zombie Tower" and (p10.DuelInterface.ClientDuel.LocalDueler and p10.DuelInterface.ClientDuel.LocalDueler.ClientFighter))
    if v14 then
        v14 = not p10.DuelInterface.ClientDuel.LocalDueler.ClientFighter:IsAlive()
    end
    p10.Frame.Visible = v11 and (v12 or v14)
    p10.Title.Text = v12 and "You\'re up next!" or (v14 and "Waiting to be revived by a Revive Drop" or "")
end
function v_u_6.Destroy(_) end
function v_u_6._UpdateBackground(p15)
    p15.Background.Size = UDim2.new(0, p15.Title.TextBounds.X + p15.Container.AbsoluteSize.Y * 0.6, 1, 0)
end
function v_u_6._Init(p_u_16)
    p_u_16.DuelInterface.Scoreboard.VisibilityChanged:Connect(function()
        p_u_16:Update()
    end)
    p_u_16.DuelInterface.Voting.VisibilityChanged:Connect(function()
        p_u_16:Update()
    end)
    p_u_16.Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_16:_UpdateBackground()
    end)
    p_u_16.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_16:_UpdateBackground()
    end)
    p_u_16:_UpdateBackground()
end
return v_u_6