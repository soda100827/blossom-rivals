local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.Charm)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6._textlabel = v6.Model:WaitForChild("Extra"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel")
    v6._textlabel2 = v6.Model:WaitForChild("Extra"):WaitForChild("Part"):WaitForChild("SurfaceGui2"):WaitForChild("TextLabel")
    v6:_Init()
    return v6
end
function v_u_3._Setup(p7)
    local v8 = p7.EquippedData.Metadata and p7.EquippedData.Metadata.BeforeSeason0ELOResetLeaderboardRank and ("RANK #" .. p7.EquippedData.Metadata.BeforeSeason0ELOResetLeaderboardRank or "") or ""
    p7._textlabel.Text = v8
    p7._textlabel2.Text = v8
end
function v_u_3._Init(p9)
    p9:_Setup()
end
return v_u_3