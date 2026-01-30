local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
require(v1.Modules.MonetizationLibrary)
local v_u_4 = require(v1.Modules.Spring)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("StaticModel"):WaitForChild("StaticViewModel"))
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_7 = v3.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("LooseWeaponDisplayParticles")
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Model = p9
    v11.CurrentWeapon = nil
    v11._primary = v11.Model:WaitForChild("Primary")
    v11._owned_model = v11.Model:WaitForChild("Owned")
    v11._origin = v11._primary.CFrame
    v11._static_viewmodel = nil
    v11._proximity_prompt = Instance.new("ProximityPrompt")
    v11._is_animating = nil
    v11._animation_tick = 0
    v11._spin_spring = v_u_4.new(1, 1, 5)
    v11._return_to_normal_progress = 1
    v11._return_to_normal_start = v11._origin
    v11._scale = 1
    v11._proximity_prompt_object_text = nil
    v11._proximity_prompt_action_text = nil
    v11._proximity_prompt_next_update = 0
    v11._is_locked = false
    v11:_Init()
    return v11
end
function v_u_8.SetScale(p12, p13)
    p12._scale = p13
    if p12._static_viewmodel then
        p12._static_viewmodel:ScaleTo(3 * p12._scale)
    end
end
function v_u_8.SetProximityPromptData(p14, p15, p16)
    p14._proximity_prompt_object_text = p15
    p14._proximity_prompt_action_text = p16
    p14:_UpdateProximityPrompt()
end
function v_u_8.SetLocked(p17, p18)
    if p18 ~= p17._is_locked then
        p17._is_locked = p18
        if p17._static_viewmodel then
            p17._static_viewmodel:SetLocked(p17._is_locked)
        end
    end
end
function v_u_8.ChangeWeapon(p19, p20)
    p19.CurrentWeapon = p19.Model:GetAttribute("PriorityWeapon") or (p20 or nil)
    if p19._static_viewmodel then
        p19._static_viewmodel:Destroy()
        p19._static_viewmodel = nil
    end
    p19._owned_model.Parent = p19.Model
    p19._proximity_prompt.Parent = nil
    p19._proximity_prompt:RemoveTag("LobbyOpenPagePrompt")
    p19._proximity_prompt:SetAttribute("PageName", nil)
    p19._proximity_prompt:SetAttribute("ShopViewBundleName", nil)
    if p19.CurrentWeapon then
        p19._owned_model.Parent = nil
        p19._static_viewmodel = v_u_5.new(p19.CurrentWeapon)
        p19._static_viewmodel:DeleteAnimationContextSubModels("ShowInEquipment")
        p19._static_viewmodel:ScaleTo(3 * p19._scale)
        p19._static_viewmodel:SetLocked(p19._is_locked)
        p19._static_viewmodel:PivotTo(p19._origin)
        p19._static_viewmodel:SetParent(p19.Model)
        p19:_SetAnimating(false)
        p19._proximity_prompt.Parent = p19._primary
        p19:_UpdateProximityPrompt()
    else
        p19:_SetAnimating(false)
    end
end
function v_u_8.Update(p21, p22)
    if p21._is_animating then
        p21._animation_tick = p21._animation_tick + p22 * 0.5
        local v23 = CFrame.Angles(0, p21._spin_spring.Value * 3.141592653589793 * 2 + p21._animation_tick % 6.283185307179586, 0)
        local v24 = p21._spin_spring.Value
        local v25 = Vector3.new(0, v24, 0)
        p21._static_viewmodel:PivotTo(p21._origin * p21._primary.CFrame.Rotation:Inverse() * v23 * p21._primary.CFrame.Rotation + v25)
        if p21._static_viewmodel then
            p21._static_viewmodel:Update(p22)
        end
        if tick() > p21._proximity_prompt_next_update then
            p21._proximity_prompt_next_update = tick() + 1
            p21:_UpdateProximityPrompt()
        end
    elseif p21._static_viewmodel and p21._return_to_normal_progress < 1 then
        local v26 = p21._return_to_normal_progress + p22 * 0.25
        p21._return_to_normal_progress = math.min(1, v26)
        p21._static_viewmodel:PivotTo(p21._return_to_normal_start:Lerp(p21._origin, v_u_2:GetValue(p21._return_to_normal_progress, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)))
    end
end
function v_u_8._UpdateProximityPrompt(p27)
    local v28 = p27._proximity_prompt
    local v29 = p27._proximity_prompt_object_text
    v28.ObjectText = typeof(v29) == "function" and p27._proximity_prompt_object_text() or p27._proximity_prompt_object_text or (p27.CurrentWeapon or "")
    local v30 = p27._proximity_prompt
    local v31 = p27._proximity_prompt_action_text
    v30.ActionText = typeof(v31) == "function" and p27._proximity_prompt_action_text() or (p27._proximity_prompt_action_text or "View")
end
function v_u_8._SetAnimating(p32, p33)
    p32._is_animating = p33
    if p33 then
        p32._spin_spring.Value = 0
        p32._animation_tick = 0
    else
        p32._return_to_normal_progress = 0
        p32._return_to_normal_start = p32._static_viewmodel and p32._static_viewmodel:GetPivot() or CFrame.identity
    end
    for _, v34 in pairs(p32._primary:GetDescendants()) do
        if v34:IsA("ParticleEmitter") then
            v34.Enabled = p33
        end
    end
    p32:_UpdateProximityPrompt()
end
function v_u_8._Setup(p35)
    p35._proximity_prompt.ClickablePrompt = true
    p35._proximity_prompt.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
    p35._proximity_prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    p35._proximity_prompt.HoldDuration = 0
    p35._proximity_prompt.MaxActivationDistance = 10
    p35._proximity_prompt.KeyboardKeyCode = Enum.KeyCode.Q
    p35._proximity_prompt.RequiresLineOfSight = false
    p35._proximity_prompt.Style = Enum.ProximityPromptStyle.Custom
    local v36 = p35._primary
    v36.CFrame = v36.CFrame + Vector3.new(0, 2.5, 0)
    for _, v37 in pairs(v_u_7:GetChildren()) do
        v37:Clone().Parent = p35._primary
    end
end
function v_u_8._Init(p_u_38)
    p_u_38._proximity_prompt.Triggered:Connect(function()
        v_u_6:Open()
        v_u_6:SelectWeapon(p_u_38.CurrentWeapon)
    end)
    p_u_38._proximity_prompt.PromptShown:Connect(function()
        p_u_38:_SetAnimating(true)
    end)
    p_u_38._proximity_prompt.PromptHidden:Connect(function()
        p_u_38:_SetAnimating(false)
    end)
    p_u_38:_Setup()
    p_u_38:_UpdateProximityPrompt()
    p_u_38:ChangeWeapon(nil)
end
return v_u_8