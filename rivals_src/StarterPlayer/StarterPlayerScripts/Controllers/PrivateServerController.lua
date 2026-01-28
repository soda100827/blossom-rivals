local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.CONSTANTS)
local v_u_5 = require(v_u_2.Modules.ReplicatedClass)
local v_u_6 = require(v_u_2.Modules.Signal)
local v_u_7 = { "FreecamEnabled" }
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_5.new()
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.BannedPlayersChanged = v_u_6.new()
    v11.BannedPlayers = {}
    v11:_Init()
    return v11
end
function v_u_8._ObjectAdded(_, p12)
    if not v_u_4.IS_PRIVATE_HUB_SERVER then
        task.defer(p12.Destroy, p12)
    end
end
function v_u_8._SetBannedPlayers(p13, p14)
    p13.BannedPlayers = p14
    p13.BannedPlayersChanged:Fire()
end
function v_u_8._FetchBannedPlayers(p15)
    if v_u_4.IS_PRIVATE_SERVER_OWNER(v_u_3.LocalPlayer.UserId) then
        local v16, v17 = pcall(v_u_2.Remotes.PrivateServer.FetchBannedPlayers.InvokeServer, v_u_2.Remotes.PrivateServer.FetchBannedPlayers)
        if v16 then
            p15:_SetBannedPlayers(v17)
        end
    else
        return
    end
end
function v_u_8._Setup(p_u_18)
    for _, v_u_19 in pairs(v_u_7) do
        workspace:GetAttributeChangedSignal(v_u_19):Connect(function()
            p_u_18:SetReplicate(v_u_19, workspace:GetAttribute(v_u_19))
        end)
        p_u_18:SetReplicate(v_u_19, workspace:GetAttribute(v_u_19))
    end
end
function v_u_8._Init(p_u_20)
    v_u_2.Remotes.PrivateServer.ReplicateBannedPlayers.OnClientEvent:Connect(function(p21)
        p_u_20:_SetBannedPlayers(p21)
    end)
    v_u_1:GetInstanceAddedSignal("LobbyPrivateServerOnly"):Connect(function(p22)
        p_u_20:_ObjectAdded(p22)
    end)
    for _, v23 in pairs(v_u_1:GetTagged("LobbyPrivateServerOnly")) do
        task.defer(p_u_20._ObjectAdded, p_u_20, v23)
    end
    p_u_20:_Setup()
    task.defer(p_u_20._FetchBannedPlayers, p_u_20)
end
return v_u_8._new()