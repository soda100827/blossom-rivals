local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules:WaitForChild("Quaternion"))
local v_u_16 = {
    ["_type"] = "QuaternionSpring",
    ["new"] = function(p3, p4, p5, p6)
        local v7 = p3 or v_u_2.identity
        local v8 = p6 or os.clock
        local v9 = {
            ["_clock"] = v8,
            ["_time"] = v8(),
            ["_position"] = v7,
            ["_velocity"] = Vector3.new(0, 0, 0),
            ["_target"] = v7,
            ["_damping"] = p4 or 1,
            ["_speed"] = p5 or 1,
            ["_initial"] = v7
        }
        local v10 = v_u_16
        return setmetatable(v9, v10)
    end,
    ["Reset"] = function(p11, p12)
        local v13 = p12 or p11._initial
        p11._position = v13
        p11._target = v13
        p11._velocity = Vector3.new(0, 0, 0)
    end,
    ["Impulse"] = function(p14, p15)
        p14._velocity = p14._velocity + p15
    end
}
local function v_u_48(p17, p18)
    local v19 = p17._position
    local v20 = p17._velocity
    local v21 = p17._target
    local v22 = p17._damping
    local v23 = p17._speed
    local v24 = v23 * (p18 - p17._time)
    local v25 = v22 * v22
    local v26, v27, v28
    if v25 < 1 then
        local v29 = 1 - v25
        v26 = math.sqrt(v29)
        local v30 = -v22 * v24
        local v31 = math.exp(v30) / v26
        local v32 = v26 * v24
        v27 = v31 * math.cos(v32)
        local v33 = v26 * v24
        v28 = v31 * math.sin(v33)
    elseif v25 == 1 then
        local v34 = -v22 * v24
        v27 = math.exp(v34)
        v28 = v27 * v24
        v26 = 1
    else
        local v35 = v25 - 1
        v26 = math.sqrt(v35)
        local v36 = 2 * v26
        local v37 = (-v22 + v26) * v24
        local v38 = math.exp(v37) / v36
        local v39 = (-v22 - v26) * v24
        local v40 = math.exp(v39) / v36
        v27 = v38 + v40
        v28 = v38 - v40
    end
    local v41 = 1 - (v26 * v27 + v22 * v28)
    local v42 = v28 / v23
    local v43 = v23 * v28
    local v44 = v26 * v27 - v22 * v28
    local v45 = v19:Slerp(v21, v41):Integrate(v20, v42)
    local v46, v47 = v19:Difference(v21):ToAxisAngle()
    return v45, v46 * v47 * v43 + v20 * v44
end
function v_u_16.TimeSkip(p49, p50)
    local v51 = p49._clock()
    local v52, v53 = v_u_48(p49, v51 + p50)
    p49._position = v52
    p49._velocity = v53
    p49._time = v51
end
function v_u_16.__index(p54, p55)
    if v_u_16[p55] then
        return v_u_16[p55]
    end
    if p55 == "Position" or p55 == "p" then
        local v56, _ = v_u_48(p54, p54._clock())
        return v56
    end
    if p55 == "Velocity" or p55 == "v" then
        local _, v57 = v_u_48(p54, p54._clock())
        return v57
    end
    if p55 == "Target" or p55 == "t" then
        return p54._target
    end
    if p55 == "Damping" or p55 == "d" then
        return p54._damping
    end
    if p55 == "Speed" or p55 == "s" then
        return p54._speed
    end
    if p55 == "Clock" then
        return p54._clock
    end
    error(string.format("%q is not a valid member of QuaternionSpring.", (tostring(p55))), 2)
end
function v_u_16.__newindex(p58, p59, p60)
    local v61 = p58._clock()
    if p59 == "Position" or p59 == "p" then
        local _, v62 = v_u_48(p58, v61)
        p58._position = p60
        p58._velocity = v62
        p58._time = v61
        return
    elseif p59 == "Velocity" or p59 == "v" then
        local v63, _ = v_u_48(p58, v61)
        p58._position = v63
        p58._velocity = p60
        p58._time = v61
        return
    elseif p59 == "Target" or p59 == "t" then
        local v64, v65 = v_u_48(p58, v61)
        p58._position = v64
        p58._velocity = v65
        p58._target = p60
        p58._time = v61
        return
    elseif p59 == "Damping" or p59 == "d" then
        local v66, v67 = v_u_48(p58, v61)
        p58._position = v66
        p58._velocity = v67
        p58._damping = p60
        p58._time = v61
        return
    elseif p59 == "Speed" or p59 == "s" then
        local v68, v69 = v_u_48(p58, v61)
        p58._position = v68
        p58._velocity = v69
        p58._speed = p60 < 0 and 0 or p60
        p58._time = v61
        return
    elseif p59 == "Clock" then
        local v70, v71 = v_u_48(p58, v61)
        p58._position = v70
        p58._velocity = v71
        p58._clock = p60
        p58._time = p60()
    else
        error(string.format("%q is not a valid member of QuaternionSpring.", (tostring(p59))), 2)
    end
end
return v_u_16