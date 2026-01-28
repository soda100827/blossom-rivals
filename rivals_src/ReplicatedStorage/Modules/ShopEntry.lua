local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CurrencyLibrary)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14)
    local v15 = typeof(p4) == "string"
    local v16 = "Argument 1 invalid, expected a string, got " .. tostring(p4)
    assert(v15, v16)
    local v17 = typeof(p5) == "string"
    local v18 = "Argument 2 invalid, expected a string, got " .. tostring(p5)
    assert(v17, v18)
    local v19 = typeof(p6) == "table"
    local v20 = "Argument 3 invalid, expected a table, got " .. tostring(p6)
    assert(v19, v20)
    local v21 = not p7 or typeof(p7) == "table"
    local v22 = "Argument 4 invalid, expected a table or nil, got " .. tostring(p7)
    assert(v21, v22)
    local v23 = not p8 or typeof(p8) == "number"
    local v24 = "Argument 5 invalid, expected a number or nil, got " .. tostring(p8)
    assert(v23, v24)
    local v25 = not p9 or typeof(p9) == "number"
    local v26 = "Argument 6 invalid, expected a number or nil, got " .. tostring(p9)
    assert(v25, v26)
    local v27 = not p10 or typeof(p10) == "boolean"
    local v28 = "Argument 7 invalid, expected a boolean or nil, got " .. tostring(p10)
    assert(v27, v28)
    local v29 = not p11 or typeof(p11) == "number"
    local v30 = "Argument 8 invalid, expected a number or nil, got " .. tostring(p11)
    assert(v29, v30)
    local v31 = not p12 or typeof(p12) == "number"
    local v32 = "Argument 9 invalid, expected a number or nil, got " .. tostring(p12)
    assert(v31, v32)
    local v33 = not p13 or typeof(p13) == "number"
    local v34 = "Argument 10 invalid, expected a number or nil, got " .. tostring(p13)
    assert(v33, v34)
    local v35 = not p14 or typeof(p14) == "table"
    local v36 = "Argument 11 invalid, expected a table or nil, got " .. tostring(p14)
    assert(v35, v36)
    local v37 = v_u_3
    local v38 = setmetatable({}, v37)
    v38.EntryType = p4
    v38.EntryName = p5
    v38.Rewards = p6
    v38.Prices = p7 or {}
    v38.MainCurrency = nil
    v38.ProductID = p8 or nil
    v38.ProductIDTriple = p9 or nil
    v38.IsLimited = p10 or nil
    v38.PurchaseAppearTime = p11 or -1
    v38.PurchaseStartTime = p12 or -1
    v38.PurchaseDuration = p13 or (1 / 0)
    v38._temp_properties = p14
    v38:_Init()
    return v38
end
function v_u_3._Setup(p39)
    for v40 in pairs(p39.Prices) do
        local v41 = v_u_2.Info[v40] ~= nil
        local v42 = "Argument 4 invalid, expected a valid currency name, got " .. tostring(v40)
        assert(v41, v42)
        if not p39.MainCurrency or v_u_2.Info[v40].OrderIndex < v_u_2.Info[p39.MainCurrency].OrderIndex then
            p39.MainCurrency = v40
        end
    end
    local v43 = p39.MainCurrency or (p39.ProductID or p39.ProductIDTriple)
    assert(v43, "Argument 4 invalid, currency missing")
    for v44, v45 in pairs(p39._temp_properties or {}) do
        p39[v44] = v45
    end
    p39._temp_properties = nil
end
function v_u_3._Init(p46)
    p46:_Setup()
end
return v_u_3