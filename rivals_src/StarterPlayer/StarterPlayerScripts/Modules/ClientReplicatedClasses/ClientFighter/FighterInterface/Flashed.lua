game:GetService("CollectionService")
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Lighting")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v_u_1.Modules.BetterDebris)
local v_u_7 = require(v_u_1.Modules.GameplayUtility)
local v_u_8 = require(v_u_1.Modules.Utility)
local v_u_9 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_10 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_11 = require(v_u_5.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_12 = v_u_5.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("FlashbangGui")
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13.new(p14)
    local v15 = v_u_13
    local v16 = setmetatable({}, v15)
    v16.FighterInterface = p14
    v16._default_flash_sound_callback = nil
    v16._default_ringing_sound_callback = nil
    v16._flash_objects = {}
    v16:_Init()
    return v16
end
function v_u_13.AttemptToFlash(p17, p18, p19, p20, p21, p22, p23)
    if not p17:_IsOccluded(p18, p19) then
        p17:Flash(p19, p20, p21, p22, p23)
    end
end
function v_u_13.Flash(p24, p25, p26, p27, p28, p29)
    local v30, v31 = workspace.CurrentCamera:WorldToScreenPoint(p25)
    local v32 = v_u_11:ScreenPointToPosition(Vector2.new(v30.X, v30.Y), p24.FighterInterface.Frame.AbsolutePosition)
    local v33 = UDim2.new
    local v34 = v32.X
    local v35 = -p24.FighterInterface.Frame.AbsoluteSize.X * 0.5
    local v36 = p24.FighterInterface.Frame.AbsoluteSize.X * 1.5
    local v37 = math.clamp(v34, v35, v36)
    local v38 = v32.Y
    local v39 = -p24.FighterInterface.Frame.AbsoluteSize.Y * 0.5
    local v40 = p24.FighterInterface.Frame.AbsoluteSize.Y * 1.5
    local v41 = v33(0, v37, 0, (math.clamp(v38, v39, v40)))
    local v42 = v_u_9:Get("Settings Accessible Flashes")
    local v43 = v42 and -2 or 2
    local v44 = v42 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    local v45 = v42 and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(220, 215, 204)
    local v46 = p28 == "Pixel Flashbang" and "rbxassetid://123806439184095" or "rbxassetid://14796588510"
    local v47 = p28 == "Pixel Flashbang" and 0.75 or 1
    local v48 = p28 == "Pixel Flashbang" and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default
    local v49 = v_u_12:Clone()
    v49.Background.BackgroundColor3 = v44
    v49.Rays1.Position = v41 + UDim2.new(0, math.random(-30, 30), 0, math.random(-30, 30))
    v49.Rays2.Position = v41 + UDim2.new(0, math.random(-30, 30), 0, math.random(-30, 30))
    v49.Rays3.Position = v41 + UDim2.new(0, math.random(-30, 30), 0, math.random(-30, 30))
    v49.Rays1.ResampleMode = v48
    v49.Rays2.ResampleMode = v48
    v49.Rays3.ResampleMode = v48
    v49.Rays1.Image = v46
    v49.Rays2.Image = v46
    v49.Rays3.Image = v46
    v49.Rays1.Size = UDim2.new(v49.Rays1.Size.X.Scale * v47, v49.Rays1.Size.X.Offset * v47, v49.Rays1.Size.Y.Scale * v47, v49.Rays1.Size.Y.Offset * v47)
    v49.Rays2.Size = UDim2.new(v49.Rays2.Size.X.Scale * v47, v49.Rays2.Size.X.Offset * v47, v49.Rays2.Size.Y.Scale * v47, v49.Rays2.Size.Y.Offset * v47)
    v49.Rays3.Size = UDim2.new(v49.Rays3.Size.X.Scale * v47, v49.Rays3.Size.X.Offset * v47, v49.Rays3.Size.Y.Scale * v47, v49.Rays3.Size.Y.Offset * v47)
    v49.Parent = v_u_5.LocalPlayer.PlayerGui
    v_u_6:AddItem(v49, 10)
    local v50 = Instance.new("ColorCorrectionEffect")
    v50.Name = "Flashbang"
    v50.Parent = v_u_4
    v_u_6:AddItem(v50, 10)
    local v51 = Instance.new("Part")
    v51.Size = Vector3.new(10, 10, 0)
    v51.Anchored = true
    v51.CanCollide = false
    v51.CanTouch = false
    v51.CanQuery = false
    v51.Color = v44
    v51.Material = Enum.Material.Neon
    v51.Parent = v31 and workspace or nil
    v_u_6:AddItem(v51, 10)
    local v52 = (p29 or p24._default_ringing_sound_callback)()
    local v53 = p26 * (v31 and 1 or (v30.Z > 0 and 0.125 or 0))
    local v54 = math.max(0.5, v53)
    local v55 = tick()
    local v56 = 0
    if v53 > 0 then
        v_u_1.Remotes.Replication.Fighter.BlindedEffect:FireServer(p27, v53)
    end
    local v57 = p24:_RegisterFlashObjects(v53, v49, v50, v51, v52)
    if p28 == "Camera" and v31 then
        local v58, v59 = pcall(p24._CameraSnapshot, p24, p25, v41, v49, v57)
        if not v58 then
            warn("Camera Flashbang snapshot failed, error:", v59)
        end
    end
    p24:_UpdateVisibility()
    while tick() < v55 + v54 do
        local v60 = (tick() - v55) / v54
        local v61 = math.min(1, v60)
        local v62 = v53 > 0 and v61 and v61 or v61 * 0.25 + 0.75
        local v63 = 0.5 + 0.5 * v62
        local v64
        if p28 == "Disco Ball" then
            v64 = Color3.fromHSV(tick() * 0.5 % 1, 0.75, 1) or v45
        else
            v64 = v45
        end
        local v65 = v64:Lerp(v44, v62)
        if v52 then
            v52.Volume = 1 - v62
        end
        v50.Brightness = v43 + (0 - v43) * v62
        v49.Rays1.ImageTransparency = v63
        v49.Rays2.ImageTransparency = v63
        v49.Rays3.ImageTransparency = v63
        v49.Rays1.ImageColor3 = v65
        v49.Rays2.ImageColor3 = v65
        v49.Rays3.ImageColor3 = v65
        v49.Background.Transparency = not v31 and 1 or v62 ^ 5
        v49.Polaroid.GroupTransparency = 0.25 + 0.75 * v62 ^ 2
        local v66 = v62 - 0.25
        v51.Transparency = math.max(0, v66) / 0.75
        v51.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -1)
        if p28 == "Pixel Flashbang" then
            v49.Rays1.Position = v41 + UDim2.new(0, math.random(-30, 30) * v47, 0, math.random(-30, 30) * v47)
            v49.Rays2.Position = v41 + UDim2.new(0, math.random(-30, 30) * v47, 0, math.random(-30, 30) * v47)
            v49.Rays3.Position = v41 + UDim2.new(0, math.random(-30, 30) * v47, 0, math.random(-30, 30) * v47)
        else
            local v67 = v49.Rays1
            v67.Rotation = v67.Rotation + v56 * 0.5 * 60
            local v68 = v49.Rays2
            v68.Rotation = v68.Rotation - v56 * 0.25 * 60
            local v69 = v49.Rays3
            v69.Rotation = v69.Rotation + v56 * 0.37237 * 60
        end
        v56 = v_u_3.RenderStepped:Wait()
    end
    v51:Destroy()
    v50:Destroy()
    v49:Destroy()
