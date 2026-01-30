local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5:_Init()
    return v5
end
function v_u_3._UpdateElementSimple(_, p6)
    local v7 = v_u_2.PreferredTransparency
    local v8 = p6:GetAttribute("BaseTransparency") or 1
    p6[p6:IsA("Frame") and "BackgroundTransparency" or "ImageTransparency"] = 0 + (v8 - 0) * v7
    local v9 = p6:GetAttribute("TransparentColor")
    local v10 = p6:GetAttribute("OpaqueColor")
    if v9 and v10 then
        p6[p6:IsA("Frame") and "BackgroundColor3" or "ImageColor3"] = v10:Lerp(v9, v7)
    end
end
function v_u_3._UpdateElement(_, p11)
    local v12 = p11:WaitForChild("UIGradient")
    local v13 = v_u_2.PreferredTransparency
    p11.ImageTransparency = 0 + 0.25 * v13
    p11.ImageColor3 = Color3.fromRGB(31, 31, 31):Lerp(Color3.fromRGB(0, 0, 0), v13)
    v12.Transparency = NumberSequence.new(0, 0 + 0.5 * v13)
    v12.Color = ColorSequence.new(Color3.fromRGB(127, 127, 127):Lerp(Color3.fromRGB(255, 255, 255), v13), Color3.fromRGB(255, 255, 255))
end
function v_u_3._UpdateAllElements(p14)
    for _, v15 in pairs(v_u_1:GetTagged("UIBackground")) do
        p14:_UpdateElement(v15)
    end
    for _, v16 in pairs(v_u_1:GetTagged("UIBackgroundSimple")) do
        p14:_UpdateElementSimple(v16)
    end
end
function v_u_3._Init(p_u_17)
    v_u_1:GetInstanceAddedSignal("UIBackground"):Connect(function(p18)
        p_u_17:_UpdateElement(p18)
    end)
    v_u_1:GetInstanceAddedSignal("UIBackgroundSimple"):Connect(function(p19)
        p_u_17:_UpdateElementSimple(p19)
    end)
    v_u_2:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
        p_u_17:_UpdateAllElements()
    end)
    task.defer(p_u_17._UpdateAllElements, p_u_17)
end
return v_u_3._new()