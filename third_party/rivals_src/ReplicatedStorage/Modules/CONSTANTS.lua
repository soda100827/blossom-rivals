local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("RunService")
local v3 = require(v1:WaitForChild("Modules"):WaitForChild("TestLibrary"))
local v_u_4 = {
    "PRIVATE_SERVER_ID",
    "PRIVATE_SERVER_OWNER_ID",
    "IS_PUBLIC_SERVER",
    "IS_RESERVED_SERVER",
    "IS_PRIVATE_SERVER",
    "IS_PRIVATE_HUB_SERVER"
}
local v_u_5 = v1:WaitForChild("Remotes"):WaitForChild("Misc"):WaitForChild("RequestConstants")
local v_u_6 = v3:GetTestAttribute("StudioIsPrivateServerOwner")
v3:GetTestAttribute("StudioIsPrivateServer")
local v7 = v3:GetTestAttribute("StudioPlaceID")
local v_u_8 = {
    ["GAME_VERSION"] = 24,
    ["GROUP_ID"] = 3461453,
    ["MAIN_HUB_PLACE_ID"] = 17625359962,
    ["MAIN_MOBILE_PLACE_ID"] = 18126510175,
    ["MAIN_MATCHMAKING_PLACE_ID"] = 117398147513099,
    ["MAIN_ARCADE_TEAMDEATHMATCH_PLACE_ID"] = 71874690745115,
    ["MAIN_ARCADE_FREEFORALL_PLACE_ID"] = 129604661913557,
    ["MAIN_ARCADE_GUNGAME_PLACE_ID"] = 133215910299950,
    ["TESTING_HUB_PLACE_ID"] = 12011504191,
    ["TESTING_MOBILE_PLACE_ID"] = 18126498684,
    ["TESTING_MATCHMAKING_PLACE_ID"] = 136907445582634,
    ["TESTING_ARCADE_TEAMDEATHMATCH_PLACE_ID"] = 139242311442282,
    ["TESTING_ARCADE_FREEFORALL_PLACE_ID"] = 83743252354420,
    ["TESTING_ARCADE_GUNGAME_PLACE_ID"] = 90728399170029,
    ["IS_RUNNING"] = v2:IsRunning(),
    ["IS_STUDIO"] = v2:IsStudio(),
    ["IS_SERVER"] = v2:IsServer(),
    ["IS_CLIENT"] = v2:IsClient(),
    ["DEVICE"] = "Server"
}
if not v_u_8.IS_STUDIO or v7 <= 0 then
    v7 = game.PlaceId
end
v_u_8.PLACE_ID = v7
v_u_8.JOB_ID = game.JobId
local v9 = v_u_8.IS_SERVER
if v9 then
    v9 = game.PrivateServerId
end
v_u_8.PRIVATE_SERVER_ID = v9
local v10 = v_u_8.IS_SERVER
if v10 then
    v10 = game.PrivateServerOwnerId
