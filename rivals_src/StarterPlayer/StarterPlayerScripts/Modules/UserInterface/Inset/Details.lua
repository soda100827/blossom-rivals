local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileButtons"))
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Inset = p7
    v9.LeftFrame = v9.Inset.LeftButtonsFrame:WaitForChild("Details")
    v9.LeftContainer = v9.LeftFrame:WaitForChild("Container")
    v9.LeftServerRegionFrame = v9.LeftContainer:WaitForChild("ServerRegion")
    v9.LeftServerRegionTitle = v9.LeftServerRegionFrame:WaitForChild("Title")
    v9.LeftConnectionFrame = v9.LeftContainer:WaitForChild("Connection")
    v9.LeftConnectionTitle = v9.LeftConnectionFrame:WaitForChild("Title")
    v9.LeftConnectionIcon = v9.LeftConnectionFrame:WaitForChild("Icon")
    v9.RightFrame = v9.Inset.RightButtonsFrame:WaitForChild("Details")
    v9.RightContainer = v9.RightFrame:WaitForChild("Container")
    v9.RightServerRegionFrame = v9.RightContainer:WaitForChild("ServerRegion")
    v9.RightServerRegionTitle = v9.RightServerRegionFrame:WaitForChild("Title")
    v9.RightConnectionFrame = v9.RightContainer:WaitForChild("Connection")
    v9.RightConnectionTitle = v9.RightConnectionFrame:WaitForChild("Title")
    v9.RightConnectionIcon = v9.RightConnectionFrame:WaitForChild("Icon")
    v9._dt_history = {}
    v9:_Init()
    return v9
end
function v_u_6.SetVisible(p10, p11)
    p10.LeftFrame.Visible = p11 and false
    p10.RightFrame.Visible = p11 and true
end
function v_u_6._UpdateServerRegion(p12)
    p12.LeftServerRegionTitle.Text = v_u_5:Get("ServerRegion") or "\226\128\162 \226\128\162 \226\128\162"
    p12.RightServerRegionTitle.Text = p12.LeftServerRegionTitle.Text
end
function v_u_6._UpdateTextBounds(p13)
    local v14 = p13.LeftFrame
    local v15 = UDim2.new
    local v16 = p13.LeftServerRegionTitle.TextBounds.X
    local v17 = p13.LeftConnectionTitle.TextBounds.X
    v14.Size = v15(1.25, math.max(v16, v17), 1, 0)
    local v18 = p13.RightFrame
    local v19 = UDim2.new
    local v20 = p13.RightServerRegionTitle.TextBounds.X
    local v21 = p13.RightConnectionTitle.TextBounds.X
    v18.Size = v19(1.25, math.max(v20, v21), 1, 0)
end
function v_u_6._GetFramerate(p22)
    local v23 = p22._dt_history
    local v24 = v_u_2.RenderStepped
    table.insert(v23, 1, v24:Wait())
    table.remove(p22._dt_history, 11)
    local v25 = 0
    for _, v26 in pairs(p22._dt_history) do
        v25 = v25 + v26
    end
    local v27 = 1 / (v25 / #p22._dt_history)
    return math.floor(v27)
end
function v_u_6._UpdateConnectionLoop(p28)
    while true do
        local v29 = v_u_4:GetLocalConnectionPing()
        local v30 = v_u_4:GetConnectionLevelIcon((v_u_4:GetConnectionLevel(v29)))
        local v31 = p28:_GetFramerate()
        p28.LeftConnectionTitle.Text = v31 .. "fps   " .. v29 .. "ms"
        p28.LeftConnectionIcon.Image = v30 or ""
        p28.RightConnectionTitle.Text = p28.LeftConnectionTitle.Text
        p28.RightConnectionIcon.Image = p28.LeftConnectionIcon.Image
        wait(0.25)
    end
end
function v_u_6._Init(p_u_32)
    p_u_32.LeftServerRegionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_32:_UpdateTextBounds()
    end)
    p_u_32.RightServerRegionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_32:_UpdateTextBounds()
    end)
    p_u_32.LeftConnectionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_32:_UpdateTextBounds()
    end)
    p_u_32.RightConnectionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
        p_u_32:_UpdateTextBounds()
    end)
    v_u_5:GetDataChangedSignal("ServerRegion"):Connect(function()
        p_u_32:_UpdateServerRegion()
    end)
    p_u_32:_UpdateServerRegion()
    task.defer(p_u_32._UpdateConnectionLoop, p_u_32)
end
return v_u_6