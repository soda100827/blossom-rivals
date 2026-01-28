local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.SeasonLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.Page = p6
    v8.Frame = v8.Page.Container:WaitForChild("ELOShield")
    v8.Title = v8.Frame:WaitForChild("Title")
    v8.LeftIcon = v8.Title:WaitForChild("Left")
    v8.RightIcon = v8.Title:WaitForChild("Right")
    v8:_Init()
    return v8
end
function v_u_5.Open(p9)
    p9:_Update()
end
function v_u_5.Close(_) end
function v_u_5._UpdateIcons(p10)
    p10.LeftIcon.Position = UDim2.new(0.5, -p10.Title.TextBounds.X / 2, 0.5, 0)
    p10.RightIcon.Position = UDim2.new(0.5, p10.Title.TextBounds.X / 2, 0.5, 0)
end
function v_u_5._Update(p11)
    local v12 = v_u_4:Get("Seasons")[v_u_3.CurrentSeason.Name]
    if v12 then
        v12 = v12.RankedPerformances[v_u_3.UNIVERSAL_ELO_NAME]
    end
    local v13 = p11.Frame
    if v12 then
        v12 = v12.ELOShieldsRemaining > 0
    end
    v13.Visible = v12
    p11:_UpdateIcons()
end
function v_u_5._Init(p_u_14)
    p_u_14.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_14:_UpdateIcons()
    end)
    p_u_14:_UpdateIcons()
end
return v_u_5