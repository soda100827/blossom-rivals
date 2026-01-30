local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2)
    local v3 = v_u_1
    local v4 = setmetatable({}, v3)
    v4.Model = p2
    v4._destroyed = false
    v4._original_scale = v4.Model:GetScale()
    v4:_Init()
    return v4
end
function v_u_1.GetPivot(p5)
    return p5.Model:GetPivot()
end
function v_u_1.SetParent(p6, p7)
    p6.Model.Parent = p7
end
function v_u_1.ScaleTo(p8, p9)
    p8.Model:ScaleTo(p8._original_scale * p9)
end
function v_u_1.PivotTo(p10, p11, p12)
    p10.Model.WorldPivot = p12 or p10.Model.WorldPivot
    p10.Model:PivotTo(p11)
    p10:Update(0)
end
function v_u_1.Update(_, _) end
function v_u_1.Destroy(p13)
    p13._destroyed = true
    p13.Model:Destroy()
end
function v_u_1._Init(_) end
return v_u_1