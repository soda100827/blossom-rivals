local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v_u_3 = game:GetService("RunService")
local v4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Spring)
local v_u_7 = require(v4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_8
    local v10 = setmetatable({}, v9)
    v10.Frame = v_u_7:GetTo("MainFrame", "Spotlight")
    v10._spotlight_hash = 0
    v10._spotlight_connection = nil
    v10._spotlight_reference = nil
    v10._spotlight_transparency = 1
    v10:_Init()
    return v10
end
function v_u_8.GetCurrentReference(p11)
    return p11._spotlight_reference
end
function v_u_8.ChangeSubject(p_u_12, p13, p14)
    if p14 and p_u_12:GetCurrentReference() ~= p14 then
        return
    else
        p_u_12._spotlight_hash = p_u_12._spotlight_hash + 1
        if p_u_12._spotlight_connection then
            p_u_12._spotlight_connection:Disconnect()
            p_u_12._spotlight_connection = nil
        end
        if p_u_12._spotlight_reference then
            local v15 = p_u_12._spotlight_reference
            v15.ZIndex = v15.ZIndex - 1
        end
        p_u_12._spotlight_reference = p13
        if p_u_12._spotlight_reference then
            local v16 = p_u_12._spotlight_reference
            v16.ZIndex = v16.ZIndex + 1
            p_u_12:_SetTransparency(0.75)
            local v_u_17 = v_u_6.new(p_u_12.Frame.AbsolutePosition, 0.875, 25)
            local v_u_18 = v_u_6.new(p_u_12.Frame.AbsoluteSize, 0.875, 25)
            p_u_12._spotlight_connection = v_u_3.RenderStepped:Connect(function()
                v_u_17.Target = p_u_12._spotlight_reference.AbsolutePosition
                v_u_18.Target = p_u_12._spotlight_reference.AbsoluteSize
                local v19 = v_u_17.Value - p_u_12.Frame.Parent.AbsolutePosition
                p_u_12.Frame.Position = UDim2.new(0, v19.X - 8, 0, v19.Y - 8)
                p_u_12.Frame.Size = UDim2.new(0, v_u_18.Value.X + 16, 0, v_u_18.Value.Y + 16)
            end)
        else
            p_u_12:_SetTransparency(1)
        end
    end
end
function v_u_8._UpdateVisibility(p20)
    p20.Frame.Visible = not v_u_2.MenuIsOpen
end
function v_u_8._SetTransparency(p_u_21, p_u_22)
    local v_u_23 = p_u_21._spotlight_hash
    task.spawn(function()
        v_u_5:RenderstepForLoop(0, 100, 4, function(p24)
            if v_u_23 ~= p_u_21._spotlight_hash then
                return true
            end
            p_u_21._spotlight_transparency = p_u_21._spotlight_transparency + (p_u_22 - p_u_21._spotlight_transparency) * (1 - (1 - p24 / 100) ^ 2)
            for _, v25 in pairs(p_u_21.Frame:GetChildren()) do
                if v25:IsA("ImageLabel") then
                    v25.ImageTransparency = p_u_21._spotlight_transparency
                else
                    v25.BackgroundTransparency = p_u_21._spotlight_transparency
                end
            end
        end)
        if v_u_23 == p_u_21._spotlight_hash then
            if p_u_22 >= 1 then
                p_u_21.Frame.Size = UDim2.new(3, 0, 3, 0)
                p_u_21.Frame.Position = UDim2.new(-1, 0, -1, 0)
            end
        end
    end)
end
function v_u_8._Init(p_u_26)
    v_u_2:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
        p_u_26:_UpdateVisibility()
    end)
    p_u_26:_UpdateVisibility()
    p_u_26:ChangeSubject(nil)
end
return v_u_8._new()