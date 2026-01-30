local v1 = game:GetService("ReplicatedStorage")
game:GetService("ContentProvider")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.InputLibrary)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7._new()
    local v8 = v_u_6.new("Duel")
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10.LocalPlayerJoinedOrLeftDuel = v_u_4.new()
    v10.LocalPlayerJoinedDuel = v_u_4.new()
    v10.LocalPlayerLeftDuel = v_u_4.new()
    v10:_Init()
    return v10
end
function v_u_7.GetDuelByID(p11, p12)
    for v13, v14 in pairs(p11.Objects) do
        if v14:Get("ObjectID") == p12 then
            return v14, v13
        end
    end
end
function v_u_7.GetDuel(p15, p16)
    for v17, v18 in pairs(p15.Objects) do
        if v18:GetDueler(p16) then
            return v18, v17
        end
    end
end
function v_u_7._Init(p_u_19)
    p_u_19.ObjectAdded:Connect(function(p_u_20)
        local function v23(p_u_21)
            if p_u_21 and p_u_21.IsLocalPlayer then
                p_u_20.DuelerRemoved:Connect(function(p22)
                    if p22 == p_u_21 then
                        p_u_19.LocalPlayerLeftDuel:Fire(p_u_20, p22)
                        p_u_19.LocalPlayerJoinedOrLeftDuel:Fire(p_u_20, p22)
                    end
                end)
                p_u_19.LocalPlayerJoinedDuel:Fire(p_u_20, p_u_21)
                p_u_19.LocalPlayerJoinedOrLeftDuel:Fire(p_u_20, p_u_21)
            end
        end
        p_u_20.DuelerAdded:Connect(v23)
        v23(p_u_20:GetDueler(v_u_2.LocalPlayer))
    end)
    p_u_19.ObjectRemoved:Connect(function(p24)
        local v25 = p24:GetDueler(v_u_2.LocalPlayer)
        if v25 then
            p_u_19.LocalPlayerLeftDuel:Fire(p24, v25)
            p_u_19.LocalPlayerJoinedOrLeftDuel:Fire(p24, v25)
        end
    end)
    v_u_5.InputBegan:Connect(function(p26, p27)
        if p27 then
            return
        else
            local v28 = p_u_19:GetDuel(v_u_2.LocalPlayer)
            if v28 and (v28.DuelInterface.Buttons:IsSwitchItemsVisible() and v_u_3:InputIs(p26, "SwitchItems")) then
                v28.DuelInterface.Buttons:SwitchItemsRequest()
                return
            elseif v28 and (v28.DuelInterface.Buttons:IsRespawnNowVisible() and v_u_3:InputIs(p26, "Jump")) then
                v28.DuelInterface.Buttons:RespawnNowRequest()
            elseif v28 and v_u_3:InputIs(p26, "LeaveDuel") then
                v28:LeaveDuelRequest()
            end
        end
    end)
end
return v_u_7._new()