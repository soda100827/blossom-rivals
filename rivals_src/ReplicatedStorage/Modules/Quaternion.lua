local v_u_1 = {
    ["_type"] = "Quaternion",
    ["_TO_STRING_CHAR"] = nil
}
local function v_u_8(p2, p3, p4, p5)
    local v6 = v_u_1
    local v7 = setmetatable({
        ["X"] = p2 or 0,
        ["Y"] = p3 or 0,
        ["Z"] = p4 or 0,
        ["W"] = p5 or 1,
        ["_cached"] = {}
    }, v6)
    table.freeze(v7)
    return v7
end
v_u_1.new = v_u_8
v_u_1.identity = v_u_8(0, 0, 0, 1)
v_u_1.zero = v_u_8(0, 0, 0, 0)
local function v_u_17(p9, p10, p11)
    local v12 = p9.Magnitude <= 5e-7 and Vector3.new(1, 0, 0) or p9.Unit
    local v13 = v12:Cross(p10.Magnitude <= 5e-7 and Vector3.new(0, 1, 0) or p10.Unit)
    local v14
    if v13.Magnitude > 5e-7 then
        v14 = v13.Unit
    else
        local v15 = v12:Cross(Vector3.new(0, 1, 0))
        v14 = v15.Magnitude <= 5e-7 and Vector3.new(1, 0, 0) or v15.Unit
    end
    local v16 = v14:Cross(v12).Unit
    if v14:Dot(p11) < 0 then
        v14 = -v14
    end
    return v12, v16, v14
end
local function v_u_43(p18, p19, p20)
    local v21 = p18.X
    local v22 = p18.Y
    local v23 = p18.Z
    local v24 = p19.X
    local v25 = p19.Y
    local v26 = p19.Z
    local v27 = p20.X
    local v28 = p20.Y
    local v29 = p20.Z
    local v30 = v21 + v25 + v29
    local v31, v32, v33, v34
    if v30 > 0 then
        local v35 = v30 + 1
        local v36 = math.sqrt(v35) * 2
        v31 = (v26 - v28) / v36
        v32 = (v27 - v23) / v36
        v33 = (v22 - v24) / v36
        v34 = v36 * 0.25
    elseif v25 < v21 and v29 < v21 then
        local v37 = v21 + 1 - v25 - v29
        local v38 = math.sqrt(v37) * 2
        v31 = v38 * 0.25
        v32 = (v24 + v22) / v38
        v33 = (v27 + v23) / v38
        v34 = (v26 - v28) / v38
    elseif v29 < v25 then
        local v39 = v25 + 1 - v21 - v29
        local v40 = math.sqrt(v39) * 2
        v31 = (v24 + v22) / v40
        v32 = v40 * 0.25
        v33 = (v28 + v26) / v40
        v34 = (v27 - v23) / v40
    else
        local v41 = v29 + 1 - v21 - v25
        local v42 = math.sqrt(v41) * 2
        v31 = (v27 + v23) / v42
        v32 = (v28 + v26) / v42
        v33 = v42 * 0.25
        v34 = (v22 - v24) / v42
    end
    return v_u_8(v31, v32, v33, v34)
end
function v_u_1.fromAxisAngle(p44, p45)
    local v46 = p44.Magnitude <= 5e-7 and Vector3.new(1, 0, 0) or p44.Unit
    local v47 = p45 / 2
    local v48 = math.sin(v47)
    return v_u_8(v48 * v46.X, v48 * v46.Y, v48 * v46.Z, (math.cos(v47)))
end
function v_u_1.fromAxisAngleFast(p49, p50)
    local v51 = p50 / 2
    local v52 = p49 * math.sin(v51)
    return v_u_8(v52.X, v52.Y, v52.Z, (math.cos(v51)))
end
function v_u_1.fromEulerVector(p53)
    local v54 = p53.Magnitude
    if v54 <= 0 then
        return v_u_1.identity
    end
    local v55 = p53 / v54
    local v56 = v54 / 2
    local v57 = v55 * math.sin(v56)
    return v_u_8(v57.X, v57.Y, v57.Z, (math.cos(v56)))
end
function v_u_1.fromCFrame(p58)
    local v59, v60 = p58:Orthonormalize():ToAxisAngle()
    local v61 = v59.Magnitude <= 5e-7 and Vector3.new(1, 0, 0) or v59.Unit
    local v62 = v60 / 2
    local v63 = math.sin(v62)
    return v_u_8(v63 * v61.X, v63 * v61.Y, v63 * v61.Z, (math.cos(v62)))
end
function v_u_1.fromCFrameFast(p64)
    local v65, v66 = p64:ToAxisAngle()
    local v67 = v66 / 2
    local v68 = v65 * math.sin(v67)
    return v_u_8(v68.X, v68.Y, v68.Z, (math.cos(v67)))
end
function v_u_1.fromMatrix(p69, p70, p71)
    return v_u_43(v_u_17(p69, p70, p71 or p69:Cross(p70)))
end
function v_u_1.fromMatrixFast(p72, p73, p74)
    return v_u_43(p72.Unit, p73.Unit, p74 or p72:Cross(p73).Unit)
end
function v_u_1.lookAt(p75, p76, p77)
    local v78 = p76 - p75
    local v79 = v78.Magnitude <= 5e-7 and Vector3.new(0, 0, 1) or v78.Unit
    local v80 = p77 or Vector3.new(0, 1, 0)
    local v81 = v79:Cross(v80.Magnitude <= 5e-7 and Vector3.new(0, 1, 0) or v80.Unit)
    if v81.Magnitude > 5e-7 then
        local v82 = v81.Unit
        return v_u_43(v82, v82:Cross(v79).Unit, -v79)
    end
    local v83 = v79:Cross(Vector3.new(1, 0, 0))
    if v83.Magnitude > 5e-7 then
        local v84 = v83.Unit
        return v_u_43(v84, v84:Cross(v79).Unit, -v79)
    end
    local v85 = (Vector3.new(0, 0, 1)):Cross(v79)
    local v86 = v85 * v85:Dot(Vector3.new(0, 1, 0))
    return v_u_43(v79:Cross(v86), v86, -v79)
