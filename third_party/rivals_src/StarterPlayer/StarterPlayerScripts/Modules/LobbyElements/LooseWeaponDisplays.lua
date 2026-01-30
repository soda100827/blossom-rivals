local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
local v_u_4 = require(v2.Modules.CONSTANTS)
require(v2.Modules.CosmeticLibrary)
require(v2.Modules.ItemLibrary)
local v_u_5 = require(v2.Modules.ShopLibrary)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Controllers.LobbyController)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules.LooseWeaponDisplay)
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_10 = setmetatable({}, v_u_9)
v_u_10.__index = v_u_10
function v_u_10._new(...)
    local v11 = v_u_9.new(...)
    local v12 = v_u_10
    local v13 = setmetatable(v11, v12)
    v13.Displays = {}
    v13:_Init()
    return v13
end
function v_u_10.Shuffle(p14)
    local v15 = {}
    for _, v16 in pairs(v_u_6:Get("WeaponInventory")) do
        v15[v16.Name] = true
    end
    local v17 = {}
    for _, v18 in pairs(v_u_5:GetReleasedOwnableWeapons(v_u_4.WEAPON_EARLY_ACCESS_TIME_OFFSET, v_u_5.OwnableWeaponsAlphabetized)) do
        if not v15[v18] then
            local v19 = math.random(1, #v17 + 1)
            table.insert(v17, v19, v18)
        end
    end
    local v20 = {}
    for v21 = 1, #p14.Displays do
        local v22 = math.random(1, #v20 + 1)
        table.insert(v20, v22, v21)
    end
    for _, v23 in pairs(v20) do
        p14.Displays[v23]:ChangeWeapon(p14:_VerifyLooseWeaponDisplayWeapon(table.remove(v17, 1)))
    end
end
function v_u_10.Update(p24, p25)
    for _, v26 in pairs(p24.Displays) do
        v26:Update(p25)
    end
end
function v_u_10._VerifyLooseWeaponDisplayWeapon(_, p27)
    if p27 and not v_u_6:GetWeaponData(p27) then
        return p27
    else
        return nil
    end
end
function v_u_10._ObjectAdded(p28, p29)
    local v30 = v_u_8.new(p29)
    local v31 = p28.Displays
    table.insert(v31, v30)
end
function v_u_10._Init(p_u_32)
    v_u_7.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        if not v_u_7.LocalFighter:Get("IsInDuel") then
            p_u_32:Shuffle()
        end
    end)
    v_u_6:GetDataChangedSignal("WeaponInventory"):Connect(function()
        for _, v33 in pairs(p_u_32.Displays) do
            v33:ChangeWeapon(p_u_32:_VerifyLooseWeaponDisplayWeapon(v33.CurrentWeapon))
        end
    end)
    v_u_1:GetInstanceAddedSignal("LobbyLooseWeaponDisplay"):Connect(function(p34)
        p_u_32:_ObjectAdded(p34)
    end)
    for _, v35 in pairs(v_u_1:GetTagged("LobbyLooseWeaponDisplay")) do
        task.spawn(p_u_32._ObjectAdded, p_u_32, v35)
    end
    p_u_32:Shuffle()
end
return v_u_10._new()