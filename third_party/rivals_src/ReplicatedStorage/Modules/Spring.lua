local v_u_63 = {
    ["new"] = function(p1, p2, p3, p4)
        local v5 = p1 or 0
        local v6 = p4 or os.clock
        local v7 = {
            ["_clock"] = v6,
            ["_time0"] = v6(),
            ["_position0"] = v5,
            ["_velocity0"] = 0 * v5,
            ["_target"] = v5,
            ["_damper"] = p2 or 1,
            ["_speed"] = p3 or 1
        }
        local v8 = v_u_63
        return setmetatable(v7, v8)
    end,
    ["Impulse"] = function(p9, p10)
        p9.Velocity = p9.Velocity + p10
    end,
    ["TimeSkip"] = function(p11, p12)
        local v13 = p11._clock()
        local v14, v15 = p11:_positionVelocity(v13 + p12)
        p11._position0 = v14
        p11._velocity0 = v15
        p11._time0 = v13
    end,
    ["__index"] = function(p16, p17)
        if v_u_63[p17] then
            return v_u_63[p17]
        end
        if p17 == "Value" or (p17 == "Position" or p17 == "p") then
            local v18, _ = p16:_positionVelocity(p16._clock())
            return v18
        end
        if p17 == "Velocity" or p17 == "v" then
            local _, v19 = p16:_positionVelocity(p16._clock())
            return v19
        end
        if p17 == "Target" or p17 == "t" then
            return p16._target
        end
        if p17 == "Damper" or p17 == "d" then
            return p16._damper
        end
        if p17 == "Speed" or p17 == "s" then
            return p16._speed
        end
        if p17 == "Clock" then
            return p16._clock
        end
        error(("%q is not a valid member of Spring"):format((tostring(p17))), 2)
    end,
    ["__newindex"] = function(p20, p21, p22)
        local v23 = p20._clock()
        if p21 == "Value" or (p21 == "Position" or p21 == "p") then
            local _, v24 = p20:_positionVelocity(v23)
            p20._position0 = p22
            p20._velocity0 = v24
            p20._time0 = v23
            return
        elseif p21 == "Velocity" or p21 == "v" then
            local v25, _ = p20:_positionVelocity(v23)
            p20._position0 = v25
            p20._velocity0 = p22
            p20._time0 = v23
            return
        elseif p21 == "Target" or p21 == "t" then
            local v26, v27 = p20:_positionVelocity(v23)
            p20._position0 = v26
            p20._velocity0 = v27
            p20._target = p22
            p20._time0 = v23
            return
        elseif p21 == "Damper" or p21 == "d" then
            local v28, v29 = p20:_positionVelocity(v23)
            p20._position0 = v28
            p20._velocity0 = v29
            p20._damper = p22
            p20._time0 = v23
            return
        elseif p21 == "Speed" or p21 == "s" then
            local v30, v31 = p20:_positionVelocity(v23)
            p20._position0 = v30
            p20._velocity0 = v31
            p20._speed = p22 < 0 and 0 or p22
            p20._time0 = v23
            return
        elseif p21 == "Clock" then
            local v32, v33 = p20:_positionVelocity(v23)
            p20._position0 = v32
            p20._velocity0 = v33
            p20._clock = p22
            p20._time0 = p22()
        else
            error(("%q is not a valid member of Spring"):format((tostring(p21))), 2)
        end
    end,
    ["_positionVelocity"] = function(p34, p35)
        local v36 = p34._position0
        local v37 = p34._velocity0
        local v38 = p34._target
        local v39 = p34._damper
        local v40 = p34._speed
        local v41 = v40 * (p35 - p34._time0)
        local v42 = v39 * v39
        local v43, v44, v45
        if v42 < 1 then
            local v46 = 1 - v42
            v43 = math.sqrt(v46)
            local v47 = -v39 * v41
            local v48 = math.exp(v47) / v43
            local v49 = v43 * v41
            v44 = v48 * math.cos(v49)
            local v50 = v43 * v41
            v45 = v48 * math.sin(v50)
        elseif v42 == 1 then
            v43 = 1
            local v51 = -v39 * v41
            v44 = math.exp(v51) / v43
            v45 = v44 * v41
        else
            local v52 = v42 - 1
            v43 = math.sqrt(v52)
            local v53 = (-v39 + v43) * v41
            local v54 = math.exp(v53) / (2 * v43)
            local v55 = (-v39 - v43) * v41
            local v56 = math.exp(v55) / (2 * v43)
            v44 = v54 + v56
            v45 = v54 - v56
        end
        local v57 = v43 * v44 + v39 * v45
        local v58 = 1 - (v43 * v44 + v39 * v45)
        local v59 = v45 / v40
        local v60 = -v40 * v45
        local v61 = v40 * v45
        local v62 = v43 * v44 - v39 * v45
        return v57 * v36 + v58 * v38 + v59 * v37, v60 * v36 + v61 * v38 + v62 * v37
    end
}
return v_u_63