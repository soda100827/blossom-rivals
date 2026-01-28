game:GetService("HttpService")
local v_u_1 = game:GetService("RunService")
game:GetService("Lighting")
local _ = CFrame.new(0, 0, -1.1) * CFrame.Angles(0, 1.5707963267948966, 0)
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3)
    local v4 = v_u_2
    local v5 = setmetatable({}, v4)
    v5.ItemInterface = p3
    v5.CanvasGroup = Instance.new("CanvasGroup")
    v5.CanvasGroupUICorner = Instance.new("UICorner")
    v5.CanvasGroupImage = v5.ItemInterface.Mouse.Scope.BlurImage:Clone()
    v5._glass = Instance.new("Part")
    v5._dof = Instance.new("DepthOfFieldEffect")
    v5._glass_renderstep_id = nil
    v5:_Init()
    return v5
end
function v_u_2.SetShape(p6, p7)
    p6._glass.Shape = p7
    p6.ItemInterface.Mouse.Scope.Frame.Size = p7 == Enum.PartType.Block and UDim2.new(0.875, 0, 0.875, 0) or UDim2.new(1, 0, 1, 0)
    p6.ItemInterface.Mouse.Scope.CircleImage.Image = p7 == Enum.PartType.Block and "rbxassetid://85501091107884" or "rbxassetid://128819262942122"
    p6.CanvasGroupUICorner.CornerRadius = p7 == Enum.PartType.Block and UDim.new(0, 0) or UDim.new(1, 0)
    p6.CanvasGroupImage.Image = p7 == Enum.PartType.Block and "rbxassetid://102865472475647" or "rbxassetid://13466088854"
end
function v_u_2.Refresh(p8)
    if p8._glass_renderstep_id then
        v_u_1:UnbindFromRenderStep(p8._glass_renderstep_id)
        p8._glass_renderstep_id = nil
    end
    p8._glass.Parent = nil
    p8._dof.Parent = nil
end
function v_u_2.Destroy(p9)
    if p9._glass_renderstep_id then
        v_u_1:UnbindFromRenderStep(p9._glass_renderstep_id)
        p9._glass_renderstep_id = nil
    end
    p9._glass:Destroy()
    p9._dof:Destroy()
end
function v_u_2._Setup(p10)
    p10._glass.Color = Color3.fromRGB(255, 255, 255)
    p10._glass.Material = Enum.Material.Glass
    p10._glass.Transparency = 0.999
    p10._glass.Anchored = true
    p10._glass.CanCollide = false
    p10._glass.CanQuery = false
    p10._glass.CanTouch = false
    p10._glass.CastShadow = false
    p10._glass.Name = "CrossbowScope"
    p10._dof.FarIntensity = 1
    p10._dof.FocusDistance = 0
    p10._dof.InFocusRadius = 0.2
    p10._dof.NearIntensity = 0
    p10._dof.Name = "CrossbowScope"
    p10.ItemInterface.Mouse.Scope.CircleImageBottom.Visible = false
    p10.ItemInterface.Mouse.Scope.CircleImageTop.Visible = false
    p10.ItemInterface.Mouse.Scope.CircleImageLeft.Visible = false
    p10.ItemInterface.Mouse.Scope.CircleImageRight.Visible = false
    p10.ItemInterface.Mouse.Scope.BlurImage.Visible = false
    p10.ItemInterface.Mouse.Scope.ReticleContainerBottom.Size = UDim2.new(0, 4, 0.25, 0)
    p10.ItemInterface.Mouse.Scope.ReticleContainerTop.Size = UDim2.new(0, 4, 0.25, 0)
    p10.ItemInterface.Mouse.Scope.ReticleContainerLeft.Size = UDim2.new(0.25, 0, 0, 4)
    p10.ItemInterface.Mouse.Scope.ReticleContainerRight.Size = UDim2.new(0.25, 0, 0, 4)
    p10.CanvasGroup.BackgroundTransparency = 1
    p10.CanvasGroup.Size = UDim2.new(1, 0, 1, 0)
    p10.CanvasGroup.Parent = p10.ItemInterface.Mouse.Scope.Frame
    p10.CanvasGroupUICorner.Parent = p10.CanvasGroup
    p10.CanvasGroupImage.Parent = p10.CanvasGroup
    p10:SetShape(Enum.PartType.Cylinder)
    if p10.ItemInterface.ClientItem.ViewModel.Name == "Pixel Crossbow" then
        p10.CanvasGroupImage.Image = "rbxassetid://18171031143"
        p10.CanvasGroupImage.ResampleMode = Enum.ResamplerMode.Pixelated
    end
end
function v_u_2._Init(p_u_11)
    p_u_11.ItemInterface.Mouse.Scope.ActiveChanged:Connect(function()
        p_u_11:Refresh()
    end)
    p_u_11.ItemInterface.ActiveChanged:Connect(function()
        p_u_11:Refresh()
    end)
    p_u_11.ItemInterface.Mouse.Scope.BlurFrame:GetPropertyChangedSignal("Position"):Connect(function()
        p_u_11.CanvasGroupImage.Position = p_u_11.ItemInterface.Mouse.Scope.BlurFrame.Position
    end)
    p_u_11.ItemInterface.Mouse.Scope.BlurFrame:GetPropertyChangedSignal("Size"):Connect(function()
        p_u_11.CanvasGroupImage.Size = p_u_11.ItemInterface.Mouse.Scope.BlurFrame.Size
    end)
    p_u_11:_Setup()
    p_u_11:Refresh()
end
return v_u_2