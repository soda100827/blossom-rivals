local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.DuelLibrary)
local v_u_3 = require(v1.Modules.Utility)
return function(p_u_4, p5)
    v_u_3:PlayParticles(p_u_4.Primary)
    v_u_3:CreateSound("rbxassetid://98948832050219", 2, 1, p_u_4.Primary, true, 5)
    v_u_3:CreateSound("rbxassetid://129130524317348", 1.5, 1, p_u_4.Primary, true, 5)
    local v6 = p_u_4.Flag
    v6.CFrame = v6.CFrame * CFrame.new(0, 4, 0)
    p_u_4.Flag.Color = v_u_2:GetTeamColor(p5)
    p_u_4.Flag.Transparency = 0
    local v_u_7 = p_u_4:GetPivot()
    local v_u_8 = CFrame.Angles(6.283185307179586 * math.random(), 6.283185307179586 * math.random(), 6.283185307179586 * math.random())
    local v_u_9 = p_u_4:GetScale()
    local v_u_10 = v_u_9 * 0.5
    v_u_3:RenderstepForLoop(0, 100, 2, function(p11)
        local v12 = 1 - (1 - p11 / 100) ^ 3
        p_u_4:ScaleTo(v_u_10 + (v_u_9 - v_u_10) * v12)
        p_u_4:PivotTo(v_u_7 * CFrame.Angles(0, 0 + 9.42477796076938 * v12, 0) * v_u_8:Lerp(CFrame.identity, v12))
    end)
end