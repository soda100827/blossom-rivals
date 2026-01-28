local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.UserInterface.Lobby.Requests)
return function(...)
    v_u_2:ChallengeRequest(...)
end