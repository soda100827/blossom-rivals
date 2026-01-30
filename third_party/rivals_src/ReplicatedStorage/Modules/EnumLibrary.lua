local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1:WaitForChild("Modules"):WaitForChild("Signal"))
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5.AlwaysReplicateToEveryone = {}
    v5._num_enums = 0
    v5._to_enum = {}
    v5._from_enum = {}
    v5._enum_builder_complete = false
    v5._enum_builder_completed_internal = v_u_2.new()
    v5:_Init()
    return v5
end
function v_u_3.ToEnum(p6, p7, p8)
    if p7 then
        local v9 = p6._to_enum[p7]
        local v10 = p8 or v9 ~= nil
        assert(v10, p7)
        return v9
    end
end
function v_u_3.FromEnum(p11, p12, p13)
    if p12 then
        local v14 = p11._from_enum[p12]
        local v15 = p13 or v14 ~= nil
        assert(v15, p12)
        return v14
    end
end
function v_u_3.AddEnum(p16, p17)
    if not p16:ToEnum(p17, true) then
        local v18 = utf8.char(p16._num_enums)
        p16._num_enums = p16._num_enums + 1
        p16._to_enum[p17] = v18
        p16._from_enum[v18] = p17
    end
end
function v_u_3.WaitForEnumBuilder(p19)
    if not p19._enum_builder_complete then
        p19._enum_builder_completed_internal:Wait()
    end
end
function v_u_3.EnumBuilderCompleted(p20)
    p20._enum_builder_complete = true
    p20._enum_builder_completed_internal:Fire()
end
function v_u_3._Init(_) end
return v_u_3._new()