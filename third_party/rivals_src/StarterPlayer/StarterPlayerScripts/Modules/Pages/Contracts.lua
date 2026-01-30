local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ContractsLibrary)
require(v1.Modules.ItemLibrary)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseContractSlot"):WaitForChild("ContractSlot"))
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_7 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ContractDivider")
local v_u_8 = setmetatable({}, v_u_6)
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_6.new(script.Name)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.CloseButton = v11.PageFrame:WaitForChild("Close")
    v11.List = v11.PageFrame:WaitForChild("List")
    v11.Container = v11.List:WaitForChild("Container")
    v11.Layout = v11.Container:WaitForChild("Layout")
    v11._weapon_name = nil
    v11._contract_slots = {}
    v11:_Init()
    return v11
end
function v_u_8.SetWeapon(p12, p13)
    p12._weapon_name = p13
    p12:_Update()
end
function v_u_8._Update(p14)
    for _, v15 in pairs(p14._contract_slots) do
        v15:Destroy()
    end
    p14._contract_slots = {}
    if p14._weapon_name then
        local v16 = 0
        for v17, v18 in pairs(v_u_3:GetWeaponContracts(p14._weapon_name)) do
            if v17 > 1 then
                local v19 = v_u_7:Clone()
                v19.LayoutOrder = v16
                v19.Parent = p14.Container
                local v20 = p14._contract_slots
                table.insert(v20, v19)
                v16 = v16 + 1
            end
            local v21 = v_u_4.new("WeaponStatistics", v18)
            v21.Frame.LayoutOrder = v16
            v21.Frame.Parent = p14.Container
            local v22 = p14._contract_slots
            table.insert(v22, v21)
            v16 = v16 + 1
        end
    end
end
function v_u_8._Init(p_u_23)
    p_u_23.CloseButton.MouseButton1Click:Connect(function()
        p_u_23:CloseRequest()
    end)
    p_u_23.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_23.List.CanvasSize = UDim2.new(0, 0, 0, p_u_23.Layout.AbsoluteContentSize.Y)
    end)
    p_u_23:_Update()
    v_u_5:Add(p_u_23.CloseButton)
end
return v_u_8._new()