end
local function v106(p87, p88, p89)
    local v90 = p87 / 2
    local v91 = math.cos(v90)
    local v92 = p87 / 2
    local v93 = math.sin(v92)
    local v94 = p88 / 2
    local v95 = math.cos(v94)
    local v96 = p88 / 2
    local v97 = math.sin(v96)
    local v98 = p89 / 2
    local v99 = math.cos(v98)
    local v100 = p89 / 2
    local v101 = math.sin(v100)
    local v102 = v93 * v95
    local v103 = v91 * v97
    local v104 = v91 * v95
    local v105 = v93 * v97
    return v_u_8(v102 * v99 + v103 * v101, v103 * v99 - v102 * v101, v104 * v101 + v105 * v99, v104 * v99 - v105 * v101)
end
v_u_1.fromEulerAnglesXYZ = v106
v_u_1.Angles = v106
local function v126(p107, p108, p109)
    local v110 = p107 / 2
    local v111 = math.cos(v110)
    local v112 = p107 / 2
    local v113 = math.sin(v112)
    local v114 = p108 / 2
    local v115 = math.cos(v114)
    local v116 = p108 / 2
    local v117 = math.sin(v116)
    local v118 = p109 / 2
    local v119 = math.cos(v118)
    local v120 = p109 / 2
    local v121 = math.sin(v120)
    local v122 = v113 * v115
    local v123 = v111 * v117
    local v124 = v111 * v115
    local v125 = v113 * v117
    return v_u_8(v122 * v119 + v123 * v121, v123 * v119 - v122 * v121, v124 * v121 - v125 * v119, v124 * v119 + v125 * v121)
end
v_u_1.fromEulerAnglesYXZ = v126
v_u_1.fromOrientation = v126
function v_u_1.fromEulerAngles(p127, p128, p129, p130)
    local v131 = p130 or Enum.RotationOrder.XYZ
    local v132 = p127 / 2
    local v133 = math.cos(v132)
    local v134 = p128 / 2
    local v135 = math.cos(v134)
    local v136 = p129 / 2
    local v137 = math.cos(v136)
    local v138 = p127 / 2
    local v139 = math.sin(v138)
    local v140 = p128 / 2
    local v141 = math.sin(v140)
    local v142 = p129 / 2
    local v143 = math.sin(v142)
    local v144 = v139 * v135
    local v145 = v133 * v141
    local v146 = v133 * v135
    local v147 = v139 * v141
    local v148 = nil
    local v149 = nil
    local v150 = nil
    local v151 = nil
    local v152 = v131.Name
    if v152 == "XYZ" then
        v148 = v144 * v137 + v145 * v143
        v149 = v145 * v137 - v144 * v143
        v150 = v146 * v143 + v147 * v137
        v151 = v146 * v137 - v147 * v143
    elseif v152 == "YXZ" then
        v148 = v144 * v137 + v145 * v143
        v149 = v145 * v137 - v144 * v143
        v150 = v146 * v143 - v147 * v137
        v151 = v146 * v137 + v147 * v143
    elseif v152 == "ZXY" then
        v148 = v144 * v137 - v145 * v143
        v149 = v145 * v137 + v144 * v143
        v150 = v146 * v143 + v147 * v137
        v151 = v146 * v137 - v147 * v143
    elseif v152 == "ZYX" then
        v148 = v144 * v137 - v145 * v143
        v149 = v145 * v137 + v144 * v143
        v150 = v146 * v143 - v147 * v137
        v151 = v146 * v137 + v147 * v143
    elseif v152 == "YZX" then
        v148 = v144 * v137 + v145 * v143
        v149 = v145 * v137 + v144 * v143
        v150 = v146 * v143 - v147 * v137
        v151 = v146 * v137 - v147 * v143
    elseif v152 == "XZY" then
        v148 = v144 * v137 - v145 * v143
        v149 = v145 * v137 - v144 * v143
        v150 = v146 * v143 + v147 * v137
        v151 = v146 * v137 + v147 * v143
    end
    return v_u_8(v148, v149, v150, v151)
end
function v_u_1.fromVector(p153, p154)
    return v_u_8(p153.X, p153.Y, p153.Z, p154 or 0)
end
function v_u_1.RandomQuaternion(p155)
    local v_u_156 = Random.new(p155 or 1)
    local v_u_157 = math.sqrt
    local v_u_158 = math.sin
    local v_u_159 = math.cos
    return function()
        local v160 = v_u_156:NextNumber(0, 1)
        local v161 = v_u_156:NextNumber(0, 1)
        local v162 = v_u_156:NextNumber(0, 1)
        local v163 = 1 - v160
        local v164 = v_u_157(v160)
        local v165 = v_u_157(v163)
        local v166 = 6.283185307179586 * v161
        local v167 = 6.283185307179586 * v162
        return v_u_8(v165 * v_u_158(v166), v165 * v_u_159(v166), v164 * v_u_158(v167), v164 * v_u_159(v167))
    end
end
local function v170(p168, p169)
    return v_u_8(p168.X + p169.X, p168.Y + p169.Y, p168.Z + p169.Z, p168.W + p169.W)
end
v_u_1.__add = v170
v_u_1.Add = v170
local function v173(p171, p172)
    return v_u_8(p171.X - p172.X, p171.Y - p172.Y, p171.Z - p172.Z, p171.W - p172.W)
end
v_u_1.__sub = v173
v_u_1.Sub = v173
local function v_u_184(p174, p175)
    local v176 = p174.X
    local v177 = p174.Y
    local v178 = p174.Z
    local v179 = p174.W
    local v180 = p175.X
    local v181 = p175.Y
    local v182 = p175.Z
    local v183 = p175.W
    return v_u_8(v179 * v180 + v176 * v183 + v177 * v182 - v178 * v181, v179 * v181 - v176 * v182 + v177 * v183 + v178 * v180, v179 * v182 + v176 * v181 - v177 * v180 + v178 * v183, v179 * v183 - v176 * v180 - v177 * v181 - v178 * v182)
end
v_u_1.__mul = v_u_184
v_u_1.Mul = v_u_184
function v_u_1.Scale(p185, p186)
    return v_u_8(p185.X * p186, p185.Y * p186, p185.Z * p186, p185.W * p186)
end
function v_u_1.MulCFrameR(p187, p188)
    return p187:ToCFrame() * p188
end
function v_u_1.MulCFrameL(p189, p190)
    return p190 * p189:ToCFrame()
end
function v_u_1.RotateVector(p191, p192)
    return v_u_184(p191 * v_u_8(p192.X, p192.Y, p192.Z, 0), p191:Conjugate()):Vector()
end
function v_u_1.CombineImaginary(p193, p194)
    return v_u_184(v_u_8(p194.X, p194.Y, p194.Z, 0), p193)
