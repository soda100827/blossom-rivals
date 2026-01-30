local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_3 = require(v1.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local v_u_4 = require(v1.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new()
    local v6 = v_u_5
    local v7 = setmetatable({}, v6)
    v7.Frame = v_u_4:GetTo("MainFrame", "Lobby")
    v7.Play = require(script:WaitForChild("Play"))
    v7.Party = require(script:WaitForChild("Party"))
    v7.Buttons = require(script:WaitForChild("Buttons"))
    v7.Currency = require(script:WaitForChild("Currency"))
    v7.Requests = require(script:WaitForChild("Requests"))
    v7.Matchmaking = require(script:WaitForChild("Matchmaking"))
    v7.LocalFighter = nil
    v7._duel_connections = {}
    v7:_Init()
    return v7
end
function v_u_5._UpdateVisibility(p8)
    local v9 = p8.LocalFighter and not (p8.LocalFighter:Get("IsInShootingRange") or p8.LocalFighter:Get("IsInDuel"))
    if v9 then
        v9 = not v_u_2.CurrentDuelSubject
    end
    p8.Play.Frame.Visible = v9
    p8.Buttons.Frame.Visible = v9
    p8.Currency.Frame.Visible = v9
    p8.Requests.Frame.Visible = v9
    p8.Party.BottomDisplayFrame.Visible = v9
end
function v_u_5._UpdateCurrentDuelSubject(p10)
    for _, v11 in pairs(p10._duel_connections) do
        v11:Disconnect()
    end
    p10._duel_connections = {}
    if v_u_2.CurrentDuelSubject then
        p10:_UpdateVisibility()
    else
        p10:_UpdateVisibility()
    end
end
function v_u_5._HookLocalFighter(p_u_12)
    p_u_12.LocalFighter = v_u_3:WaitForLocalFighter()
    p_u_12.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_12:_UpdateVisibility()
    end)
    p_u_12.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_12:_UpdateVisibility()
    end)
    p_u_12:_UpdateVisibility()
end
function v_u_5._Init(p_u_13)
    v_u_2.DuelSubjectChanged:Connect(function()
        p_u_13:_UpdateCurrentDuelSubject()
    end)
    p_u_13:_UpdateVisibility()
    p_u_13:_UpdateCurrentDuelSubject()
    task.spawn(p_u_13._HookLocalFighter, p_u_13)
end
return v_u_5._new()