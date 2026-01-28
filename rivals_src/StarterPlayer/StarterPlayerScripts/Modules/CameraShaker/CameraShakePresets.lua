local v_u_1 = require(script.Parent.CameraShakeInstance)
local v_u_12 = {
    ["Bump"] = function()
        local v2 = v_u_1.new(2.5, 4, 0.1, 0.75)
        v2.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
        v2.RotationInfluence = Vector3.new(1, 1, 1)
        return v2
    end,
    ["Explosion"] = function()
        local v3 = v_u_1.new(5, 10, 0, 1.5)
        v3.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v3.RotationInfluence = Vector3.new(4, 1, 1)
        return v3
    end,
    ["Earthquake"] = function()
        local v4 = v_u_1.new(0.6, 3.5, 2, 10)
        v4.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v4.RotationInfluence = Vector3.new(1, 1, 4)
        return v4
    end,
    ["BadTrip"] = function()
        local v5 = v_u_1.new(10, 0.15, 5, 10)
        v5.PositionInfluence = Vector3.new(0, 0, 0.15)
        v5.RotationInfluence = Vector3.new(2, 1, 4)
        return v5
    end,
    ["HandheldCamera"] = function()
        local v6 = v_u_1.new(1, 0.25, 5, 10)
        v6.PositionInfluence = Vector3.new(0, 0, 0)
        v6.RotationInfluence = Vector3.new(1, 0.5, 0.5)
        return v6
    end,
    ["Vibration"] = function()
        local v7 = v_u_1.new(0.4, 20, 2, 2)
        v7.PositionInfluence = Vector3.new(0, 0.15, 0)
        v7.RotationInfluence = Vector3.new(1.25, 0, 4)
        return v7
    end,
    ["RoughDriving"] = function()
        local v8 = v_u_1.new(1, 2, 1, 1)
        v8.PositionInfluence = Vector3.new(0, 0, 0)
        v8.RotationInfluence = Vector3.new(1, 1, 1)
        return v8
    end,
    ["Recoil"] = function()
        local v9 = v_u_1.new(2, 6, 0.05, 0.4)
        v9.PositionInfluence = Vector3.new(0, 0, 0)
        v9.RotationInfluence = Vector3.new(1, 1, 2)
        return v9
    end,
    ["ChainsawHold"] = function()
        local v10 = v_u_1.new(3, 6, 0.1, 0.1)
        v10.PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
        v10.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)
        return v10
    end,
    ["BattleAxeSpin"] = function()
        local v11 = v_u_1.new(5, 10, 0, 0.25)
        v11.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v11.RotationInfluence = Vector3.new(4, 1, 1)
        return v11
    end
}
return setmetatable({}, {
    ["__index"] = function(_, p13)
        local v14 = v_u_12[p13]
        if type(v14) == "function" then
            return v14()
        end
        error("No preset found with index \"" .. p13 .. "\"")
    end
})