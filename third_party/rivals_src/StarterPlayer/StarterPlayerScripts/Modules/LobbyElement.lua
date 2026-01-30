local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Signal)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5.EnabledChanged = v_u_2.new()
    v5.IsEnabled = false
    v5._original_pivots = {}
    v5:_Init()
    return v5
end
function v_u_3.SetEnabled(p6, p7)
    if p7 ~= p6.IsEnabled then
        p6.IsEnabled = p7
        p6.EnabledChanged:Fire(p6.IsEnabled)
    end
end
function v_u_3.Update(_, _) end
function v_u_3._GetOriginalPivot(p8, p9)
    p8._original_pivots[p9] = p8._original_pivots[p9] or p9:GetPivot()
    return p8._original_pivots[p9]
end
function v_u_3._Init(_) end
return v_u_3