end
local function v197(p195, p196)
    return v_u_184(p195, p196:Inverse())
end
v_u_1.__div = v197
v_u_1.Div = v197
function v_u_1.ScaleInv(p198, p199)
    return v_u_8(p198.X / p199, p198.Y / p199, p198.Z / p199, p198.W / p199)
end
local function v201(p200)
    return v_u_8(-p200.X, -p200.Y, -p200.Z, -p200.W)
end
v_u_1.__unm = v201
v_u_1.Unm = v201
v_u_1.Negate = v201
local function v_u_223(p202, p203)
    if p203 == -1 then
        return p202:Inverse()
    end
    local v204 = p202.W
    local v205 = p202.X
    local v206 = p202.Y
    local v207 = p202.Z
    local v208 = v205 * v205 + v206 * v206 + v207 * v207
    local v209 = v204 * v204 + v208
    local v210 = math.sqrt(v209)
    local v211 = math.sqrt(v208)
    local v212 = v210 ^ p203
    if v211 <= v210 * 5e-7 then
        return v_u_1.new(0, 0, 0, v212)
    end
    local v213 = v205 / v211
    local v214 = v206 / v211
    local v215 = v207 / v211
    local v216 = p203 * math.atan2(v211, v204)
    local v217 = math.cos(v216)
    local v218 = v212 * math.sin(v216)
    local v219 = v212 * v217
    local v220 = v218 * v213
    local v221 = v218 * v214
    local v222 = v218 * v215
    return v_u_1.new(v220, v221, v222, v219)
end
v_u_1.__pow = v_u_223
v_u_1.Pow = v_u_223
local function v233(p224, p225)
    local v226
    if p224 == nil then
        v226 = "nil"
    else
        local v227 = getmetatable(p224)
        if type(v227) == "table" and v227._type ~= nil then
            local v228 = v227._type
            v226 = tostring(v228)
        else
            v226 = typeof(p224)
        end
    end
    local v229
    if p225 == nil then
        v229 = "nil"
    else
        local v230 = getmetatable(p225)
        if type(v230) == "table" and v230._type ~= nil then
            local v231 = v230._type
            v229 = tostring(v231)
        else
            v229 = typeof(p225)
        end
    end
    if v226 ~= "Quaternion" or v229 ~= v226 then
        return false
    end
    local v232
    if p224.X == p225.X and (p224.Y == p225.Y and p224.Z == p225.Z) then
        v232 = p224.W == p225.W
    else
        v232 = false
    end
    return v232
end
v_u_1.__eq = v233
v_u_1.Eq = v233
local function v236(p234, p235)
    return p234:Length() < p235:Length()
end
v_u_1.__lt = v236
v_u_1.Lt = v236
local function v239(p237, p238)
    return p237:Length() <= p238:Length()
end
v_u_1.__le = v239
v_u_1.Le = v239
local function v_u_249(p240)
    local v241 = p240.X
    local v242 = p240.Y
    local v243 = p240.Z
    local v244 = p240.W
    local v245 = math.exp(v244)
    local v246 = v241 * v241 + v242 * v242 + v243 * v243
    if v246 <= 0 then
        return v_u_8(0, 0, 0, v245)
    end
    local v247 = v246 ^ 0.5
    local v248 = v245 * math.sin(v247) / v247
    return v_u_8(v241 * v248, v242 * v248, v243 * v248, v245 * math.cos(v247))
end
v_u_1.Exp = v_u_249
function v_u_1.ExpMap(p250, p251)
    return v_u_184(p250, (v_u_249(p251)))
end
function v_u_1.ExpMapSym(p252, p253)
    local v254 = v_u_223(p252, 0.5)
    return v_u_184(v_u_184(v254, (v_u_249(p253))), v254)
end
local function v_u_265(p255)
    local v256 = p255.X
    local v257 = p255.Y
    local v258 = p255.Z
    local v259 = p255.W
    local v260 = v256 * v256 + v257 * v257 + v258 * v258
    local v261 = v259 * v259 + v260
    if v261 <= 0 then
        return v_u_8(0, 0, 0, (-1 / 0))
    end
    if v260 <= 0 then
        return v_u_8(0, 0, 0, math.log(v261) / 2)
    end
    local v262 = v261 ^ 0.5
    local v263 = v259 / v262
    local v264 = math.acos(v263) / v260 ^ 0.5
    return v_u_8(v256 * v264, v257 * v264, v258 * v264, (math.log(v262)))
end
v_u_1.Log = v_u_265
function v_u_1.LogMap(p266, p267)
    return v_u_265((v_u_184(p266:Inverse(), p267)))
end
function v_u_1.LogMapSym(p268, p269)
    local v270 = v_u_223(p268, -0.5)
    return v_u_265((v_u_184(v_u_184(v270, p269), v270)))
end
local function v276(p271)
    local v272 = p271.X
    local v273 = p271.Y
    local v274 = p271.Z
    local v275 = p271.W
    return (v272 * v272 + v273 * v273 + v274 * v274 + v275 * v275) ^ 0.5
end
v_u_1.Length = v276
v_u_1.__len = v276
function v_u_1.LengthSquared(p277)
    local v278 = p277.X
    local v279 = p277.Y
    local v280 = p277.Z
    local v281 = p277.W
    return v278 * v278 + v279 * v279 + v280 * v280 + v281 * v281
end
function v_u_1.Hypot(p282)
    local v283 = p282.X
    local v284 = p282.Y
    local v285 = p282.Z
    local v286 = p282.W
    local v287 = math.max(v283, v284, v285, v286)
    if v287 <= 0 then
        return 0
    end
    local v288 = v_u_8(p282.X / v287, p282.Y / v287, p282.Z / v287, p282.W / v287)
    local v289 = v288.X
    local v290 = v288.Y
    local v291 = v288.Z
    local v292 = v288.W
    return (v289 * v289 + v290 * v290 + v291 * v291 + v292 * v292) ^ 0.5 * v287
end
function v_u_1.Normalize(p293)
    local v294 = p293.X
    local v295 = p293.Y
    local v296 = p293.Z
    local v297 = p293.W
    local v298 = (v294 * v294 + v295 * v295 + v296 * v296 + v297 * v297) ^ 0.5
    if v298 > 0 then
        return v_u_8(p293.X / v298, p293.Y / v298, p293.Z / v298, p293.W / v298)
    else
        return v_u_1.identity
    end
