local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Spring)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.Mouse = p4
    v6.Frame = v6.Mouse.Frame:WaitForChild("Hitmarker")
    v6.Dot = v6.Frame:WaitForChild("Dot")
    v6.TopLeft = v6.Frame:WaitForChild("TL")
    v6.TopRight = v6.Frame:WaitForChild("TR")
    v6.BottomRight = v6.Frame:WaitForChild("BR")
    v6.BottomLeft = v6.Frame:WaitForChild("BL")
    v6._hitmarker_spring = v_u_2.new(1, 1, 20)
    v6._hitmarker_rotation = 0
    v6._last_damage_dealt_time = 0
    v6:_Init()
    return v6
end
function v_u_3.DamageEffect(p7, p8, p9)
    if p8[utf8.char(0)] ~= 0 then
        local v10 = p8[utf8.char(1)] and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
        p7.TopLeft.ImageColor3 = v10
        p7.TopRight.ImageColor3 = v10
        p7.BottomRight.ImageColor3 = v10
        p7.BottomLeft.ImageColor3 = v10
        p7.Dot.ImageColor3 = v10
        local v11 = math.random() - 0.5
        p7._hitmarker_rotation = math.sign(v11) * 15
        p7._hitmarker_spring.Value = 0
        p7._last_damage_dealt_time = tick()
        p7.Mouse.ItemInterface.ClientItem.ViewModel:PlayHitmarkerSound(p8[utf8.char(1)], p9)
    end
end
function v_u_3.Update(p12, _, _, _)
    local v13 = p12._hitmarker_spring.Value
    local v14 = 32 + -26 * v13
    local v15 = 16 + -8 * v13
    local v16 = UDim2.new(0, v15, 0, v15)
    local v17 = (tick() - p12._last_damage_dealt_time) / 2
    local v18 = math.min(1, v17) ^ 10
    p12.TopLeft.Position = UDim2.new(0.5, -v14, 0.5, -v14)
    p12.TopRight.Position = UDim2.new(0.5, v14, 0.5, -v14)
    p12.BottomRight.Position = UDim2.new(0.5, v14, 0.5, v14)
    p12.BottomLeft.Position = UDim2.new(0.5, -v14, 0.5, v14)
    p12.TopLeft.Size = v16
    p12.TopRight.Size = v16
    p12.BottomRight.Size = v16
    p12.BottomLeft.Size = v16
    p12.TopLeft.ImageTransparency = v18
    p12.TopRight.ImageTransparency = v18
    p12.BottomRight.ImageTransparency = v18
    p12.BottomLeft.ImageTransparency = v18
    p12.Dot.ImageTransparency = v18
end
function v_u_3.Destroy(_) end
function v_u_3._Init(_) end
return v_u_3