end
v_u_8.PRIVATE_SERVER_OWNER_ID = v10
v_u_8.IS_MAIN_SERVER = (v_u_8.PLACE_ID == v_u_8.MAIN_HUB_PLACE_ID or (v_u_8.PLACE_ID == v_u_8.MAIN_MOBILE_PLACE_ID or (v_u_8.PLACE_ID == v_u_8.MAIN_MATCHMAKING_PLACE_ID or (v_u_8.PLACE_ID == v_u_8.MAIN_ARCADE_TEAMDEATHMATCH_PLACE_ID or v_u_8.PLACE_ID == v_u_8.MAIN_ARCADE_FREEFORALL_PLACE_ID)))) and true or v_u_8.PLACE_ID == v_u_8.MAIN_ARCADE_GUNGAME_PLACE_ID
v_u_8.IS_TESTING_SERVER = (v_u_8.PLACE_ID == v_u_8.TESTING_HUB_PLACE_ID or (v_u_8.PLACE_ID == v_u_8.TESTING_MOBILE_PLACE_ID or (v_u_8.PLACE_ID == v_u_8.TESTING_MATCHMAKING_PLACE_ID or (v_u_8.PLACE_ID == v_u_8.TESTING_ARCADE_TEAMDEATHMATCH_PLACE_ID or v_u_8.PLACE_ID == v_u_8.TESTING_ARCADE_FREEFORALL_PLACE_ID)))) and true or v_u_8.PLACE_ID == v_u_8.TESTING_ARCADE_GUNGAME_PLACE_ID
v_u_8.HUB_PLACE_ID = v_u_8.IS_MAIN_SERVER and v_u_8.MAIN_HUB_PLACE_ID or v_u_8.TESTING_HUB_PLACE_ID
v_u_8.MOBILE_PLACE_ID = v_u_8.IS_MAIN_SERVER and v_u_8.MAIN_MOBILE_PLACE_ID or v_u_8.TESTING_MOBILE_PLACE_ID
v_u_8.MATCHMAKING_PLACE_ID = v_u_8.IS_MAIN_SERVER and v_u_8.MAIN_MATCHMAKING_PLACE_ID or v_u_8.TESTING_MATCHMAKING_PLACE_ID
v_u_8.ARCADE_TEAMDEATHMATCH_PLACE_ID = v_u_8.IS_MAIN_SERVER and v_u_8.MAIN_ARCADE_TEAMDEATHMATCH_PLACE_ID or v_u_8.TESTING_ARCADE_TEAMDEATHMATCH_PLACE_ID
v_u_8.ARCADE_FREEFORALL_PLACE_ID = v_u_8.IS_MAIN_SERVER and v_u_8.MAIN_ARCADE_FREEFORALL_PLACE_ID or v_u_8.TESTING_ARCADE_FREEFORALL_PLACE_ID
v_u_8.ARCADE_GUNGAME_PLACE_ID = v_u_8.IS_MAIN_SERVER and v_u_8.MAIN_ARCADE_GUNGAME_PLACE_ID or v_u_8.TESTING_ARCADE_GUNGAME_PLACE_ID
local v11 = not v_u_8.IS_STUDIO and v_u_8.IS_SERVER
if v11 then
    v11 = v_u_8.PRIVATE_SERVER_ID == ""
end
v_u_8.IS_PUBLIC_SERVER = v11
local v12 = not v_u_8.IS_STUDIO and (v_u_8.IS_SERVER and not v_u_8.IS_PUBLIC_SERVER)
if v12 then
    v12 = v_u_8.PRIVATE_SERVER_OWNER_ID == 0
end
v_u_8.IS_RESERVED_SERVER = v12
local v13 = not v_u_8.IS_STUDIO and (v_u_8.IS_SERVER and not v_u_8.IS_PUBLIC_SERVER)
if v13 then
    v13 = v_u_8.PRIVATE_SERVER_OWNER_ID ~= 0
end
v_u_8.IS_PRIVATE_SERVER = v13
v_u_8.IS_HUB_SERVER = v_u_8.PLACE_ID == v_u_8.HUB_PLACE_ID and true or v_u_8.PLACE_ID == v_u_8.MOBILE_PLACE_ID
v_u_8.IS_MOBILE_SERVER = v_u_8.PLACE_ID == v_u_8.MOBILE_PLACE_ID
v_u_8.IS_ARCADE_SERVER = (v_u_8.PLACE_ID == v_u_8.ARCADE_TEAMDEATHMATCH_PLACE_ID or v_u_8.PLACE_ID == v_u_8.ARCADE_FREEFORALL_PLACE_ID) and true or v_u_8.PLACE_ID == v_u_8.ARCADE_GUNGAME_PLACE_ID
v_u_8.IS_MATCHMAKING_SERVER = v_u_8.PLACE_ID == v_u_8.MATCHMAKING_PLACE_ID
local v14 = v_u_8.IS_HUB_SERVER
if v14 then
    v14 = v_u_8.IS_PRIVATE_SERVER
end
v_u_8.IS_PRIVATE_HUB_SERVER = v14
v_u_8.DEVELOPER_GROUP_RANK = 254
v_u_8.MODERATOR_GROUP_RANK = 245
v_u_8.TEAM_MEMBER_RANK = 100
function v_u_8.HAS_MODERATOR_ACCESS(p15)
    if p15 then
        return v_u_8.IS_STUDIO or (p15 == v_u_8.MODERATOR_GROUP_RANK and true or v_u_8.DEVELOPER_GROUP_RANK <= p15)
    else
        return false
    end
