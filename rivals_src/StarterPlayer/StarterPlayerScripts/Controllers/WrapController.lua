local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("RunService")
local v4 = game:GetService("Players")
local v_u_5 = require(v2.Modules.CONSTANTS)
local v_u_6 = require(v2.Modules.CosmeticLibrary)
local v_u_7 = v_u_5.IS_CLIENT and v_u_5.IS_RUNNING
if v_u_7 then
    v_u_7 = v4.LocalPlayer.PlayerScripts.Assets:WaitForChild("WrapTextures")
end
local v_u_8 = v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WrapGroupCallbacks")
local v_u_9 = v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WrapGroupObjects")
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new()
    local v11 = v_u_10
    local v12 = setmetatable({}, v11)
    v12._wrap_group_callbacks = {}
    v12._wrap_group_classes = {}
    v12._wrap_group_objects = {}
    v12:_Init()
    return v12
end
function v_u_10.RecordOriginalWrapProperties(_, p13)
    local v14 = p13:GetDescendants()
    table.insert(v14, p13)
    local v15 = {}
    for _, v16 in pairs(v14) do
        if v16:HasTag("Wrappable") then
            local v17 = nil
            local v18
            if v16:IsA("BasePart") then
                v18 = {
                    ["Material"] = v16.Material,
                    ["MaterialVariant"] = v16.MaterialVariant,
                    ["Color"] = v16.Color,
                    ["Transparency"] = v16.Transparency,
                    ["Reflectance"] = v16.Reflectance
                }
                if v16:IsA("MeshPart") then
                    v18.TextureID = v16.TextureID
                end
            elseif v16:IsA("Decal") or v16:IsA("Texture") then
                v18 = {
                    ["Color3"] = v16.Color3,
                    ["Transparency"] = v16.Transparency
                }
            elseif v16:IsA("Beam") or (v16:IsA("Trail") or v16:IsA("ParticleEmitter")) then
                v18 = {
                    ["Color"] = v16.Color,
                    ["Transparency"] = v16.Transparency
                }
            elseif v16:IsA("Frame") then
                v18 = {
                    ["BackgroundColor3"] = v16.BackgroundColor3,
                    ["BackgroundTransparency"] = v16.BackgroundTransparency
                }
            else
                v18 = v16:IsA("ImageLabel") and {
                    ["ImageColor3"] = v16.ImageColor3,
                    ["ImageTransparency"] = v16.ImageTransparency
                } or v17
            end
            if v18 then
                v15[v16] = {
                    ["WrapGroup"] = v16:GetAttribute("WrapGroup"),
                    ["IgnoreTransparency"] = v16:GetAttribute("IgnoreTransparency"),
                    ["IgnoreMaterial"] = v16:GetAttribute("IgnoreMaterial"),
                    ["IgnoreObject"] = v16:GetAttribute("IgnoreObject"),
                    ["OriginalProperties"] = v18,
                    ["OriginalChildren"] = {},
                    ["Cleanup"] = {}
                }
                for _, v19 in pairs(v16:GetChildren()) do
                    if v19:IsA("SurfaceAppearance") then
                        local v20 = v15[v16].OriginalChildren
                        table.insert(v20, v19)
                    end
                end
                local v21 = v15[v16].WrapGroup
                if v21 then
                    local v22 = v15[v16].WrapGroup
                    v21 = typeof(v22) == "number"
                end
                assert(v21, v16:GetFullName())
            end
        end
    end
    return v15
end
function v_u_10.ResetWrap(_, p23)
    if p23 then
        for v_u_24, v25 in pairs(p23) do
            for v26, v27 in pairs(v25.OriginalProperties) do
                v_u_24[v26] = v27
            end
            for _, v_u_28 in pairs(v25.OriginalChildren) do
                pcall(function()
                    v_u_28.Parent = v_u_24
                end)
            end
            for _, v29 in pairs(v25.Cleanup) do
                v29:Destroy()
            end
            v25.Cleanup = {}
        end
    end
