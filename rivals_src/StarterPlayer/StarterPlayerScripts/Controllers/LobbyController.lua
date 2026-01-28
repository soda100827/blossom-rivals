local v_u_1 = game:GetService("ExperienceNotificationService")
local v_u_2 = game:GetService("AvatarEditorService")
local v_u_3 = game:GetService("ReplicatedStorage")
local v_u_4 = game:GetService("CollectionService")
local v_u_5 = game:GetService("RunService")
local v_u_6 = game:GetService("Lighting")
local v_u_7 = game:GetService("Players")
local v_u_8 = require(v_u_3.Modules.CONSTANTS)
local v9 = require(v_u_3.Modules.TestLibrary)
local v_u_10 = require(v_u_3.Modules.Utility)
local v_u_11 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController)
local v_u_12 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_13 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_14 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_15 = v9:GetTestAttribute("StudioSkipOnboarding")
local v_u_16 = v_u_7.LocalPlayer.PlayerScripts.Modules.LobbyElements
local v_u_17 = {
    "StarterBundleBoards",
    "LeaderboardDisplays",
    "EliminationsDisplays",
    "DuelsDisplays",
    "DuelsGarageDoor",
    "LikeBoards",
    "LooseWeaponDisplays",
    "Miscellaneous",
    "DuelsSign",
    "RotatingBundleDisplay",
    "WeaponReleaseSchedule",
    "ToyTrainPaths",
    "Teleporters",
    "DailyShopSkinHolograms",
    "LobbyPortals",
    "LobbyAnimations",
    "UpdateCountdowns",
    "TopPlayerRewards"
}
local v_u_18 = {}
v_u_18.__index = v_u_18
function v_u_18._new()
    local v19 = v_u_18
    local v20 = setmetatable({}, v19)
    v20.LocalFighter = nil
    v20.Elements = {}
    v20._renderstep_connection = nil
    v20._textures_deleted = false
    v20._attempted_to_favorite = false
    v20:_Init()
    return v20
end
function v_u_18.ToDuels(_)
    if v_u_13.LocalFighter and v_u_13.LocalFighter:Get("IsInShootingRange") then
        v_u_11:Leave(true)
    elseif v_u_13.LocalFighter and (not v_u_13.LocalFighter:Get("IsInDuel") and v_u_13.LocalFighter:IsAlive()) then
        v_u_13.LocalFighter.Entity.Model:PivotTo(v_u_4:GetTagged("LobbyDuels")[1].CFrame)
    end
end
function v_u_18._RemoveGiftHolograms(_)
    if v_u_12:Get("ClaimedGroupReward") then
        for _, v21 in pairs(v_u_4:GetTagged("LobbyFreeRewardsHologram")) do
            task.defer(v21.Destroy, v21)
        end
    end
end
function v_u_18._UpdateShadows(_)
    v_u_6.GlobalShadows = not v_u_12:Get("Settings Shadows Disabled")
end
function v_u_18._PromptStuff(p22)
    if v_u_15 then
        return
    else
        wait(1)
        if v_u_14:GetDuel(v_u_7.LocalPlayer) then
            return
        else
            local v23 = v_u_12:GetStatistic("StatisticDuelsPlayed")
            local v24 = v_u_12:GetStatistic("StatisticDuelsWon")
            if p22._attempted_to_favorite or v23 ~= 5 and v24 ~= 1 then
                if not v_u_12:Get("PromptedNotificationPrompt") and (v23 >= 8 or v24 == 2) then
                    local v25, v26 = pcall(v_u_1.CanPromptOptInAsync, v_u_1)
                    if not v25 then
                        warn("Failed to check if user can prompt notifications:", v26)
                        return
                    end
                    if v26 then
                        v_u_3.Remotes.Data.PromptedNotificationPrompt:FireServer()
                        v_u_1:PromptOptIn()
                    end
                end
            else
                p22._attempted_to_favorite = true
                v_u_2:PromptSetFavorite(v_u_8.HUB_PLACE_ID, Enum.AvatarItemType.Asset, true)
            end
        end
    end
end
function v_u_18._UpdateEnabled(p_u_27)
    if p_u_27._renderstep_connection then
        p_u_27._renderstep_connection:Disconnect()
        p_u_27._renderstep_connection = nil
    end
    local v28 = p_u_27.LocalFighter and not p_u_27.LocalFighter:Get("IsInDuel")
    if v28 then
        v28 = not p_u_27.LocalFighter:Get("IsInShootingRange")
    end
    for _, v29 in pairs(p_u_27.Elements) do
        v29:SetEnabled(v28)
    end
    if v28 then
        p_u_27._renderstep_connection = v_u_5.RenderStepped:Connect(function(p30)
            for _, v31 in pairs(p_u_27.Elements) do
                v31:Update(p30)
            end
        end)
    end
    if v28 then
        task.defer(p_u_27._PromptStuff, p_u_27)
    end
end
function v_u_18._UpdateTextures(p32)
    if not p32._textures_deleted and v_u_12:Get("Settings Textures Disabled") then
        p32._textures_deleted = true
        for _, v33 in pairs(v_u_4:GetTagged("LobbyFolder")) do
            v_u_10:DisableTextures(v33)
        end
    end
end
function v_u_18._Setup(p_u_34)
    p_u_34.LocalFighter = v_u_13:WaitForLocalFighter()
    p_u_34.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
        p_u_34:_UpdateEnabled()
    end)
    p_u_34.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
        p_u_34:_UpdateEnabled()
    end)
    for _, v_u_35 in pairs(v_u_17) do
        task.defer(function()
            local v36 = p_u_34.Elements
            local v37 = require
            local v38 = v_u_16[v_u_35]
            table.insert(v36, v37(v38))
        end)
    end
    task.defer(p_u_34._UpdateEnabled, p_u_34)
end
function v_u_18._Init(p_u_39)
    v_u_12:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function()
        p_u_39:_PromptStuff()
    end)
    v_u_12:GetDataChangedSignal("Settings Textures Disabled"):Connect(function()
        p_u_39:_UpdateTextures()
    end)
    v_u_12:GetDataChangedSignal("Settings Shadows Disabled"):Connect(function()
        p_u_39:_UpdateShadows()
    end)
    v_u_12:GetDataChangedSignal("ClaimedGroupReward"):Connect(function()
        p_u_39:_RemoveGiftHolograms()
    end)
    v_u_4:GetInstanceAddedSignal("LobbyFreeRewardsHologram"):Connect(function()
        p_u_39:_RemoveGiftHolograms()
    end)
    v_u_14.LocalPlayerLeftDuel:Connect(function()
        p_u_39:_PromptStuff()
    end)
    p_u_39:_UpdateTextures()
    task.spawn(p_u_39._Setup, p_u_39)
    task.defer(p_u_39._UpdateShadows, p_u_39)
    task.defer(p_u_39._RemoveGiftHolograms, p_u_39)
end
return v_u_18._new()