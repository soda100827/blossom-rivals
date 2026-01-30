local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.Spring)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.ActiveChanged = v_u_4.new()
    v8.Mouse = p6
    v8.Frame = v8.Mouse.Frame:WaitForChild("Scope")
    v8.BlurFrame = v8.Frame:WaitForChild("Blur")
    v8.BlurImage = v8.BlurFrame:WaitForChild("ImageLabel")
    v8.ReticleFrame = v8.Frame:WaitForChild("Reticle")
    v8.ReticleContainer = v8.ReticleFrame:WaitForChild("Container")
    v8.ReticleContainerBottom = v8.ReticleContainer:WaitForChild("Bottom")
    v8.ReticleContainerTop = v8.ReticleContainer:WaitForChild("Top")
    v8.ReticleContainerLeft = v8.ReticleContainer:WaitForChild("Left")
    v8.ReticleContainerRight = v8.ReticleContainer:WaitForChild("Right")
    v8.ReticleDot = v8.ReticleContainer:WaitForChild("Dot")
    v8.ReticleDotUICorner = v8.ReticleDot:WaitForChild("UICorner")
    v8.CircleFrame = v8.Frame:WaitForChild("Circle")
    v8.CircleImage = v8.CircleFrame:WaitForChild("ImageLabel")
    v8.CircleImageBottom = v8.CircleImage:WaitForChild("Bottom")
    v8.CircleImageTop = v8.CircleImage:WaitForChild("Top")
    v8.CircleImageLeft = v8.CircleImage:WaitForChild("Left")
    v8.CircleImageRight = v8.CircleImage:WaitForChild("Right")
    v8._destroyed = false
    v8._is_scope_active = false
    v8._dont_rotate_scope_while_sliding = false
    v8._scope_dot_spring = v_u_3.new(1, 1, 50)
    v8:_Init()
    return v8
end
function v_u_5.IsActive(p9)
    return p9._is_scope_active
end
function v_u_5.SetActive(p10, p11)
    if p10._destroyed then
        return
    else
        local v12 = typeof(p11) == "boolean"
        assert(v12, "Argument 1 invalid, expected a boolean")
        p10._is_scope_active = p11
        p10.ActiveChanged:Fire()
        local v13 = p10.Frame
        local v14 = p10._is_scope_active
        if v14 then
            v14 = v_u_2.DEVICE ~= "VR"
        end
        v13.Visible = v14
        if p10._is_scope_active then
            p10.BlurFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
            p10.BlurFrame:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quint", 0.5 / (p10.Mouse.ItemInterface.ClientItem.Info.AimSpeed or 1), true)
            p10.BlurFrame.Position = UDim2.new(0.75, 0, 0.75, 0)
            p10.BlurFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.375, true)
        end
    end
end
function v_u_5.Update(p15, _, _, _)
    if p15._is_scope_active then
        if p15._dont_rotate_scope_while_sliding then
            p15.Frame.Rotation = -p15.Mouse.Frame.Rotation
            p15.ReticleFrame.Rotation = p15.Mouse.Frame.Rotation
        end
        local v16 = p15.Mouse.ItemInterface.ClientItem.ViewModel.CurrentLandingValue
        local v17 = p15.Mouse.ItemInterface.ClientItem.ViewModel.CurrentJumpValue * 0.0025 - v16 * 0.125
        p15.BlurImage.Position = UDim2.new(0.5, 0, 0.5 + v17, 0)
        local v18 = p15.Mouse.ItemInterface.ClientItem.ClientFighter:GetCameraData(nil, nil, true)
        local v19 = v18[utf8.char(2)]
        local v20 = v18[utf8.char(3)]
        local v21 = not v19 and (1 / 0) or (workspace.CurrentCamera.CFrame.Position - (v19.CFrame * v20).Position).Magnitude
        local v22 = p15._scope_dot_spring
        local v23 = v21 / 50
        v22.Target = 12 / math.max(1, v23)
        local v24 = p15._scope_dot_spring.Value / 8
        p15.ReticleDot.Size = UDim2.new(0.008 * v24, 0, 0.008 * v24, 0)
    end
end
function v_u_5.Destroy(p25)
    p25._destroyed = true
    p25.ActiveChanged:Destroy()
end
function v_u_5._Setup(p26)
    if p26.Mouse.ItemInterface.ClientItem.ViewModel.Name == "Pixel Sniper" then
        p26.BlurImage.Image = "rbxassetid://18171031143"
        p26.BlurImage.ResampleMode = Enum.ResamplerMode.Pixelated
        p26.CircleImage.Image = "rbxassetid://18171045114"
        p26.CircleImage.ResampleMode = Enum.ResamplerMode.Pixelated
        p26.ReticleDotUICorner:Destroy()
        return
    elseif p26.Mouse.ItemInterface.ClientItem.ViewModel.Name == "Keyper" then
        p26.BlurImage.Image = "rbxassetid://129335242148588"
        p26.BlurImage.Size = UDim2.new(1.25, 0, 1.25, 0)
        p26.CircleImage.Image = "rbxassetid://81498448678518"
        p26.CircleImage.Size = UDim2.new(1.25, 0, 1.25, 0)
        p26._dont_rotate_scope_while_sliding = true
    elseif p26.Mouse.ItemInterface.ClientItem.ViewModel.Name == "Pixel Crossbow" then
        p26.CircleImage.Image = "rbxassetid://97622703342015"
        p26.CircleImage.ResampleMode = Enum.ResamplerMode.Pixelated
        p26.ReticleDotUICorner:Destroy()
    end
end
function v_u_5._Init(p27)
    p27:_Setup()
end
return v_u_5