end
function v_u_1.IsUnit(p299, p300)
    local v301 = p299.X
    local v302 = p299.Y
    local v303 = p299.Z
    local v304 = p299.W
    local v305 = 1 - (v301 * v301 + v302 * v302 + v303 * v303 + v304 * v304) ^ 0.5
    return (p300 or 5e-7) > math.abs(v305)
end
function v_u_1.ToCFrame(p306, p307)
    local v308 = p306.X
    local v309 = p306.Y
    local v310 = p306.Z
    local v311 = p306.W
    local v312 = (v308 * v308 + v309 * v309 + v310 * v310 + v311 * v311) ^ 0.5
    local v313
    if v312 > 0 then
        v313 = v_u_8(p306.X / v312, p306.Y / v312, p306.Z / v312, p306.W / v312)
    else
        v313 = v_u_1.identity
    end
    local v314 = p307 or Vector3.new()
    return CFrame.new(v314.X, v314.Y, v314.Z, v313.X, v313.Y, v313.Z, v313.W)
end
function v_u_1.Dot(p315, p316)
    return p315.X * p316.X + p315.Y * p316.Y + p315.Z * p316.Z + p315.W * p316.W
end
function v_u_1.Conjugate(p317)
    return v_u_8(-p317.X, -p317.Y, -p317.Z, p317.W)
end
function v_u_1.Inverse(p318)
    local v319 = p318.X
    local v320 = p318.Y
    local v321 = p318.Z
    local v322 = p318.W
    local v323 = v319 * v319 + v320 * v320 + v321 * v321 + v322 * v322
    return v_u_8(-p318.X / v323, -p318.Y / v323, -p318.Z / v323, p318.W / v323)
end
local function v325(p324)
    return v_u_8(-p324.X, -p324.Y, -p324.Z, -p324.W)
end
v_u_1.Negate = v325
v_u_1.__unm = v325
function v_u_1.Difference(p326, p327)
    if p326.X * p327.X + p326.Y * p327.Y + p326.Z * p327.Z + p326.W * p327.W < 0 then
        p326 = v_u_8(-p326.X, -p326.Y, -p326.Z, -p326.W)
    end
    local v328 = v_u_184
    local v329 = p326.X
    local v330 = p326.Y
    local v331 = p326.Z
    local v332 = p326.W
    local v333 = v329 * v329 + v330 * v330 + v331 * v331 + v332 * v332
    return v328(v_u_8(-p326.X / v333, -p326.Y / v333, -p326.Z / v333, p326.W / v333), p327)
end
function v_u_1.Distance(p334, p335)
    local v336 = v_u_265((v_u_184(p334:Inverse(), p335)))
    local v337 = v336.X
    local v338 = v336.Y
    local v339 = v336.Z
    local v340 = v336.W
    return (v337 * v337 + v338 * v338 + v339 * v339 + v340 * v340) ^ 0.5 * 2
end
function v_u_1.DistanceSym(p341, p342)
    local v343 = v_u_265
    if p341.X * p342.X + p341.Y * p342.Y + p341.Z * p342.Z + p341.W * p342.W < 0 then
        p341 = v_u_8(-p341.X, -p341.Y, -p341.Z, -p341.W)
    end
    local v344 = v_u_184
    local v345 = p341.X
    local v346 = p341.Y
    local v347 = p341.Z
    local v348 = p341.W
    local v349 = v345 * v345 + v346 * v346 + v347 * v347 + v348 * v348
    local v350 = v343((v344(v_u_8(-p341.X / v349, -p341.Y / v349, -p341.Z / v349, p341.W / v349), p342)))
    local v351 = v350.X
    local v352 = v350.Y
    local v353 = v350.Z
    local v354 = v350.W
    return (v351 * v351 + v352 * v352 + v353 * v353 + v354 * v354) ^ 0.5 * 2
end
function v_u_1.DistanceChord(p355, p356)
    local v357 = v_u_265
    if p355.X * p356.X + p355.Y * p356.Y + p355.Z * p356.Z + p355.W * p356.W < 0 then
        p355 = v_u_8(-p355.X, -p355.Y, -p355.Z, -p355.W)
    end
    local v358 = v_u_184
    local v359 = p355.X
    local v360 = p355.Y
    local v361 = p355.Z
    local v362 = p355.W
    local v363 = v359 * v359 + v360 * v360 + v361 * v361 + v362 * v362
    local v364 = v357((v358(v_u_8(-p355.X / v363, -p355.Y / v363, -p355.Z / v363, p355.W / v363), p356)))
    local v365 = v364.X
    local v366 = v364.Y
    local v367 = v364.Z
    local v368 = v364.W
    local v369 = (v365 * v365 + v366 * v366 + v367 * v367 + v368 * v368) ^ 0.5 * 2 / 2
    return math.sin(v369) * 2
end
function v_u_1.DistanceAbs(p370, p371)
    local v372 = v_u_8(p370.X - p371.X, p370.Y - p371.Y, p370.Z - p371.Z, p370.W - p371.W)
    local v373 = v_u_8(p370.X + p371.X, p370.Y + p371.Y, p370.Z + p371.Z, p370.W + p371.W)
    local v374 = v372.X
    local v375 = v372.Y
    local v376 = v372.Z
    local v377 = v372.W
    local v378 = (v374 * v374 + v375 * v375 + v376 * v376 + v377 * v377) ^ 0.5
    local v379 = v373.X
    local v380 = v373.Y
    local v381 = v373.Z
    local v382 = v373.W
    local v383 = (v379 * v379 + v380 * v380 + v381 * v381 + v382 * v382) ^ 0.5
    if v378 < v383 then
        return v378
    else
        return v383
    end