end
function v_u_8.IS_PRIVATE_SERVER_OWNER(p16)
    return v_u_6 or v_u_8.IS_TESTING_SERVER and not v_u_8.IS_STUDIO or (not v_u_8.IS_PRIVATE_HUB_SERVER or v_u_8.IS_STUDIO or v_u_8.PRIVATE_SERVER_OWNER_ID == p16)
end
function v_u_8.SHOULD_ALWAYS_REPLICATE(_)
    return v_u_8.IS_ARCADE_SERVER or v_u_8.IS_MATCHMAKING_SERVER
end
v_u_8.QUEUES_ACTIVE = v_u_8.IS_HUB_SERVER
v_u_8.SHOOTING_RANGE_ACTIVE = v_u_8.IS_HUB_SERVER or v_u_8.IS_MATCHMAKING_SERVER
v_u_8.BASE_HEALTH = 150
v_u_8.BASE_WALKSPEED = 16
v_u_8.BASE_JUMPPOWER = 20
v_u_8.BASE_GRAVITY = 0.25
v_u_8.BASE_MASS = 14.381
v_u_8.SELF_DAMAGE_MULTIPLIER = 0
v_u_8.MAX_RAYCAST_DISTANCE = 400
v_u_8.RENDER_DISTANCE = 500
v_u_8.MAX_PARTY_SIZE = 5
v_u_8.BEGINNER_QUEUE_NAME = "2v2_beginner"
v_u_8.BEGINNER_QUEUE_WINS = 10
v_u_8.WEAPON_REVEAL_TIME_OFFSET = 604800
v_u_8.WEAPON_EARLY_ACCESS_TIME_OFFSET = 86400
v_u_8.HEADSHOT_IMAGE = "https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png"
v_u_8.CONTROLS_IMAGES = {
    ["MouseKeyboard"] = "rbxassetid://17136633356",
    ["Touch"] = "rbxassetid://17136633510",
    ["Gamepad"] = "rbxassetid://17136633629",
    ["VR"] = "rbxassetid://17136765745"
}
v_u_8.CONTROLS_IMAGES_CENTERED = {
    ["MouseKeyboard"] = "rbxassetid://88012714630436",
    ["Touch"] = "rbxassetid://113510944677126",
    ["Gamepad"] = "rbxassetid://110291144710849",
    ["VR"] = "rbxassetid://99115398611290"
}
v_u_8.DEFAULT_WEAPONS = {
    "Assault Rifle",
    "Handgun",
    "Fists",
    "Grenade"
}
v_u_8.AIRBORNE_HUMANOID_STATES = {
    [Enum.HumanoidStateType.FallingDown] = true,
    [Enum.HumanoidStateType.Jumping] = true,
    [Enum.HumanoidStateType.Freefall] = true,
    [Enum.HumanoidStateType.Flying] = true,
    [Enum.HumanoidStateType.Jumping] = true
}
v_u_8.DUEL_HISTORY_MAX_SIZE = 20
v_u_8.MAX_BACKPACK_USE_QUANTITY = 100
v_u_8.MAX_EQUIPPABLE_WEAPONS = 4
v_u_8.MAX_EQUIPPABLE_EMOTES = 8
v_u_8.COSMETIC_IMAGES = {
    ["NONE_COSMETIC"] = "rbxassetid://17562770037",
    ["RANDOM_COSMETIC"] = "rbxassetid://94238795177693"
}
v_u_8.MAX_DUEL_PAD_WINS_PER_DAY_BEFORE_BEING_BLOCKED = 25
function v_u_8.INIT()
    if v_u_8.IS_SERVER then
        local v_u_17 = {}
        for _, v18 in pairs(v_u_4) do
            v_u_17[v18] = v_u_8[v18]
        end
        function v_u_5.OnServerInvoke()
            return v_u_17
        end
        return
    elseif v_u_8.IS_CLIENT then
        while true do
            local v19, v20 = pcall(v_u_5.InvokeServer, v_u_5)
            if v19 then
                break
            end
            warn("Constants failed to fetch, error:", v20)
            wait(1)
        end
        for v21, v22 in pairs(v20) do
            v_u_8[v21] = v22
        end
    end
end
return v_u_8