local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_9 = v2.LocalPlayer.PlayerScripts.Assets.Misc.UnlockParticles
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = v_u_10
    local v13 = setmetatable({}, v12)
    v13.UnlockingChanged = v_u_5.new()
    v13.Scene = p11
    v13.Model = v13.Scene.Model:WaitForChild("UnlockEffect")
    v13.IsUnlocking = false
    v13._animation_controller = v13.Model:WaitForChild("AnimationController")
    v13._original_cframe = v13.Model:GetPivot()
    v13._idle_animation_loaded = false
    v13._animation_track = nil
    v13._animation_hash = 0
    v13:_Init()
    return v13
end
function v_u_10.StopAnimation(p14, _)
    p14:_SetIsUnlocking(false)
    p14._animation_hash = p14._animation_hash + 1
    if p14._animation_track then
        p14._animation_track:Stop(0)
        p14._animation_track:Destroy()
        p14._animation_track = nil
    end
end
function v_u_10.PlayAnimation(p15)
    p15:StopAnimation(true)
    p15:_SetIsUnlocking(true)
    local v16, v17 = pcall(p15._PlayAnimationAsync, p15)
    if not v16 then
        warn("Unlock animation failed, error:", v17)
    end
    p15:_SetIsUnlocking(false)
end
function v_u_10.OnStateChanged(p18)
    p18:_PlayIdleAnimation()
    p18:_UpdateCFrame()
    p18:StopAnimation()
end
function v_u_10.OnOpen(p19)
    p19:_PlayIdleAnimation()
end
function v_u_10._PlayAnimationAsync(p20)
    p20._animation_hash = p20._animation_hash + 1
    local v21 = p20._animation_hash
    p20.Model.Key.a1.Trail.Enabled = true
    v_u_4:CreateSound("rbxassetid://17662575024", 1.5, 1, script, true, 5)
    p20._animation_track = p20._animation_controller:LoadAnimation(v_u_7:GetPreloadedAnimation("WeaponUnlockPlay"))
    p20._animation_track:Play(0)
    wait(2.25)
    if v21 == p20._animation_hash then
        v_u_4:CreateSound("rbxassetid://17662574898", 1.5, 1, script, true, 5)
        wait(0.25)
        if v21 == p20._animation_hash then
            p20.Model.Key.a1.Trail.Enabled = false
            v_u_4:CreateSound("rbxassetid://17662575175", 1, 1, script, true, 5)
            v_u_4:PlayParticles(p20.Model.ChainsHolder.Attachment)
            wait(1)
            if v21 == p20._animation_hash then
                v_u_4:CreateSound("rbxassetid://17662623697", 1.5, 1, script, true, 5)
                local v22, v23 = p20.Scene.Equipment.FloatingModel:GetBoundingBox()
                local v24 = Instance.new("Part")
                v24.CFrame = v22
                v24.Size = v23
                v24.Transparency = 1
                v24.Anchored = true
                v24.CanCollide = false
                v24.CanTouch = false
                v24.CanQuery = false
                v24.Parent = workspace
                v_u_3:AddItem(v24, 10)
                for _, v25 in pairs(v_u_9:GetChildren()) do
                    local v26 = v25:Clone()
                    v26.Parent = v24
                    task.delay(v25:GetAttribute("EmitDelay") or 0, v26.Emit, v26, v25:GetAttribute("EmitCount"))
                end
            end
        else
            return
        end
    else
        return
    end
end
function v_u_10._PlayIdleAnimation(p_u_27)
    p_u_27._idle_animation_loaded = false
    for _ = 1, 3 do
        local v28, v29 = pcall(function()
            p_u_27._animation_controller:LoadAnimation(v_u_7:GetPreloadedAnimation("WeaponUnlockIdle")):Play(0)
        end)
        if v28 then
            p_u_27._idle_animation_loaded = true
            return
        end
        warn("Failed to load unlock model idle, error", v29)
    end
end
function v_u_10._UpdateCFrame(p30)
    local v31 = p30.Scene.Equipment:GetSelectedWeapon()
    if v31 then
        v31 = not v_u_6:GetWeaponData(v31)
    end
    local v32 = v31 and (not v_u_8.PageSystem.CurrentPage and p30._idle_animation_loaded) and p30._original_cframe or CFrame.identity
    p30.Model:PivotTo(v32)
end
function v_u_10._UpdateKey(p33)
    local v34 = p33.IsUnlocking and 0 or 1
    p33.Model.Key.LocalTransparencyModifier = v34
    p33.Model.Key.a1.Trail.LocalTransparencyModifier = v34
    p33.Model.Key.sparkle.LocalTransparencyModifier = v34
end
function v_u_10._SetIsUnlocking(p35, p36)
    if p35.IsUnlocking ~= p36 then
        p35.IsUnlocking = p36
        p35.UnlockingChanged:Fire()
    end
end
function v_u_10._Init(p_u_37)
    p_u_37.UnlockingChanged:Connect(function()
        p_u_37:_UpdateKey()
    end)
    v_u_6:GetDataChangedSignal("WeaponInventory"):Connect(function()
        p_u_37:_UpdateCFrame()
    end)
    v_u_8.PageSystem.PagesActivity:Connect(function()
        p_u_37:_UpdateCFrame()
    end)
    p_u_37:_UpdateKey()
end
return v_u_10