local v_u_1 = require(script:WaitForChild("ScoreNeeded"))
local v_u_2 = require(script:WaitForChild("Classic"))
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.Scores = p4
    v6.Frame = v6.Scores.Frame:WaitForChild("Teams")
    v6.LeftFrame = v6.Frame:WaitForChild("Left")
    v6.RightFrame = v6.Frame:WaitForChild("Right")
    v6.ScoreNeeded = v_u_1.new(v6)
    v6.Classic = v_u_2.new(v6)
    v6:_Init()
    return v6
end
function v_u_3.GetChatBubbleContainer(p7, p8)
    return p7.ScoreNeeded:GetChatBubbleContainer(p8) or p7.Classic:GetChatBubbleContainer(p8)
end
function v_u_3.Generate(p9)
    p9.ScoreNeeded:Generate()
    p9.Classic:Generate()
end
function v_u_3.Destroy(p10)
    p10.ScoreNeeded:Destroy()
    p10.Classic:Destroy()
end
function v_u_3._Init(_) end
return v_u_3