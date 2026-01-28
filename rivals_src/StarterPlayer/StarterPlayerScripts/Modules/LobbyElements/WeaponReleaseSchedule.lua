local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("TeleportService")
local v4 = game:GetService("Players")
require(v2.Modules.CONSTANTS)
local v_u_5 = require(v2.Modules.ShopLibrary)
local v_u_6 = require(v2.Modules.Utility)
local v_u_7 = require(v4.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface.MatchmadeOverlay)
local v_u_9 = require(v4.LocalPlayer.PlayerScripts.Modules.UserInterface.Notifications)
local v_u_10 = require(v4.LocalPlayer.PlayerScripts.Modules.LooseWeaponDisplay)
local v_u_11 = require(v4.LocalPlayer.PlayerScripts.Modules.Functions.SendChat)
local v_u_12 = require(v4.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local v_u_13 = setmetatable({}, v_u_12)
v_u_13.__index = v_u_13
function v_u_13._new(...)
    local v14 = v_u_12.new(...)
    local v15 = v_u_13
    local v16 = setmetatable(v14, v15)
    v16._loose_weapon_displays = {}
    v16._celebration_hash = 0
    v16._celebration_queued = false
    v16:_Init()
    return v16
end
function v_u_13.GetLastReleasedWeapon(_)
    local _, v17 = v_u_5:GetUpcomingWeapon()
    local v18 = v17 and v17 - 1 or #v_u_5.OwnableWeaponReleaseSchedule
    return v_u_5.OwnableWeaponReleaseSchedule[v18], v18
end
function v_u_13.Refresh(p19, p20)
    local v21 = v_u_5:GetUpcomingWeapon()
    local v22 = p19:GetLastReleasedWeapon()
    local v23 = not v21 or v_u_5:GetTimeUntilWeaponRelease(v22) > -259200
    local v24 = v23 and v22 and v22 or (v21 or v22)
    for _, v_u_25 in pairs(p19._loose_weapon_displays) do
        v_u_25:SetLocked(not v23)
        if v_u_25.CurrentWeapon ~= v24 then
            v_u_25:ChangeWeapon(v24)
        end
        if v23 then
            v_u_25:SetProximityPromptData("NEW WEAPON", "View")
        else
            v_u_25:SetProximityPromptData("COMING SOON", function()
                return not v_u_25.CurrentWeapon and "" or v_u_6:TimeFormat2(v_u_5:GetTimeUntilWeaponRelease(v_u_25.CurrentWeapon))
            end)
        end
    end
    if p20 and v23 then
        task.delay(3, p19._PlayCelebration, p19)
    end
end
function v_u_13.Update(p26, p27)
    for _, v28 in pairs(p26._loose_weapon_displays) do
        v28:Update(p27)
    end
end
function v_u_13._EnableParticles(p29, p30)
    for v31 in pairs(p29._loose_weapon_displays) do
        if p30 then
            v_u_6:PlayParticles(v31.Particles.Emit)
            v_u_6:CreateSound("rbxassetid://120776960987657", 0.75, 1, v31.Particles, true, 15)
            v_u_6:CreateSound("rbxassetid://75616400922980", 1, 1, v31.Particles, true, 15)
        end
        for _, v32 in pairs(v31.Particles.Attachment:GetChildren()) do
            v32.Enabled = p30
        end
    end
end
function v_u_13._PlayCelebration(p_u_33)
    if not v_u_3:GetTeleportSetting("PlayedWeaponReleaseCelebration") then
        local v34 = v_u_7.LocalFighter and not v_u_7.LocalFighter:Get("IsInDuel")
        if v34 then
            v34 = not v_u_7.LocalFighter:Get("IsInShootingRange")
        end
        if v34 and not v_u_8:IsVisible() then
            v_u_3:SetTeleportSetting("PlayedWeaponReleaseCelebration", true)
            p_u_33._celebration_queued = false
            p_u_33._celebration_hash = p_u_33._celebration_hash + 1
            local v_u_35 = p_u_33._celebration_hash
            p_u_33:_EnableParticles(true)
            task.delay(10, function()
                if p_u_33._celebration_hash == v_u_35 then
                    p_u_33:_EnableParticles(false)
                end
            end)
            return true
        end
        p_u_33._celebration_queued = true
    end
end
function v_u_13._RefreshLoop(p36)
    while true do
        local v37 = v_u_5:GetUpcomingWeapon()
        if not v37 then
            break
        end
        wait(v_u_5:GetTimeUntilWeaponRelease(v37))
        p36:Refresh()
        p36:_PlayCelebration()
        local v38 = task.defer
        local v39 = v_u_11
        local v40 = {
            ["Text"] = "[SERVER] A new weapon has been officially released - The <font weight=\"900\">" .. v37 .. "</font>! Check out the Weapons page to learn more!",
            ["Color"] = Color3.fromRGB(100, 255, 50)
        }
        v38(v39, v40)
        local v41 = {
            ["Name"] = v37
        }
        task.defer(v_u_9.Play, v_u_9, "New Weapon", "The " .. v37 .. " has released!", v41, nil, nil, "rbxassetid://128960987577700")
        wait(259200)
        p36:Refresh()
    end
end
function v_u_13._ModelAdded(p42, p43)
    p42._loose_weapon_displays[p43] = v_u_10.new(p43:WaitForChild("LooseWeaponDisplay"))
    p42:Refresh()
end
function v_u_13._HookLocalFighter(p_u_44)
    local v45 = v_u_7:WaitForLocalFighter()
    local function v46()
        if p_u_44._celebration_queued then
            p_u_44:_PlayCelebration()
        end
    end
    v_u_8.VisibilityChanged:Connect(v46)
    v45:GetDataChangedSignal("IsInShootingRange"):Connect(v46)
    v45:GetDataChangedSignal("IsInDuel"):Connect(v46)
    if p_u_44._celebration_queued then
        p_u_44:_PlayCelebration()
    end
end
function v_u_13._Init(p_u_47)
    v_u_1:GetInstanceAddedSignal("LobbyWeaponReleaseSchedule"):Connect(function(p48)
        p_u_47:_ModelAdded(p48)
    end)
    for _, v49 in pairs(v_u_1:GetTagged("LobbyWeaponReleaseSchedule")) do
        task.defer(p_u_47._ModelAdded, p_u_47, v49)
    end
    p_u_47:Refresh(true)
    task.defer(p_u_47._HookLocalFighter, p_u_47)
    task.defer(p_u_47._RefreshLoop, p_u_47)
end
return v_u_13._new()