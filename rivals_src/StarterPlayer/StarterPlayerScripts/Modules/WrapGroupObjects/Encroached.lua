local v_u_1 = game:GetService("TweenService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules.WrapGroupObject)
local v_u_4 = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8._glyphs = {
        {},
        {}
    }
    v8._elapsed = 0
    v8._elapsed2 = 0
    v8._number_value = Instance.new("NumberValue")
    v8._jitter_u = 0
    v8._jitter_v = 0
    v8:_Init()
    return v8
end
function v_u_5.Update(p9, p10)
    p9._elapsed = p9._elapsed + p10 / 5
    p9._elapsed2 = p9._elapsed2 + p10
    if p9._elapsed2 >= 2 then
        p9._elapsed2 = 0
        p9._number_value.Value = 0.05
        v_u_1:Create(p9._number_value, v_u_4, {
            ["Value"] = 0
        }):Play()
    end
    for _, v11 in pairs(p9._glyphs[1]) do
        v11.OffsetStudsU = -(p9._elapsed % v11.StudsPerTileU) + p9._jitter_u
        v11.OffsetStudsV = -(p9._elapsed % v11.StudsPerTileV) + p9._jitter_v
        v11.Transparency = 0.55 + p9._number_value.Value * 2
    end
    for _, v12 in pairs(p9._glyphs[2]) do
        v12.OffsetStudsU = p9._elapsed % v12.StudsPerTileU + p9._jitter_u
        v12.OffsetStudsV = p9._elapsed % v12.StudsPerTileV + p9._jitter_v
        v12.Transparency = 0.55 + p9._number_value.Value * 2
    end
end
function v_u_5.Destroy(p13)
    p13._number_value:Destroy()
    v_u_3.Destroy(p13)
end
function v_u_5._Setup(p14)
    for _, v15 in pairs(p14.ExtraObjects) do
        if v15.Name == "Glyphs1" then
            local v16 = p14._glyphs[1]
            table.insert(v16, v15)
        elseif v15.Name == "Glyphs2" then
            local v17 = p14._glyphs[2]
            table.insert(v17, v15)
        end
    end
end
function v_u_5._Init(p_u_18)
    p_u_18._number_value:GetPropertyChangedSignal("Value"):Connect(function()
        p_u_18._jitter_u = Random.new():NextNumber(-p_u_18._number_value.Value, p_u_18._number_value.Value)
        p_u_18._jitter_v = Random.new():NextNumber(-p_u_18._number_value.Value, p_u_18._number_value.Value)
    end)
    p_u_18:_Setup()
end
return v_u_5