end
function v_u_1.Slerp(p384, p385, p386)
    local v387 = p384.X
    local v388 = p384.Y
    local v389 = p384.Z
    local v390 = p384.W
    local v391 = (v387 * v387 + v388 * v388 + v389 * v389 + v390 * v390) ^ 0.5
    local v392
    if v391 > 0 then
        v392 = v_u_8(p384.X / v391, p384.Y / v391, p384.Z / v391, p384.W / v391)
    else
        v392 = v_u_1.identity
    end
    local v393 = p385.X
    local v394 = p385.Y
    local v395 = p385.Z
    local v396 = p385.W
    local v397 = (v393 * v393 + v394 * v394 + v395 * v395 + v396 * v396) ^ 0.5
    local v398
    if v397 > 0 then
        v398 = v_u_8(p385.X / v397, p385.Y / v397, p385.Z / v397, p385.W / v397)
    else
        v398 = v_u_1.identity
    end
    local v399 = v392.X * v398.X + v392.Y * v398.Y + v392.Z * v398.Z + v392.W * v398.W
    if v399 < 0 then
        v392 = v_u_8(-v392.X, -v392.Y, -v392.Z, -v392.W)
        v399 = -v399
    end
    if v399 >= 1 then
        local v400 = v_u_8(v398.X - v392.X, v398.Y - v392.Y, v398.Z - v392.Z, v398.W - v392.W)
        local v401 = v_u_8(v400.X * p386, v400.Y * p386, v400.Z * p386, v400.W * p386)
        local v402 = v_u_8(v392.X + v401.X, v392.Y + v401.Y, v392.Z + v401.Z, v392.W + v401.W)
        local v403 = v402.X
        local v404 = v402.Y
        local v405 = v402.Z
        local v406 = v402.W
        local v407 = (v403 * v403 + v404 * v404 + v405 * v405 + v406 * v406) ^ 0.5
        if v407 > 0 then
            return v_u_8(v402.X / v407, v402.Y / v407, v402.Z / v407, v402.W / v407)
        else
            return v_u_1.identity
        end
    else
        local v408 = math.acos(v399)
        local v409 = math.sin(v408)
        local v410 = v408 * p386
        local v411 = math.sin(v410)
        local v412 = math.cos(v410) - v399 * v411 / v409
        local v413 = v411 / v409
        local v414 = v_u_8(v392.X * v412, v392.Y * v412, v392.Z * v412, v392.W * v412)
        local v415 = v_u_8(v398.X * v413, v398.Y * v413, v398.Z * v413, v398.W * v413)
        local v416 = v_u_8(v414.X + v415.X, v414.Y + v415.Y, v414.Z + v415.Z, v414.W + v415.W)
        local v417 = v416.X
        local v418 = v416.Y
        local v419 = v416.Z
        local v420 = v416.W
        local v421 = (v417 * v417 + v418 * v418 + v419 * v419 + v420 * v420) ^ 0.5
        if v421 > 0 then
            return v_u_8(v416.X / v421, v416.Y / v421, v416.Z / v421, v416.W / v421)
        else
            return v_u_1.identity
        end
    end
end
function v_u_1.IdentitySlerp(p422, p423)
    if p422.W < 0 then
        return -v_u_223(-p422, p423)
    else
        return v_u_223(p422, p423)
    end
end
local function v_u_469(p424, p425)
    local v426 = p424
    local v427 = v426.X
    local v428 = v426.Y
    local v429 = v426.Z
    local v430 = v426.W
    local v431 = (v427 * v427 + v428 * v428 + v429 * v429 + v430 * v430) ^ 0.5
    local v_u_432
    if v431 > 0 then
        v_u_432 = v_u_8(v426.X / v431, v426.Y / v431, v426.Z / v431, v426.W / v431)
    else
        v_u_432 = v_u_1.identity
    end
    local v433 = p425
    local v434 = v433.X
    local v435 = v433.Y
    local v436 = v433.Z
    local v437 = v433.W
    local v438 = (v434 * v434 + v435 * v435 + v436 * v436 + v437 * v437) ^ 0.5
    local v_u_439
    if v438 > 0 then
        v_u_439 = v_u_8(v433.X / v438, v433.Y / v438, v433.Z / v438, v433.W / v438)
    else
        v_u_439 = v_u_1.identity
    end
    local v_u_440 = v_u_432.X * v_u_439.X + v_u_432.Y * v_u_439.Y + v_u_432.Z * v_u_439.Z + v_u_432.W * v_u_439.W
    if v_u_440 < 0 then
        v_u_432 = v_u_8(-v_u_432.X, -v_u_432.Y, -v_u_432.Z, -v_u_432.W)
        v_u_440 = -v_u_440
    end
    if v_u_440 >= 1 then
        local v_u_441 = v_u_8(v_u_439.X - v_u_432.X, v_u_439.Y - v_u_432.Y, v_u_439.Z - v_u_432.Z, v_u_439.W - v_u_432.W)
        return function(p442)
            local v443 = v_u_432
            local v444 = v_u_441
            local v445 = v_u_8(v444.X * p442, v444.Y * p442, v444.Z * p442, v444.W * p442)
            local v446 = v_u_8(v443.X + v445.X, v443.Y + v445.Y, v443.Z + v445.Z, v443.W + v445.W)
            local v447 = v446.X
            local v448 = v446.Y
            local v449 = v446.Z
            local v450 = v446.W
            local v451 = (v447 * v447 + v448 * v448 + v449 * v449 + v450 * v450) ^ 0.5
            if v451 > 0 then
                return v_u_8(v446.X / v451, v446.Y / v451, v446.Z / v451, v446.W / v451)
            else
                return v_u_1.identity
            end
        end
    end
    local v_u_452 = math.acos(v_u_440)
    local v_u_453 = math.sin(v_u_452)
    return function(p454)
        local v455 = v_u_452 * p454
        local v456 = math.sin(v455)
        local v457 = math.cos(v455) - v_u_440 * v456 / v_u_453
        local v458 = v456 / v_u_453
        local v459 = v_u_432
        local v460 = v_u_8(v459.X * v457, v459.Y * v457, v459.Z * v457, v459.W * v457)
        local v461 = v_u_439
        local v462 = v_u_8(v461.X * v458, v461.Y * v458, v461.Z * v458, v461.W * v458)
        local v463 = v_u_8(v460.X + v462.X, v460.Y + v462.Y, v460.Z + v462.Z, v460.W + v462.W)
        local v464 = v463.X
        local v465 = v463.Y
        local v466 = v463.Z
        local v467 = v463.W
        local v468 = (v464 * v464 + v465 * v465 + v466 * v466 + v467 * v467) ^ 0.5
        if v468 > 0 then
            return v_u_8(v463.X / v468, v463.Y / v468, v463.Z / v468, v463.W / v468)
        else
            return v_u_1.identity
        end
    end
end
v_u_1.SlerpFunction = v_u_469
function v_u_1.Intermediates(p470, p471, p472, p473)
    local v474 = p473 or false
    local v475 = 1 / (p472 + 1)
    local v476 = v_u_469(p470, p471)
    local v477 = v474 and { p470 } or {}
    for v478 = 1, p472 do
        local v479 = v476(v475 * v478)
        table.insert(v477, v479)
    end
    if v474 then
        table.insert(v477, p471)
    end
    return v477