end
function v_u_13.Destroy(p70)
    for _, v71 in pairs(p70._flash_objects) do
        for _, v72 in pairs(v71) do
            v72[1]:Destroy()
        end
    end
    p70._flash_objects = {}
end
function v_u_13._CameraSnapshot(p73, p74, p75, p76, p77)
    local v78 = v_u_10.CurrentSubject and v_u_10.CurrentSubject.Entity
    if v78 then
        v78 = v_u_10.CurrentSubject:CloneFighterModel()
    end
    if v78 then
        local v79 = v78:FindFirstChild("face", true)
        if v79 and v79:IsA("Decal") then
            v79.Texture = "rbxassetid://18983839334"
        end
        local v80 = Instance.new("Camera")
        v80.CFrame = CFrame.new(v78.Head.Position + (p74 - v78.Head.Position).Unit * 8, v78.Head.Position)
        v80.FieldOfView = 35
        p76.Polaroid.Visible = true
        p76.Polaroid.Picture.BackgroundColor3 = Color3.fromHSV(math.random(), 0.756, 0.56)
        p76.Polaroid.Picture.ViewportFrame.LightDirection = v80.CFrame.LookVector
        p76.Polaroid.Picture.ViewportFrame.CurrentCamera = v80
        p76.Polaroid.Rotation = 180
        p76.Polaroid.Position = UDim2.new(math.random(), 0, 1.5, 0)
        p76.Polaroid:TweenPosition(p75, "Out", "Quint", 1, true)
        v_u_2:Create(p76.Polaroid, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Rotation"] = 1080 + 45 * (math.random() - 0.5)
        }):Play()
        v80.Parent = p76.Polaroid.Picture.ViewportFrame
        v78.Parent = p76.Polaroid.Picture.ViewportFrame.WorldModel
        for _, v81 in pairs(v78:GetDescendants()) do
            if v81:IsA("BasePart") then
                v81.Anchored = true
            end
        end
        p73:_RegisterFlashObject(p77, v78)
        p73:_RegisterFlashObject(p77, v80)
        return v78, v80
    end
