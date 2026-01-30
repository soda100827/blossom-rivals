local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CosmeticLibrary)
local v_u_4 = require(v1.Modules.ItemLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.WrapController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.StaticModel)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.Charm)
local v_u_9 = v_u_2.LocalPlayer.PlayerScripts.Modules.Charms
local v_u_10 = v_u_2.LocalPlayer.PlayerScripts.Assets.ViewModels
local v_u_11 = setmetatable({}, v_u_7)
v_u_11.__index = v_u_11
function v_u_11.new(p12, _)
    local v13 = v_u_7.new(v_u_5:LookThrough(v_u_10, p12):Clone())
    local v14 = v_u_11
    local v15 = setmetatable(v13, v14)
    v15.Name = p12
    local v16 = v_u_3.Cosmetics[v15.Name] and v_u_3.Cosmetics[v15.Name].ItemName
    if not v16 then
        if v_u_4.Items[v15.Name] then
            v16 = v15.Name or nil
        else
            v16 = nil
        end
    end
    v15.WeaponName = v16
    v15.Charm = nil
    v15.Wrap = nil
    v15._submodel_to_grip_attachment = {}
    v15._grip_attachment_to_limb = {}
    v15._charm_scale_multiplier = 1
    v15._charm_attachment_model = v15.Model:FindFirstChild("_charm_attachment_model", true)
    local v17 = v15._charm_attachment_model
    if v17 then
        v17 = v15._charm_attachment_model.Parent
    end
    v15._charm_attachment_model_parent = v17
    v15._charm_pivot_attachment = v15._charm_attachment_model and v15._charm_attachment_model:FindFirstChild("_charm_pivot_attachment", true) or v15.Model:FindFirstChild("_charm_pivot_attachment", true)
    v15._original_wrap_properties = {}
    v15._wrapped_only_objects = {}
    v15._is_locked = false
    v15._locked_original_properties = {}
    v15._weld_data = {}
    v15:_Init()
    return v15
end
function v_u_11.GetCharmPivotAttachment(p18)
    return p18._charm_pivot_attachment
end
function v_u_11.GetPivot(p19)
    return p19.Model:GetPivot()
end
function v_u_11.GetBoundingBox(p20)
    return p20.Model:GetBoundingBox()
end
function v_u_11.IsLocked(p21)
    return p21._is_locked
end
function v_u_11.HasGripAttachment(p22)
    return p22.Model:FindFirstChild("_grip", true)
end
function v_u_11.DeleteAnimationContextSubModels(p23, p24)
    local v25 = {}
    for v26 in pairs(p23._submodel_to_grip_attachment) do
        if v26:GetAttribute("AnimationContexts") and not (p24 and v26:GetAttribute(p24)) then
            v26:Destroy()
            table.insert(v25, v26)
        end
    end
    for _, v27 in pairs(v25) do
        p23._submodel_to_grip_attachment[v27] = nil
    end
end
function v_u_11.ForceCharmAttachmentModelVisible(p28, p29)
    p28._is_charm_attachment_model_forced_visible = p29
    p28:_UpdateCharmAttachmentModelVisibility()
end
function v_u_11.SetParent(p30, p31)
    p30.Model.Parent = p31
    if p30.Charm then
        p30.Charm:SetParent(p31)
    end
end
function v_u_11.SetLocked(p32, p33)
    if p33 ~= p32._is_locked then
        p32._is_locked = p33
        if p32._is_locked then
            p32:_Lock()
        else
            p32:_Unlock()
        end
        p32:_UpdateWrap()
    end
end
function v_u_11.SetCharm(p34, p35)
    if p34.Charm then
        p34.Charm:Destroy()
        p34.Charm = nil
    end
    if p35 and p34._charm_pivot_attachment then
        local v36 = v_u_9:FindFirstChild(p35.Name, true)
        p34.Charm = (v36 and require(v36) or v_u_8).new(nil, p35, p34._charm_pivot_attachment)
        p34.Charm:ScaleTo(p34.Model:GetScale() / p34._original_scale * p34._charm_scale_multiplier)
        p34.Charm:SetParent(p34.Model.Parent)
        p34:_UpdateCharmAttachmentModelVisibility()
    else
        p34:_UpdateCharmAttachmentModelVisibility()
    end
end
function v_u_11.SetWrap(p37, p38)
    p37.Wrap = p38
    p37:_UpdateWrap()
end
function v_u_11.BreakWeld(p39)
    for v40, _ in pairs(p39._weld_data) do
        v40.Anchored = true
    end
    for _, v41 in pairs(p39._weld_data) do
        v41:Destroy()
    end
    p39._weld_data = {}
