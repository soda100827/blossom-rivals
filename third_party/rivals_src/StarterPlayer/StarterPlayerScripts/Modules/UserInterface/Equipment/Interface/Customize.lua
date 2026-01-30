local v_u_1 = require(script:WaitForChild("NameDisplay"))
local v_u_2 = require(script:WaitForChild("Description"))
local v_u_3 = require(script:WaitForChild("Cosmetics"))
local v_u_4 = require(script:WaitForChild("Actions"))
local v_u_5 = require(script:WaitForChild("Options"))
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Interface = p7
    v9.Frame = v9.Interface.Frame:WaitForChild("Customize")
    v9.TopFrame = v9.Frame:WaitForChild("Top")
    v9.BottomFrame = v9.Frame:WaitForChild("Bottom")
    v9.BottomContainer = v9.BottomFrame:WaitForChild("Container")
    v9.Options = v_u_5.new(v9)
    v9.Actions = v_u_4.new(v9)
    v9.Cosmetics = v_u_3.new(v9)
    v9.NameDisplay = v_u_1.new(v9)
    v9.Description = v_u_2.new(v9)
    v9:_Init()
    return v9
end
function v_u_6.SetVisible(p10, p11)
    p10.BottomFrame:TweenPosition(p11 and UDim2.new(0.5, 0, 1, 0) or UDim2.new(0.5, 0, 1.5, 0), "Out", "Quint", 0.25, true)
    p10.TopFrame:TweenPosition(p11 and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, -0.5, 0), "Out", "Quint", 0.25, true)
end
function v_u_6.OnCustomizingStateChanged(p12, ...)
    p12.Options:OnCustomizingStateChanged(...)
    p12.Actions:OnCustomizingStateChanged(...)
    p12.Cosmetics:OnCustomizingStateChanged(...)
    p12.Description:OnCustomizingStateChanged(...)
    p12.NameDisplay:OnCustomizingStateChanged(...)
end
function v_u_6.OnStateChanged(p13, ...)
    p13.Cosmetics:OnStateChanged(...)
    p13.Actions:OnStateChanged(...)
    p13.Options:OnStateChanged(...)
end
function v_u_6._Setup(p14)
    p14.Frame.Visible = true
end
function v_u_6._Init(p15)
    p15:_Setup()
end
return v_u_6