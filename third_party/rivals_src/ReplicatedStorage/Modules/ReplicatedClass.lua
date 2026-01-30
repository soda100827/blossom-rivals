local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.EnumLibrary)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = v_u_3.IS_CLIENT and v2.LocalPlayer
if v_u_6 then
    v_u_6 = v2.LocalPlayer.PlayerScripts:WaitForChild("Modules"):WaitForChild("ClientReplicatedClasses")
end
local v_u_7 = 0
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9, p10)
    local v11 = not p9 or typeof(p9) == "table"
    local v12 = "Argument 1 invalid, expected a table or nil, got " .. tostring(p9)
    assert(v11, v12)
    v_u_7 = (v_u_7 + 1) % 1000000
    local v13 = v_u_8
    local v14 = setmetatable({}, v13)
    v14.Data = {
        ["ObjectID"] = utf8.char(v_u_7)
    }
    v14.ReplicateToClient = v_u_3.IS_SERVER and v_u_5.new() or nil
    v14.ReplicateToClientUnreliable = v_u_3.IS_SERVER and v_u_5.new() or nil
    v14._value_changed_events = {}
    v14._temp_serial = p9
    v14._dont_compress_replication = p10
    v14:_Init()
    return v14
end
function v_u_8.GetReplicatedClass(_, p15)
    local v16 = v_u_3.IS_CLIENT
    assert(v16)
    if p15 then
        p15 = v_u_6:FindFirstChild(p15, true)
    end
    return p15 and require(p15) or v_u_8
end
function v_u_8.Get(p17, p18)
    return p17.Data[p18]
end
function v_u_8.Set(p19, p20, p21)
    p19.Data[p20] = p21
end
function v_u_8.GetDataChangedSignal(p22, p23)
    local v24 = typeof(p23) == "string"
    assert(v24, "Argument 1 invalid, expected a string")
    if not p22._value_changed_events[p23] then
        p22._value_changed_events[p23] = v_u_5.new()
    end
    return p22._value_changed_events[p23]
end
function v_u_8.Replicate(p25, p26, p27)
    local v28 = typeof(p26) == "string"
    assert(v28, "Argument 1 invalid, expected a string")
    local v29 = p25:Get(p26)
    local v30 = p27 and "ReplicateToClientUnreliable" or "ReplicateToClient"
    if p25[v30] then
        p25[v30]:Fire("DataValueChanged", p25._dont_compress_replication and p26 and p26 or (p25:ToEnum(p26) or p26), v29)
    end
    if p25._value_changed_events[p26] then
        p25._value_changed_events[p26]:Fire(v29, p26)
    end
end
function v_u_8.SetReplicate(p31, p32, p33, p34)
    local v35 = typeof(p32) == "string"
    assert(v35, "Argument 1 invalid, expected a string")
    p31:Set(p32, p33)
    p31:Replicate(p32, p34)
end
function v_u_8.Increment(p36, p37, p38)
    local v39 = typeof(p37) == "string"
    assert(v39, "Argument 1 invalid, expected a string")
    local v40 = typeof(p38) == "number"
    assert(v40, "Argument 2 invalid, expected a number")
    if p38 ~= 0 then
        p36:Set(p37, p36:Get(p37) + p38)
    end
end
function v_u_8.IncrementReplicate(p41, p42, p43)
    local v44 = typeof(p42) == "string"
    assert(v44, "Argument 1 invalid, expected a string")
    local v45 = typeof(p43) == "number"
    assert(v45, "Argument 2 invalid, expected a number")
    if p43 ~= 0 then
        p41:Increment(p42, p43)
        p41:Replicate(p42)
    end
end
function v_u_8.ReplicateFromServer(p46, p47, ...)
    if p47 == "DataValueChanged" then
        local v48, v49 = ...
        p46:SetReplicate(p46._dont_compress_replication and v48 and v48 or (p46:FromEnum(v48) or v48), v49)
    else
        local v50 = "No implementation for change type: " .. tostring(p47)
        assert(false, v50)
    end
end
function v_u_8.ToEnum(_, p51)
    return v_u_4:ToEnum(p51)
end
function v_u_8.FromEnum(_, p52)
    return v_u_4:FromEnum(p52)
end
function v_u_8.Serialize(p53)
    return p53:_EncodeSerial({
        ["ClientReplicatedClassType"] = nil,
        ["Data"] = p53:_SerializeData()
    })
end
function v_u_8.Destroy(p54)
    if p54.ReplicateToClient then
        p54.ReplicateToClient:Destroy()
    end
    if p54.ReplicateToClientUnreliable then
        p54.ReplicateToClientUnreliable:Destroy()
    end
    for _, v55 in pairs(p54._value_changed_events) do
        v55:Destroy()
    end
end
function v_u_8._DecodeSerial(p56, p57)
    if p56._dont_compress_replication then
        return p57
    end
    local v58 = {}
    for v59, v60 in pairs(p57) do
        v58[v_u_4:ToEnum(v59, true) and v59 and v59 or p56:FromEnum(v59)] = v60
    end
    table.clear(p57)
    for v61, v62 in pairs(v58) do
        p57[v61] = v62
    end
    return p57
end
function v_u_8._EncodeSerial(p63, p64)
    if p63._dont_compress_replication then
        return p64
    end
    local v65 = {}
    for v66, v67 in pairs(p64) do
        if v_u_4:FromEnum(v66, true) then
            v65[v66] = v67
        end
    end
    for v68, v69 in pairs(p64) do
        if not v_u_4:FromEnum(v68, true) then
            v65[p63:ToEnum(v68)] = v69
        end
    end
    return v65
end
function v_u_8._SerializeData(p70)
    if p70._dont_compress_replication then
        return p70.Data
    end
    local v71 = {}
    for v72, v73 in pairs(p70.Data) do
        v71[p70:ToEnum(v72)] = v73
    end
    return v71
end
function v_u_8._Setup(p74)
    if p74._temp_serial then
        p74:_DecodeSerial(p74._temp_serial)
        for v75, v76 in pairs(p74._temp_serial.Data) do
            p74:SetReplicate(p74._dont_compress_replication and v75 and v75 or p74:FromEnum(v75), v76)
        end
    end
    p74._temp_serial = nil
end
function v_u_8._Init(p77)
    p77:_Setup()
end
return v_u_8