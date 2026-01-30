local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
local v_u_4 = require(v2.Modules.ItemLibrary)
require(v2.Modules.Utility)
local v_u_5 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("StatusTextOverlay")
local v_u_6 = {
    "Text",
    "RichText",
    "FontFace",
    "TextXAlignment",
    "TextYAlignment",
    "TextTransparency"
}
local v_u_7 = { "ImageTransparency", "ScaleType", "Image" }
local v_u_8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(253, 255, 114)),
    ColorSequenceKeypoint.new(0.384, Color3.fromRGB(252, 251, 108)),
    ColorSequenceKeypoint.new(0.768, Color3.fromRGB(237, 186, 14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 177, 2))
})
local v_u_9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(154, 114, 255)),
    ColorSequenceKeypoint.new(0.384, Color3.fromRGB(149, 108, 252)),
    ColorSequenceKeypoint.new(0.768, Color3.fromRGB(77, 14, 237)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 2, 235))
})
local v_u_10 = Color3.fromRGB(64, 64, 64)
local v_u_11 = Color3.fromRGB(127, 127, 127)
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_12
    local v14 = setmetatable({}, v13)
    v14._connections = {}
    v14:_Init()
    return v14
end
function v_u_12.ApplyItemStatusToText(p15, p16, p17)
    if p17 == "Prime" then
        local v18 = p15:_CreateTextOverlay(p16, v_u_8)
        v18.Cover:Destroy()
        v18.Shine:AddTag("UISparkleEffect")
        v18.Shine:AddTag("UIShinyText")
    elseif p17 == "Contraband" then
        local v19 = p15:_CreateTextOverlay(p16, v_u_9)
        v19.Highlight:AddTag("UIGlitchEffect")
        v19.Shine.TextColor3 = Color3.fromRGB(0, 0, 0)
        v19.Shine:SetAttribute("IsDoubleFlash", true)
        v19.Shine:AddTag("UIShinyText")
    end
end
function v_u_12.ApplyItemStatusToBackground(p20, p21, p22, p23)
    p20:_RecolorBackground(p21, p22, p23)
    if p23 == "Prime" then
        p21:AddTag("UISparkleEffect")
    elseif p23 == "Contraband" then
        p21:AddTag("UIGlitchEffect")
    end
end
function v_u_12.ApplyItemStatusToImage(p24, p25, p26)
    if p26 == "Prime" then
        p24:_CreateImageOverlay(p25, v_u_8):AddTag("UISparkleEffect")
    elseif p26 == "Contraband" then
        p24:_CreateImageOverlay(p25, v_u_9):AddTag("UIGlitchEffect")
    end
end
function v_u_12.ClearStatusElements(_, p27)
    for _, v28 in pairs(p27:GetChildren()) do
        if v28:HasTag("WeaponStatusElement") then
            v28:Destroy()
        end
    end
end
function v_u_12._CreateTextOverlay(p29, p30, p31)
    local v32 = v_u_5:Clone()
    v32.Highlight.UIGradient.Color = p31
    p29:_CopyElement(v32.Cover, p30, v_u_6)
    p29:_CopyElement(v32.Highlight, p30, v_u_6)
    p29:_CopyElement(v32.Shine, p30, v_u_6)
    p29:_TagStatusElement(v32)
    v32.Parent = p30
    local v_u_33 = v32.Highlight
    local v_u_34 = v_u_33.UIStroke
    local function v39()
        v_u_34.Transparency = v_u_33.TextTransparency
        local v35 = v_u_34
        local v36 = v_u_11
        local v37 = v_u_10
        local v38 = v_u_33.TextTransparency / 0.25
        v35.Color = v36:Lerp(v37, (math.clamp(v38, 0, 1)))
    end
    v_u_33:GetPropertyChangedSignal("TextTransparency"):Connect(v39)
    v_u_34.Transparency = v_u_33.TextTransparency
    local v40 = v_u_11
    local v41 = v_u_10
    local v42 = v_u_33.TextTransparency / 0.25
    v_u_34.Color = v40:Lerp(v41, (math.clamp(v42, 0, 1)))
    return v32
end
function v_u_12._CreateImageOverlay(p43, p44, p45)
    local v46 = Instance.fromExisting(p44)
    v46.Size = UDim2.new(1, 0, 1, 0)
    v46.AnchorPoint = Vector2.new(0.5, 0.5)
    v46.Position = UDim2.new(0.5, 0, 0.5, 0)
    v46.Active = false
    v46.Interactable = false
    v46.Selectable = false
    v46.SizeConstraint = Enum.SizeConstraint.RelativeXY
    v46.ImageColor3 = Color3.fromRGB(255, 255, 255)
    local v47 = Instance.new("UIGradient")
    v47.Rotation = 90
    v47.Color = p45
    v47.Parent = v46
    p43:_CopyElement(v46, p44, v_u_7)
    p43:_TagStatusElement(v46)
    v46.Parent = p44
    return v46
end
function v_u_12._RecolorBackground(_, p48, p49, p50)
    local v51 = v_u_4.Statuses[p50]
    if v51 then
        if p48:IsA("ImageLabel") then
            p48.ImageColor3 = v51.Color
        end
        p48.BackgroundColor3 = v51.Color
        p49.Color = v51.Color
    end
end
function v_u_12._TagStatusElement(_, p52)
    p52:AddTag("WeaponStatusElement")
    p52.Name = "_ITEMSTATUSCLONE"
end
function v_u_12._CopyElement(p_u_53, p_u_54, p_u_55, p56)
    if not p_u_53._connections[p_u_54] then
        p_u_53._connections[p_u_54] = {}
        local v57 = p_u_53._connections[p_u_54]
        local v58 = p_u_54.Destroying
        table.insert(v57, v58:Connect(function()
            for _, v59 in pairs(p_u_53._connections[p_u_54] or {}) do
                v59:Disconnect()
            end
            p_u_53._connections[p_u_54] = nil
        end))
    end
    for _, v_u_60 in pairs(p56) do
        local v61 = p_u_53._connections[p_u_54]
        local v62 = p_u_55:GetPropertyChangedSignal(v_u_60)
        table.insert(v61, v62:Connect(function()
            p_u_54[v_u_60] = p_u_55[v_u_60]
        end))
        p_u_54[v_u_60] = p_u_55[v_u_60]
    end
end
function v_u_12._ObjectAdded(p63, p64)
    local v65 = p64:GetAttribute("Status")
    local v66 = v_u_4.Statuses[v65] ~= nil
    assert(v66, p64:GetFullName())
    p63:ClearStatusElements(p64)
    if p64:IsA("TextLabel") then
        p63:ApplyItemStatusToText(p64, v65)
    else
        assert(false, p64:GetFullName())
    end
end
function v_u_12._Init(p_u_67)
    v_u_1:GetInstanceAddedSignal("ApplyWeaponStatus"):Connect(function(p68)
        p_u_67:_ObjectAdded(p68)
    end)
    for _, v69 in pairs(v_u_1:GetTagged("ApplyWeaponStatus")) do
        task.defer(p_u_67._ObjectAdded, p_u_67, v69)
    end
end
return v_u_12._new()