end
function v_u_11.WeldTo(p42, p43)
    p42:BreakWeld()
    local v44 = pairs
    local v45 = {}
    local v46 = p42.Model
    local v47
    if p42.Charm then
        v47 = p42.Charm.Model or nil
    else
        v47 = nil
    end
    __set_list(v45, 1, {v46, v47})
    for _, v48 in v44(v45) do
        for _, v49 in pairs(v48:GetDescendants()) do
            if v49:IsA("BasePart") then
                local v50 = Instance.new("WeldConstraint")
                v50.Part1 = p43
                v50.Part0 = v49
                v50.Parent = v49
                p42._weld_data[v49] = v50
            end
        end
    end
    for v51 in pairs(p42._weld_data) do
        v51.Massless = true
        v51.Anchored = false
    end
end
function v_u_11.ScaleTo(p52, p53, p54)
    v_u_7.ScaleTo(p52, p53)
    p52._charm_scale_multiplier = p54 or 1
    if p52.Charm then
        p52.Charm:ScaleTo(p53 * p52._charm_scale_multiplier)
    end
end
function v_u_11.PivotTo(p55, p56, p57)
    if p57 then
        p57 = p55.Model:FindFirstChild(p57, true)
    end
    if p57 then
        p57 = p57.WorldCFrame
    end
    p55:_ParentWrappedOnlyObjects(true)
    v_u_7.PivotTo(p55, p56, p57)
    p55:_ParentWrappedOnlyObjects(p55:_WrapExists())
end
function v_u_11.InitializeGrip(p58)
    for _, v59 in pairs(p58.Model:GetChildren()) do
        v59.WorldPivot = p58._submodel_to_grip_attachment[v59].WorldCFrame
        if v59.Name == "_fake" then
            task.defer(v59.Destroy, v59)
        end
    end
end
function v_u_11.GripPivotTo(p60, p61)
    for _, v62 in pairs(p60.Model:GetChildren()) do
        local v63 = p60._submodel_to_grip_attachment[v62]
        local v64 = p61[p60._grip_attachment_to_limb[v63]]
        v62.WorldPivot = v63.WorldCFrame
        v62:PivotTo(v64.CFrame)
    end
    p60:Update(0)
end
function v_u_11.Update(p65, p66)
    v_u_7.Update(p65, p66)
    if p65.Charm then
        p65.Charm:Update(p66)
    end
end
function v_u_11.Destroy(p67)
    if p67.Charm then
        p67.Charm:Destroy()
    end
    v_u_7.Destroy(p67)
end
function v_u_11._WrapExists(p68)
    local v69 = p68.Wrap
    if v69 then
        v69 = p68.Wrap.Name ~= "RANDOM_COSMETIC"
    end
    return v69
end
function v_u_11._ParentWrappedOnlyObjects(p70, p71)
    for v72, v73 in pairs(p70._wrapped_only_objects) do
        v72.Parent = p71 and v73 and v73 or nil
    end
end
function v_u_11._UpdateWrap(p74)
    if not p74._is_locked then
        v_u_6:ApplyWrap(p74._original_wrap_properties, p74.Wrap)
        p74:_UpdateCharmAttachmentModelVisibility()
        if p74.Name == "Fists" or p74.Name == "Hand Gun" then
            local v75 = p74:_WrapExists()
            p74.Model._fake.LeftArm.Transparency = v75 and 1 or 0
            p74.Model._fake.LeftArm.ShirtTexture.Transparency = v75 and 1 or 0
            p74.Model._fake.RightArm.Transparency = v75 and 1 or 0
            p74.Model._fake.RightArm.ShirtTexture.Transparency = v75 and 1 or 0
            p74:_ParentWrappedOnlyObjects(v75)
        end
    end
end
function v_u_11._UpdateCharmAttachmentModelVisibility(p76)
    local v77 = (p76.Charm or p76._is_charm_attachment_model_forced_visible) and 0 or 1
    for _, v78 in pairs(p76._charm_attachment_model and p76._charm_attachment_model:GetDescendants() or {}) do
        if v78:IsA("BasePart") or v78:IsA("Texture") then
            v78.LocalTransparencyModifier = v77
        end
    end
end
function v_u_11._Unlock(p79)
    for v80, v81 in pairs(p79._locked_original_properties) do
        for v82, v83 in pairs(v81) do
            v80[v82] = v83
        end
    end
    p79._locked_original_properties = {}