end
function v_u_1.Derivative(p480, p481)
    return v_u_184(v_u_8(p480.X * 0.5, p480.Y * 0.5, p480.Z * 0.5, p480.W * 0.5), (v_u_8(p481.X, p481.Y, p481.Z, 0)))
end
function v_u_1.Integrate(p482, p483, p484)
    local v485 = p482.X
    local v486 = p482.Y
    local v487 = p482.Z
    local v488 = p482.W
    local v489 = (v485 * v485 + v486 * v486 + v487 * v487 + v488 * v488) ^ 0.5
    local v490
    if v489 > 0 then
        v490 = v_u_8(p482.X / v489, p482.Y / v489, p482.Z / v489, p482.W / v489)
    else
        v490 = v_u_1.identity
    end
    local v491 = p483 * p484
    local v492 = v491.Magnitude
    if v492 > 0 then
        local v493 = v491 / v492
        local v494 = v493.Magnitude <= 5e-7 and Vector3.new(1, 0, 0) or v493.Unit
        local v495 = v492 / 2
        local v496 = math.sin(v495)
        local v497 = v_u_184(v490, (v_u_8(v496 * v494.X, v496 * v494.Y, v496 * v494.Z, (math.cos(v495)))))
        local v498 = v497.X
        local v499 = v497.Y
        local v500 = v497.Z
        local v501 = v497.W
        local v502 = (v498 * v498 + v499 * v499 + v500 * v500 + v501 * v501) ^ 0.5
        if v502 > 0 then
            return v_u_8(v497.X / v502, v497.Y / v502, v497.Z / v502, v497.W / v502)
        else
            return v_u_1.identity
        end
    else
        return v490
    end
end
function v_u_1.AngularVelocity(p503, p504, p505)
    if p505 > 0 then
        return p503:Difference(p504):ToEulerVector() / p505
    else
        return Vector3.new()
    end
end
function v_u_1.MinimalRotation(p506, p507)
    local _, v508, _ = p506:ToMatrixVectors()
    local _, v509, _ = p507:ToMatrixVectors()
    local v510 = v508:Cross(v509)
    local v511 = v510.Magnitude
    local v512 = v508:Dot(v509)
    local v513 = math.atan2(v511, v512)
    local v514 = v510.Magnitude <= 5e-7 and Vector3.new(1, 0, 0) or v510.Unit
    local v515 = v513 / 2
    local v516 = math.sin(v515)
    return v_u_8(v516 * v514.X, v516 * v514.Y, v516 * v514.Z, (math.cos(v515)))
end
function v_u_1.ApproxEq(p517, p518, p519)
    local v520 = p519 or 5e-7
    local v521 = v_u_265
    if p517.X * p518.X + p517.Y * p518.Y + p517.Z * p518.Z + p517.W * p518.W < 0 then
        p517 = v_u_8(-p517.X, -p517.Y, -p517.Z, -p517.W)
    end
    local v522 = v_u_184
    local v523 = p517.X
    local v524 = p517.Y
    local v525 = p517.Z
    local v526 = p517.W
    local v527 = v523 * v523 + v524 * v524 + v525 * v525 + v526 * v526
    local v528 = v521((v522(v_u_8(-p517.X / v527, -p517.Y / v527, -p517.Z / v527, p517.W / v527), p518)))
    local v529 = v528.X
    local v530 = v528.Y
    local v531 = v528.Z
    local v532 = v528.W
    return (v529 * v529 + v530 * v530 + v531 * v531 + v532 * v532) ^ 0.5 * 2 < v520
end
function v_u_1.IsNaN(p533)
    local v534 = p533.X
    local v535 = p533.Y
    local v536 = p533.Z
    local v537 = p533.W
    return (v534 ~= v534 or (v535 ~= v535 or v536 ~= v536)) and true or v537 ~= v537
end
local function v_u_567(p538)
    local v539 = p538.X
    local v540 = p538.Y
    local v541 = p538.Z
    local v542 = p538.W
    local v543 = (v539 * v539 + v540 * v540 + v541 * v541 + v542 * v542) ^ 0.5
    local v544
    if v543 > 0 then
        v544 = v_u_8(p538.X / v543, p538.Y / v543, p538.Z / v543, p538.W / v543)
    else
        v544 = v_u_1.identity
    end
    local v545 = v544.X
    local v546 = v544.Y
    local v547 = v544.Z
    local v548 = v544.W
    local v549 = v545 * v545
    local v550 = v546 * v546
    local v551 = v547 * v547
    local v552 = v548 * v548
    local v553 = v549 - v550 - v551 + v552
    local v554 = -v549 + v550 - v551 + v552
    local v555 = -v549 - v550 + v551 + v552
    local v556 = v545 * v546
    local v557 = v547 * v548
    local v558 = 2 * (v556 + v557)
    local v559 = 2 * (v556 - v557)
    local v560 = v545 * v547
    local v561 = v546 * v548
    local v562 = 2 * (v560 - v561)
    local v563 = 2 * (v560 + v561)
    local v564 = v546 * v547
    local v565 = v545 * v548
    local v566 = 2 * (v564 + v565)
    return v553, v559, v563, v558, v554, 2 * (v564 - v565), v562, v566, v555
end
function v_u_1.ToAxisAngle(p568)
    local v569 = p568.X
    local v570 = p568.Y
    local v571 = p568.Z
    local v572 = p568.W
    local v573 = (v569 * v569 + v570 * v570 + v571 * v571 + v572 * v572) ^ 0.5
    local v574
    if v573 > 0 then
        v574 = v_u_8(p568.X / v573, p568.Y / v573, p568.Z / v573, p568.W / v573)
    else
        v574 = v_u_1.identity
    end
    local v575 = v574.X
    local v576 = v574.Y
    local v577 = v574.Z
    local v578 = v574.W
    local v579 = math.acos(v578) * 2
    local v580 = 1 - v578 * v578
    local v581 = math.sqrt(v580)
    if v581 < 5e-7 then
        return Vector3.new(v575, v576, v577), v579
    end
    local v582 = v575 / v581
    local v583 = v576 / v581
    local v584 = v577 / v581
    return Vector3.new(v582, v583, v584), v579
