local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2, p3, p4)
    local v5 = v_u_1
    local v6 = setmetatable({}, v5)
    v6.TeamID = p2
    v6.TeamkillEnabled = p3
    v6.GrabSmallHitboxes = p4
    v6.SourceEntity = nil
    v6.CanHurtSelf = nil
    v6:_Init()
    return v6
end
function v_u_1.IsValidTarget(p7, p8)
    if p8 and (p7.CanHurtSelf or p8 ~= p7.SourceEntity) and p8:IsAlive() then
        return (p7.TeamkillEnabled or (not p7.TeamID or (p8 == p7.SourceEntity or p8:Get("TeamID") ~= p7.TeamID))) and true or false
    else
        return false
    end
end
function v_u_1._Init(_) end
return v_u_1