end
function v_u_11._Lock(p_u_84)
    local function v87(p85)
        if not p_u_84._locked_original_properties[p85] then
            local v86 = {}
            if p85:IsA("BasePart") then
                v86.Color = p85.Color
                p85.Color = Color3.fromRGB(31, 31, 31)
                v86.Material = p85.Material
                p85.Material = Enum.Material.Neon
                if p85:IsA("MeshPart") then
                    v86.TextureID = p85.TextureID
                    p85.TextureID = ""
                end
            elseif p85:IsA("Beam") or (p85:IsA("Trail") or p85:IsA("ParticleEmitter")) then
                v86.Color = p85.Color
                p85.Color = ColorSequence.new(Color3.fromRGB(31, 31, 31))
                if p85:IsA("ParticleEmitter") or p85:IsA("Beam") then
                    v86.Brightness = p85.Brightness
                    p85.Brightness = 1
                    v86.LightEmission = p85.LightEmission
                    p85.LightEmission = 0
                    v86.LightInfluence = p85.LightInfluence
                    p85.LightInfluence = 0
                end
            end
            p_u_84._locked_original_properties[p85] = v86
        end
    end
    for _, v88 in pairs({ p_u_84.Model, p_u_84._charm_attachment_model }) do
        v87(v88)
        for _, v89 in pairs(v88:GetDescendants()) do
            v87(v89)
        end
    end
end
function v_u_11._SetupSpecificWeapons(p90)
    if p90.Name == "Fists" or (p90.Name == "Handsaws" or p90.Name == "Hand Gun") then
        local v91, v92, v93 = v_u_5:GetArmsData(v_u_2.LocalPlayer.Character)
        if v91 and (v92 and v93) then
            p90.Model._fake.RightArm.ShirtTexture.Texture = v91
            p90.Model._fake.LeftArm.ShirtTexture.Texture = v91
            p90.Model._fake.RightArm.Color = v93
            p90.Model._fake.LeftArm.Color = v92
            if p90.Name ~= "Handsaws" then
                p90.Model._fake.RightArmWrapped.Color = v93
                p90.Model._fake.LeftArmWrapped.Color = v92
            end
            if p90.Name == "Hand Gun" then
                for _, v94 in pairs(p90.Model:GetChildren()) do
                    if v94:FindFirstChild("MeshPart") then
                        v94.MeshPart.Color = v94:GetAttribute("IsRightHand") and v93 and v93 or v92
                    end
                end
            end
            p90._original_wrap_properties = v_u_6:RecordOriginalWrapProperties(p90.Model)
        end
        local v95 = p90.Model._fake:FindFirstChild("RightArmWrapped")
        if v95 then
            p90._wrapped_only_objects[v95] = p90.Model._fake
        end
        local v96 = p90.Model._fake:FindFirstChild("LeftArmWrapped")
        if v96 then
            p90._wrapped_only_objects[v96] = p90.Model._fake
            return
        end
    else
        if p90.Name == "Chainsaw" or p90.Name == "Blobsaw" then
            p90.Model.Body.Spikes2:Destroy()
            return
        end
        if p90.Name == "Handsaws" then
            p90.Model.RightBlade.Spikes2:Destroy()
            p90.Model.LeftBlade.Spikes2:Destroy()
        end
    end
end
function v_u_11._Setup(p97)
    if v_u_3.IGNORE_TRANSPARENCY_WHITELIST[p97.Name] then
        for _, v98 in pairs(p97.Model:GetDescendants()) do
            if v98:IsA("BasePart") then
                v98:SetAttribute("IgnoreTransparency", true)
            end
        end
    end
    local v99 = nil
    for _, v100 in pairs(p97.Model:GetChildren()) do
        v100.PrimaryPart = nil
        for _, v101 in pairs(v100:GetDescendants()) do
            if v101:IsA("BasePart") then
                v101.CastShadow = true
                v101.CanCollide = false
                v101.CanTouch = false
                v101.CanQuery = false
                v101.Massless = true
                v101.Anchored = true
            end
        end
        local v102 = v100:FindFirstChild("_grip", true)
        local v103 = v102 and (v102:GetAttribute("GripTarget") or "RightHand") or nil
        if v102 then
            v102:SetAttribute("GripTarget", v103)
            p97._grip_attachment_to_limb[v102] = v103
            p97._submodel_to_grip_attachment[v100] = v102
            if v103 == "RightHand" then
                v99 = v102
            end
        end
    end
    for _, v104 in pairs(p97.Model:GetChildren()) do
        p97._submodel_to_grip_attachment[v104] = p97._submodel_to_grip_attachment[v104] or v99
    end
    p97.Model.PrimaryPart = nil
    p97.Model.WorldPivot = p97.Model:FindFirstChild("_center", true).WorldCFrame
    p97._original_wrap_properties = v_u_6:RecordOriginalWrapProperties(p97.Model)
end
function v_u_11._Init(p105)
    p105:_Setup()
    p105:_SetupSpecificWeapons()
    p105:SetLocked(false)
    p105:SetCharm(nil)
    p105:SetWrap(nil)
end
return v_u_11