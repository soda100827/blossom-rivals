local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.Spring)
require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_5 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("PageSystem"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10.Part = Instance.new("Part")
    v10.SurfaceGui = Instance.new("SurfaceGui")
    v10.PagesFrame = Instance.new("Frame")
    v10.PageSystem = v_u_7.new(v10.PagesFrame)
    v10._previous_part_offset = CFrame.identity
    v10._part_offset = nil
    v10._offset_spring = v_u_4.new(1, 1, 15)
    v10._raycast_params = RaycastParams.new()
    v10._next_raycast = 0
    v10:_Init()
    return v10
end
function v_u_8._Debug(p_u_11)
    v_u_2.RenderStepped:Connect(function()
        p_u_11:_Update()
    end)
    v_u_6.Frame.Visible = false
    v_u_6.PageSystem.PageOpened:Connect(function()
        p_u_11.PageSystem:OpenPage(v_u_6.PageSystem.CurrentPage.Name)
    end)
    v_u_6.PageSystem.PageClosed:Connect(function()
        p_u_11.PageSystem:CloseCurrentPage()
    end)
end
function v_u_8._Update(p12)
    local v13 = v_u_5:GetCameraCFrame()
    if p12._offset_spring.Value >= 0.75 and (not p12._part_offset or tick() > p12._next_raycast and not workspace:Raycast(v13.Position, v13.LookVector * 20, p12._raycast_params)) then
        p12._previous_part_offset = p12._previous_part_offset:Lerp(p12._part_offset or CFrame.identity, p12._offset_spring.Value)
        p12._part_offset = workspace.CurrentCamera.CFrame.Rotation * CFrame.new(0, 0, -7)
        p12._offset_spring.Value = 0
        p12._next_raycast = tick() + 0.25
    end
    p12.Part.CFrame = CFrame.new(v13.Position) * p12._previous_part_offset:Lerp(p12._part_offset, p12._offset_spring.Value)
end
function v_u_8._Setup(p14)
    p14.Part.Color = Color3.fromRGB(0, 0, 0)
    p14.Part.Transparency = 1
    p14.Part.Size = Vector3.new(16, 9, 1)
    p14.Part.Anchored = true
    p14.Part.CastShadow = false
    p14.Part.CanCollide = false
    p14.Part.CanTouch = false
    p14.Part.CanQuery = true
    p14.Part.Name = "Panel"
    p14.Part.Parent = workspace
    p14.SurfaceGui.MaxDistance = 100
    p14.SurfaceGui.Adornee = p14.Part
    p14.SurfaceGui.AlwaysOnTop = false
    p14.SurfaceGui.LightInfluence = 0
    p14.SurfaceGui.Brightness = 2
    p14.SurfaceGui.Name = "PanelsGui"
    p14.SurfaceGui.Face = Enum.NormalId.Back
    p14.SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    p14.SurfaceGui.PixelsPerStud = 100
    p14.SurfaceGui.ResetOnSpawn = false
    p14.SurfaceGui.Parent = v_u_3.LocalPlayer:WaitForChild("PlayerGui")
    p14.PagesFrame.Size = UDim2.new(1, 0, 1, 0)
    p14.PagesFrame.BackgroundTransparency = 1
    p14.PagesFrame.Name = "Pages"
    p14.PagesFrame.Parent = p14.SurfaceGui
    p14._raycast_params = RaycastParams.new()
    p14._raycast_params.FilterType = Enum.RaycastFilterType.Include
    p14._raycast_params.FilterDescendantsInstances = { p14.Part }
    p14._raycast_params.BruteForceAllSlow = true
    p14._raycast_params.IgnoreWater = true
end
function v_u_8._Init(p_u_15)
    p_u_15.PageSystem.PageOpened:Connect(function(p16)
        local v17 = p16.PageFrame:FindFirstChildOfClass("UIAspectRatioConstraint")
        local v18 = v17 and v17.AspectRatio or p16.PageFrame.Size.X.Scale / p16.PageFrame.Size.Y.Scale
        local v19 = p_u_15.Part
        local v20 = 8 / v18
        v19.Size = Vector3.new(8, v20, 1)
        p16.PageFrame.Size = UDim2.new(0, 0, 0, 0)
        p16.PageFrame.Position = UDim2.new(0.5, 0, 1, 0)
        p16.PageFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.5, true)
        p16.PageFrame:TweenSize(UDim2.new(0.75, 0, 0.75, 0), "Out", "Quint", 0.25, true)
    end)
    p_u_15:_Setup()
end
return v_u_8._new()