end
function v_u_1.ToEulerVector(p585)
    local v586 = p585.X
    local v587 = p585.Y
    local v588 = p585.Z
    local v589 = p585.W
    local v590 = (v586 * v586 + v587 * v587 + v588 * v588 + v589 * v589) ^ 0.5
    local v591
    if v590 > 0 then
        v591 = v_u_8(p585.X / v590, p585.Y / v590, p585.Z / v590, p585.W / v590)
    else
        v591 = v_u_1.identity
    end
    local v592 = v591.X
    local v593 = v591.Y
    local v594 = v591.Z
    local v595 = v591.W
    local v596 = math.acos(v595) * 2
    local v597 = 1 - v595 * v595
    local v598 = math.sqrt(v597)
    if v598 < 5e-7 then
        return Vector3.new(v592, v593, v594) * v596
    end
    local v599 = v592 / v598
    local v600 = v593 / v598
    local v601 = v594 / v598
    return Vector3.new(v599, v600, v601) * v596
end
function v_u_1.ToMatrix(p602)
    return v_u_567(p602)
end
function v_u_1.ToMatrixVectors(p603)
    local v604, v605, v606, v607, v608, v609, v610, v611, v612 = v_u_567(p603)
    return Vector3.new(v604, v607, v610), Vector3.new(v605, v608, v611), Vector3.new(v606, v609, v612)
end
function v_u_1.Vector(p613)
    local v614 = p613.X
    local v615 = p613.Y
    local v616 = p613.Z
    return Vector3.new(v614, v615, v616)
end
function v_u_1.Real(p617)
    return v_u_8(0, 0, 0, p617.W)
end
function v_u_1.Imaginary(p618)
    return v_u_8(p618.X, p618.Y, p618.Z, 0)
end
local function v640(p619)
    local v620 = p619.X
    local v621 = p619.Y
    local v622 = p619.Z
    local v623 = p619.W
    local v624 = (v620 * v620 + v621 * v621 + v622 * v622 + v623 * v623) ^ 0.5
    local v625
    if v624 > 0 then
        v625 = v_u_8(p619.X / v624, p619.Y / v624, p619.Z / v624, p619.W / v624)
    else
        v625 = v_u_1.identity
    end
    local v626 = v625.X
    local v627 = v625.Y
    local v628 = v625.Z
    local v629 = v625.W
    local v630 = v627 * v629 + v626 * v628
    if math.abs(v630) > 0.4999995 then
        local v631 = v630 > 0 and 1 or -1
        return v631 * 2 * math.atan2(v628, v629), v631 * 3.141592653589793 / 2, 0
    end
    local v632 = v627 * v627
    local v633 = 2 * (v626 * v629 - v627 * v628)
    local v634 = 1 - 2 * (v626 * v626 + v632)
    local v635 = math.atan2(v633, v634)
    local v636 = 2 * v630
    local v637 = math.asin(v636)
    local v638 = 2 * (v628 * v629 - v626 * v627)
    local v639 = 1 - 2 * (v628 * v628 + v632)
    return v635, v637, math.atan2(v638, v639)
end
local function v662(p641)
    local v642 = p641.X
    local v643 = p641.Y
    local v644 = p641.Z
    local v645 = p641.W
    local v646 = (v642 * v642 + v643 * v643 + v644 * v644 + v645 * v645) ^ 0.5
    local v647
    if v646 > 0 then
        v647 = v_u_8(p641.X / v646, p641.Y / v646, p641.Z / v646, p641.W / v646)
    else
        v647 = v_u_1.identity
    end
    local v648 = v647.X
    local v649 = v647.Y
    local v650 = v647.Z
    local v651 = v647.W
    local v652 = v648 * v651 - v649 * v650
    if math.abs(v652) > 0.4999995 then
        local v653 = v652 >= 0 and 1 or -1
        return v653 * 3.141592653589793 / 2, v653 * 2 * -math.atan2(v650, v651), 0
    end
    local v654 = v648 * v648
    local v655 = 2 * v652
    local v656 = math.asin(v655)
    local v657 = 2 * (v648 * v650 + v649 * v651)
    local v658 = 1 - 2 * (v649 * v649 + v654)
    local v659 = math.atan2(v657, v658)
    local v660 = 2 * (v648 * v649 + v650 * v651)
    local v661 = 1 - 2 * (v650 * v650 + v654)
    return v656, v659, math.atan2(v660, v661)
