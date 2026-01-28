local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
require(v1.Modules.EnumLibrary)
local v_u_3 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_4 = v_u_2.LocalPlayer.PlayerScripts.Modules.ViewModels
local v_u_5 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PaintballSplatGui")
local v_u_6 = { "rbxassetid://17098901439", "rbxassetid://17098901515", "rbxassetid://16833617681" }
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9 = v_u_7
    local v10 = setmetatable({}, v9)
    v10.FighterInterface = p8
    v10._splat_guis = {}
    v10:_Init()
    return v10
end
function v_u_7.Create(p_u_11, p12, p13, p14)
    if p_u_11.FighterInterface:IsActive() then
        if p14 then
            p14 = v_u_4:FindFirstChild(p14, true)
        end
        if p14 then
            p13 = require(p14):GetPaintballColor() or p13
        end
        local v15 = p_u_11:_GetScreenPosition(p12)
        local v16 = 0.125 + 0.5 * math.random()
        local v_u_17 = v_u_5:Clone()
        v_u_17.Splat.Size = UDim2.new(v16, 0, v16, 0)
        v_u_17.Splat.Position = v15
        v_u_17.Splat.ImageColor3 = p13 or Color3.fromHSV(tick() * 2 % 1, 0.75, 1)
        v_u_17.Splat.Image = v_u_6[math.random(#v_u_6)]
        v_u_17.Splat.Rotation = 360 * math.random()
        v_u_17.Parent = p_u_11.FighterInterface:IsActive() and v_u_2.LocalPlayer.PlayerGui or nil
        local v18 = p_u_11._splat_guis
        table.insert(v18, v_u_17)
        task.delay(2.5, function()
            v_u_17:Destroy()
            local v19 = table.find(p_u_11._splat_guis, v_u_17)
            if v19 then
                table.remove(p_u_11._splat_guis, v19)
            end
        end)
        if v_u_17:IsDescendantOf(v_u_2.LocalPlayer) then
            v_u_17.Splat:TweenSize(UDim2.new(v16 * 0.75, 0, v16 * 0.75, 0), "In", "Quint", 2.5, true)
        end
        p_u_11.FighterInterface:CreateSound("rbxassetid://16835701807", 0.75, 1 + 0.4 * math.random(), script, true, 10)
    end
end
function v_u_7.Destroy(p20)
    for _, v21 in pairs(p20._splat_guis) do
        v21:Destroy()
    end
    p20._splat_guis = {}
end
function v_u_7._GetScreenPosition(p22, p23)
    local v24, v25
    if p23 then
        v24, v25 = workspace.CurrentCamera:WorldToScreenPoint(p23)
    else
        v25 = nil
        v24 = nil
    end
    if not v25 then
        local v26 = Vector2.new(p22.FighterInterface.Frame.AbsoluteSize.X, p22.FighterInterface.Frame.AbsoluteSize.Y) * (0.8 + 0.4 * math.random()) * 0.5
        local v27 = math.random() * 3.141592653589793 * 2
        return UDim2.new(0.5, math.cos(v27) * v26.X, 0.5, math.sin(v27) * v26.Y)
    end
    local v28 = v_u_3:ScreenPointToPosition(v24, p22.FighterInterface.Frame.AbsolutePosition)
    local v29 = UDim2.new
    local v30 = v28.X
    local v31 = p22.FighterInterface.Frame.AbsoluteSize.X * 0.125
    local v32 = p22.FighterInterface.Frame.AbsoluteSize.X * 0.875
    local v33 = math.clamp(v30, v31, v32)
    local v34 = v28.Y
    local v35 = p22.FighterInterface.Frame.AbsoluteSize.Y * 0.125
    local v36 = p22.FighterInterface.Frame.AbsoluteSize.Y * 0.875
    return v29(0, v33, 0, (math.clamp(v34, v35, v36)))
end
function v_u_7._Init(p_u_37)
    p_u_37.FighterInterface.ActiveChanged:Connect(function()
        for _, v38 in pairs(p_u_37._splat_guis) do
            v38.Parent = p_u_37.FighterInterface:IsActive() and v_u_2.LocalPlayer.PlayerGui or nil
        end
    end)
end
return v_u_7