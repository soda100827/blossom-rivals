local v_u_1 = game:GetService("GuiService")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3)
    local v4 = v_u_2
    local v5 = setmetatable({}, v4)
    v5.ItemInterface = p3
    v5.AimingVignette = v5.ItemInterface.Frame:WaitForChild("AimingVignette")
    v5:_Init()
    return v5
end
function v_u_2.Update(p6, _, _, _)
    p6.AimingVignette.ImageTransparency = 1 - p6.ItemInterface.ClientItem.ViewModel.CurrentAimValue
end
function v_u_2.Destroy(_) end
function v_u_2._Setup(p7)
    p7.AimingVignette.Size = UDim2.new(1, 0, 1, v_u_1:GetGuiInset().Y)
end
function v_u_2._Init(p8)
    p8:_Setup()
end
return v_u_2