end
local v_u_747 = {
    ["XYZ"] = v640,
    ["XZY"] = function(p663)
        local v664 = p663.X
        local v665 = p663.Y
        local v666 = p663.Z
        local v667 = p663.W
        local v668 = (v664 * v664 + v665 * v665 + v666 * v666 + v667 * v667) ^ 0.5
        local v669
        if v668 > 0 then
            v669 = v_u_8(p663.X / v668, p663.Y / v668, p663.Z / v668, p663.W / v668)
        else
            v669 = v_u_1.identity
        end
        local v670 = v669.X
        local v671 = v669.Y
        local v672 = v669.Z
        local v673 = v669.W
        local v674 = v672 * v673 - v670 * v671
        if math.abs(v674) > 0.4999995 then
            local v675 = v674 >= 0 and 1 or -1
            return v675 * 2 * -math.atan2(v671, v673), 0, v675 * 3.141592653589793 / 2
        end
        local v676 = v672 * v672
        local v677 = 2 * (v670 * v673 + v671 * v672)
        local v678 = 1 - 2 * (v670 * v670 + v676)
        local v679 = math.atan2(v677, v678)
        local v680 = 2 * (v670 * v672 + v671 * v673)
        local v681 = 1 - 2 * (v671 * v671 + v676)
        local v682 = math.atan2(v680, v681)
        local v683 = 2 * v674
        return v679, v682, math.asin(v683)
    end,
    ["YZX"] = function(p684)
        local v685 = p684.X
        local v686 = p684.Y
        local v687 = p684.Z
        local v688 = p684.W
        local v689 = (v685 * v685 + v686 * v686 + v687 * v687 + v688 * v688) ^ 0.5
        local v690
        if v689 > 0 then
            v690 = v_u_8(p684.X / v689, p684.Y / v689, p684.Z / v689, p684.W / v689)
        else
            v690 = v_u_1.identity
        end
        local v691 = v690.X
        local v692 = v690.Y
        local v693 = v690.Z
        local v694 = v690.W
        local v695 = v693 * v694 + v691 * v692
        if math.abs(v695) > 0.4999995 then
            local v696 = v695 >= 0 and 1 or -1
            return 0, v696 * 2 * math.atan2(v691, v694), v696 * 3.141592653589793 / 2
        end
        local v697 = v693 * v693
        local v698 = 2 * (v691 * v694 - v692 * v693)
        local v699 = 1 - 2 * (v691 * v691 + v697)
        local v700 = math.atan2(v698, v699)
        local v701 = 2 * (v692 * v694 - v691 * v693)
        local v702 = 1 - 2 * (v692 * v692 + v697)
        local v703 = math.atan2(v701, v702)
        local v704 = 2 * v695
        return v700, v703, math.asin(v704)
    end,
    ["YXZ"] = v662,
    ["ZXY"] = function(p705)
        local v706 = p705.X
        local v707 = p705.Y
        local v708 = p705.Z
        local v709 = p705.W
        local v710 = (v706 * v706 + v707 * v707 + v708 * v708 + v709 * v709) ^ 0.5
        local v711
        if v710 > 0 then
            v711 = v_u_8(p705.X / v710, p705.Y / v710, p705.Z / v710, p705.W / v710)
        else
            v711 = v_u_1.identity
        end
        local v712 = v711.X
        local v713 = v711.Y
        local v714 = v711.Z
        local v715 = v711.W
        local v716 = v712 * v715 + v713 * v714
        if math.abs(v716) > 0.4999995 then
            local v717 = v716 >= 0 and 1 or -1
            return v717 * 3.141592653589793 / 2, 0, v717 * 2 * math.atan2(v713, v715)
        end
        local v718 = v712 * v712
        local v719 = 2 * v716
        local v720 = math.asin(v719)
        local v721 = 2 * (v713 * v715 - v712 * v714)
        local v722 = 1 - 2 * (v713 * v713 + v718)
        local v723 = math.atan2(v721, v722)
        local v724 = 2 * (v714 * v715 - v712 * v713)
        local v725 = 1 - 2 * (v714 * v714 + v718)
        return v720, v723, math.atan2(v724, v725)
    end,
    ["ZYX"] = function(p726)
        local v727 = p726.X
        local v728 = p726.Y
        local v729 = p726.Z
        local v730 = p726.W
        local v731 = (v727 * v727 + v728 * v728 + v729 * v729 + v730 * v730) ^ 0.5
        local v732
        if v731 > 0 then
            v732 = v_u_8(p726.X / v731, p726.Y / v731, p726.Z / v731, p726.W / v731)
        else
            v732 = v_u_1.identity
        end
        local v733 = v732.X
        local v734 = v732.Y
        local v735 = v732.Z
        local v736 = v732.W
        local v737 = v734 * v736 - v733 * v735
        if math.abs(v737) > 0.4999995 then
            local v738 = v737 >= 0 and 1 or -1
            return 0, v738 * 3.141592653589793 / 2, v738 * 2 * -math.atan2(v733, v736)
        end
        local v739 = v734 * v734
        local v740 = 2 * (v733 * v736 + v734 * v735)
        local v741 = 1 - 2 * (v733 * v733 + v739)
        local v742 = math.atan2(v740, v741)
        local v743 = 2 * v737
        local v744 = math.asin(v743)
        local v745 = 2 * (v733 * v734 + v735 * v736)
        local v746 = 1 - 2 * (v735 * v735 + v739)
        return v742, v744, math.atan2(v745, v746)
    end
}
function v_u_1.ToEulerAngles(p748, p749)
    return v_u_747[(p749 or Enum.RotationOrder.XYZ).Name](p748)
end
v_u_1.ToEulerAnglesXYZ = v640
v_u_1.ToEulerAnglesYXZ = v662
v_u_1.ToOrientation = v662
local function v751(p750)
    return p750.X, p750.Y, p750.Z, p750.W
end
v_u_1.GetComponents = v751
v_u_1.components = v751
local function v773(p752, p753)
    if v_u_1._TO_STRING_CHAR then
        p753 = v_u_1._TO_STRING_CHAR
    end
    local v754 = p752.X
    local v755
    if p753 then
        local v756 = math.max(0, p753)
        local v757 = string.format("%%.%df", v756)
        v755 = string.format(v757, v754)
    else
        v755 = tostring(v754)
    end
    local v758 = ", "
    local v759 = p752.Y
    local v760
    if p753 then
        local v761 = math.max(0, p753)
        local v762 = string.format("%%.%df", v761)
        v760 = string.format(v762, v759)
    else
        v760 = tostring(v759)
    end
    local v763 = ", "
    local v764 = p752.Z
    local v765
    if p753 then
        local v766 = math.max(0, p753)
        local v767 = string.format("%%.%df", v766)
        v765 = string.format(v767, v764)
    else
        v765 = tostring(v764)
    end
    local v768 = ", "
    local v769 = p752.W
    local v770
    if p753 then
        local v771 = math.max(0, p753)
        local v772 = string.format("%%.%df", v771)
        v770 = string.format(v772, v769)
    else
        v770 = tostring(v769)
    end
    return v755 .. v758 .. v760 .. v763 .. v765 .. v768 .. v770
end
v_u_1.__tostring = v773
v_u_1.ToString = v773
function v_u_1.__index(p774, p775)
    local v776 = v_u_1[p775]
    if v776 then
        return v776
    else
        local v777 = string.lower(p775)
        local v778 = rawget(p774, "_cached")
        if v777 == "unit" then
            if v778.unit then
                return v778.unit
            end
            local v779 = p774.X
            local v780 = p774.Y
            local v781 = p774.Z
            local v782 = p774.W
            local v783 = (v779 * v779 + v780 * v780 + v781 * v781 + v782 * v782) ^ 0.5
            local v784
            if v783 > 0 then
                v784 = v_u_8(p774.X / v783, p774.Y / v783, p774.Z / v783, p774.W / v783)
            else
                v784 = v_u_1.identity
            end
            v778.unit = v784
            return v784
        else
            if v777 ~= "magnitude" then
                return nil
            end
            if v778.magnitude then
                return v778.magnitude
            end
            local v785 = p774.X
            local v786 = p774.Y
            local v787 = p774.Z
            local v788 = p774.W
            local v789 = (v785 * v785 + v786 * v786 + v787 * v787 + v788 * v788) ^ 0.5
            v778.magnitude = v789
            return v789
        end
    end
end
function v_u_1.__newindex(_, p790)
    error(tostring(p790) .. " cannot be assigned to")
end
table.freeze(v_u_1)
return v_u_1