end
function v_u_10.ApplyWrap(p30, p31, p32, p33, p34)
    p30:ResetWrap(p31)
    if p32 and p32.Name ~= "RANDOM_COSMETIC" then
        local v35 = v_u_6.Cosmetics[p32.Name]
        local v36 = p32.Inverted
        for v37, v38 in pairs(p31) do
            if not (p34 and p34[v37]) then
                local v39
                if v36 then
                    v39 = v38.WrapGroup == 1 and 2 or (v38.WrapGroup == 2 and 1 or v38.WrapGroup)
                else
                    v39 = v38.WrapGroup
                end
                local v40 = v35.WrapGroups[v39] or {}
                local v41 = p33 or v38.IgnoreTransparency
                local v42 = v38.IgnoreMaterial
                local v43 = v38.IgnoreObject
                local v44 = {}
                if v37:IsA("BasePart") then
                    v37.Color = v40.Color or v37.Color
                    v37.Transparency = not v41 and v40.Transparency or v37.Transparency
                    v37.Reflectance = v40.Reflectance or v37.Reflectance
                    v37.Material = (not v42 and (not v41 or v40.Material ~= Enum.Material.ForceField) and true or false) and v40.Material or v37.Material
                    v37.MaterialVariant = not v42 and v40.MaterialVariant or v37.MaterialVariant
                    if v37:IsA("MeshPart") then
                        v37.TextureID = ""
                    end
                    if not v42 then
                        for _, v45 in pairs(v40.Textures and (v_u_7[v40.Textures]:GetChildren() or {}) or {}) do
                            local v46 = v45:Clone()
                            v46.LocalTransparencyModifier = v37.LocalTransparencyModifier
                            v46.Parent = v37
                            local v47 = v38.Cleanup
                            table.insert(v47, v46)
                            table.insert(v44, v46)
                        end
                    end
                elseif v37:IsA("Decal") or v37:IsA("Texture") then
                    v37.Color3 = v40.Color3 or v37.Color3
                    v37.Transparency = not v41 and v40.Transparency or v37.Transparency
                elseif v37:IsA("Beam") or (v37:IsA("Trail") or v37:IsA("ParticleEmitter")) then
                    v37.Color = v40.Color and ColorSequence.new(v40.Color) or v37.Color
                    if not v41 and (not v38.IgnoreTransparency and v40.Transparency) then
                        local v48 = {}
                        for _, v49 in pairs(v37.Transparency.Keypoints) do
                            local v50 = NumberSequenceKeypoint.new
                            local v51 = v49.Time
                            local v52 = v49.Value + (1 - v49.Value) * v40.Transparency
                            table.insert(v48, v50(v51, v52))
                        end
                        v37.Transparency = NumberSequence.new(v48)
                    end
                elseif v37:IsA("Frame") then
                    v37.BackgroundColor3 = v40.Color or v37.BackgroundColor3
                    v37.BackgroundTransparency = not v41 and v40.Transparency or v37.BackgroundTransparency
                elseif v37:IsA("ImageLabel") then
                    v37.ImageColor3 = v40.Color or v37.ImageColor3
                    v37.ImageTransparency = not v41 and v40.Transparency or v37.ImageTransparency
                end
                for _, v_u_53 in pairs(v38.OriginalChildren) do
                    pcall(function()
                        v_u_53.Parent = nil
                    end)
                end
                local v54 = p30:_GetWrapGroupCallback(v40)
                if v54 then
                    v54(v37, v38, v44)
                end
                if not v43 then
                    local v55 = p30:_GetWrapGroupObject(v40)
                    if v55 then
                        local v56 = v55.new(v37, v44)
                        local v57 = p30._wrap_group_objects
                        table.insert(v57, v56)
                        local v58 = v38.Cleanup
                        table.insert(v58, v56)
                    end
                end
            end
        end
    end
end
function v_u_10.Update(p59, p60)
    for v61 = #p59._wrap_group_objects, 1, -1 do
        local v62 = p59._wrap_group_objects[v61]
        if v62.IsDestroyed then
            table.remove(p59._wrap_group_objects, v61)
        elseif v62.Update and v62:IsActive() then
            if v_u_5.IS_STUDIO then
                v62:Update(p60)
            else
                pcall(v62.Update, v62, p60)
            end
        end
    end
end
function v_u_10._GetWrapGroupCallback(p63, p64)
    if not p64.CallbackName then
        return nil
    end
    if not p63._wrap_group_callbacks[p64.CallbackName] then
        p63._wrap_group_callbacks[p64.CallbackName] = require(v_u_8:WaitForChild(p64.CallbackName))
    end
    return p63._wrap_group_callbacks[p64.CallbackName]
end
function v_u_10._GetWrapGroupObject(p65, p66)
    if p66.ObjectName then
        if not p65._wrap_group_classes[p66.ObjectName] then
            p65._wrap_group_classes[p66.ObjectName] = require(v_u_9:WaitForChild(p66.ObjectName))
        end
        return p65._wrap_group_classes[p66.ObjectName]
    end
end
function v_u_10._WrapThis(p67, p68)
    p67:ApplyWrap(p67:RecordOriginalWrapProperties(p68), {
        ["Name"] = p68:GetAttribute("WrapName")
    })
end
function v_u_10._Init(p_u_69)
    v_u_3:BindToRenderStep("WrapController", Enum.RenderPriority.Camera.Value + 1, function(p70)
        p_u_69:Update(p70)
    end)
    v_u_1:GetInstanceAddedSignal("WrapThis"):Connect(function(p71)
        p_u_69:_WrapThis(p71)
    end)
    for _, v72 in pairs(v_u_1:GetTagged("WrapThis")) do
        task.defer(p_u_69._WrapThis, p_u_69, v72)
    end
end
return v_u_10._new()