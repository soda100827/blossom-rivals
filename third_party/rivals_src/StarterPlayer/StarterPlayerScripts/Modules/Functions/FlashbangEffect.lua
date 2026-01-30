local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("FlashbangEffect")
return function(p8, p9, p10, p11, p12, p13, p14)
    if (workspace.CurrentCamera.CFrame.Position - p9).Magnitude <= v_u_3.RENDER_DISTANCE then
        local v15 = v_u_7:Clone()
        v15.CFrame = CFrame.new(p9)
        v15.Parent = workspace
        v15.Attachment.Glow:Emit(5)
        v_u_4:AddItem(v15, 5)
        local v_u_16 = v15.PointLight
        task.spawn(v_u_5.RenderstepForLoop, v_u_5, 0, 100, 4, function(p17)
            v_u_16.Brightness = 40 * (1 - p17 / 100)
        end)
        if p13 then
            p13(p9)
        else
            v_u_5:CreateSound("rbxassetid://14778230670", 1, 1, p9, true, 10)
        end
        if v_u_6.CurrentSubject and v_u_6.CurrentSubject.FighterInterface then
            v_u_6.CurrentSubject.FighterInterface.Flashed:AttemptToFlash(p8, p9, p10, p11, p12, p14)
        end
    end
end