end
function v_u_13._IsOccluded(p82, p83, p84)
    local v85 = p83 or {}
    if p82.FighterInterface.ClientFighter.Entity then
        local v86 = p82.FighterInterface.ClientFighter.Entity.Model
        table.insert(v85, v86)
    end
    while true do
        local v87 = v_u_8:Raycast(workspace.CurrentCamera.CFrame.Position, p84, (workspace.CurrentCamera.CFrame.Position - p84).Magnitude, v85, Enum.RaycastFilterType.Exclude)
        if not v87.Instance or (v87.Instance.CanCollide or v87.Instance:HasTag("SmokeCloud")) then
            break
        end
        local v88 = v87.Instance
        table.insert(v85, v88)
    end
    return v87.Instance and true or #v_u_7:GetSmokeCloudsInSphere(p84) > 0
end
function v_u_13._RegisterFlashObject(_, p89, p90)
    local v91 = { p90, p90.Parent }
    table.insert(p89, v91)
end
function v_u_13._RegisterFlashObjects(p_u_92, p93, ...)
    local v_u_94 = {}
    for _, v95 in pairs({ ... }) do
        p_u_92:_RegisterFlashObject(v_u_94, v95)
    end
    local v96 = p_u_92._flash_objects
    table.insert(v96, v_u_94)
    task.delay(p93, function()
        local v97 = table.find(p_u_92._flash_objects, v_u_94)
        if v97 then
            table.remove(p_u_92._flash_objects, v97)
        end
    end)
    return v_u_94
end
function v_u_13._UpdateVisibility(p_u_98)
    for _, v99 in pairs(p_u_98._flash_objects) do
        for _, v_u_100 in pairs(v99) do
            pcall(function()
                v_u_100[1].Parent = p_u_98.FighterInterface:IsActive() and v_u_100[2] or nil
            end)
        end
    end
end
function v_u_13._Setup(p101)
    function p101._default_ringing_sound_callback()
        return v_u_8:CreateSound("rbxassetid://14778230632", 1, 1, script, true, 10)
    end
end
function v_u_13._Init(p_u_102)
    p_u_102.FighterInterface.ActiveChanged:Connect(function()
        p_u_102:_UpdateVisibility()
    end)
    p_u_102:_Setup()
end
return v_u_13