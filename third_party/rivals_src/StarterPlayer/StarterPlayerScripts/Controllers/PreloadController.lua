local v_u_1 = game:GetService("ContentProvider")
local v_u_2 = {
    ["FinalResultsCamera"] = "rbxassetid://18110142424",
    ["FinalResultsPlayer1"] = "rbxassetid://18110150396",
    ["FinalResultsPlayer2"] = "rbxassetid://18110151901",
    ["FinalResultsPlayer3"] = "rbxassetid://18110154615",
    ["FinalResultsPlayer4"] = "rbxassetid://18110156683",
    ["FinalResultsPlayer5"] = "rbxassetid://18110158144",
    ["SlidingStartForward"] = "rbxassetid://17702562791",
    ["SlidingStartRightward"] = "rbxassetid://18887331786",
    ["SlidingStartBackward"] = "rbxassetid://18887315202",
    ["SlidingStartLeftward"] = "rbxassetid://18887335228",
    ["SlidingLoopForward"] = "rbxassetid://17702566891",
    ["SlidingLoopRightward"] = "rbxassetid://18887328608",
    ["SlidingLoopBackward"] = "rbxassetid://18887323938",
    ["SlidingLoopLeftward"] = "rbxassetid://18887339224",
    ["SlidingJump"] = "rbxassetid://17704241464",
    ["SlidingJumpFall"] = "rbxassetid://17704252963",
    ["WeaponUnlockIdle"] = "rbxassetid://17652443406",
    ["WeaponUnlockPlay"] = "rbxassetid://17652360108",
    ["LobbyPortalFalling"] = "rbxassetid://111331261961557",
    ["ZombieSpawn"] = "rbxassetid://81895123077452"
}
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3._new()
    local v4 = v_u_3
    local v5 = setmetatable({}, v4)
    v5._preloaded_animations_by_name = {}
    v5._preloaded_animations_by_animation_id = {}
    v5:_Init()
    return v5
end
function v_u_3.GetPreloadedAnimationID(_, p6)
    return v_u_2[p6]
end
function v_u_3.GetPreloadedAnimation(p7, p8)
    return p7._preloaded_animations_by_name[p8]
end
function v_u_3._PreloadAnimations(p_u_9)
    local v10 = {}
    for v11, v12 in pairs(v_u_2) do
        local v13 = Instance.new("Animation")
        v13.AnimationId = v12
        p_u_9._preloaded_animations_by_name[v11] = v13
        p_u_9._preloaded_animations_by_animation_id[v12] = v13
        table.insert(v10, v13)
    end
    while #v10 > 0 do
        local v_u_14 = {}
        v_u_1:PreloadAsync(v10, function(p15, p16)
            if p16 ~= Enum.AssetFetchStatus.Success then
                local v17 = v_u_14
                local v18 = p_u_9._preloaded_animations_by_animation_id[p15]
                table.insert(v17, v18)
            end
        end)
        wait(1)
        v10 = v_u_14
    end
end
function v_u_3._Init(p19)
    task.defer(p19._PreloadAnimations, p19)
end
return v_u_3._new()