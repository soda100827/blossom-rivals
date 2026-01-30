local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.SettingsLibrary)
local v_u_5 = require(v_u_2.Modules.InputLibrary)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_8 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("KeybindSlot")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new()
    local v10 = v_u_9
    local v11 = setmetatable({}, v10)
    v11._objects = {}
    v11._generate_hashes = {}
    v11:_Init()
    return v11
end
function v_u_9._ObjectRemoved(p12, p13)
    p12._generate_hashes[p13] = (p12._generate_hashes[p13] or 0) + 1
    if p12._objects[p13] then
        p12._objects[p13].Slot:Destroy()
        p12._objects[p13] = nil
    end
end
function v_u_9._ObjectAdded(p14, p15)
    p14:_ObjectRemoved(p15)
    if p15:IsDescendantOf(v_u_3.LocalPlayer.PlayerGui) or p15:IsDescendantOf(workspace) or (p15:IsDescendantOf(v_u_2) or p15:IsDescendantOf(v_u_3.LocalPlayer.PlayerScripts.Assets.Temp)) then
        local v16 = p14._generate_hashes[p15]
        local v17 = p15:GetAttribute("InputName")
        local v18 = p15:GetAttribute("EnumType")
        local v19 = p15:GetAttribute("EnumName")
        local v20, v21, v22, v23
        if v18 and (v18 ~= "" and (v19 and v19 ~= "")) then
            v20, v21, v22 = v_u_5:GetInputIcons(v18, v19)
            v23 = Enum[v18][v19]
        else
            if not v17 or v17 == "" then
                return
            end
            v20, v21, v22 = v_u_5:GetInputIconsByInputName(v17)
            v23 = v_u_5:FindFirstEnum(v17)
        end
        if v23 then
            if v16 == p14._generate_hashes[p15] then
                local v24 = v_u_8:Clone()
                v24.Icon.Image = v20
                v24.Icon.Title.Text = v22
                v24.Name = v16
                v24.Parent = p15
                p14._objects[p15] = {
                    ["Enum"] = v23,
                    ["Icon"] = v20,
                    ["PressedIcon"] = v21,
                    ["InputString"] = v22,
                    ["Slot"] = v24
                }
            end
        else
            return
        end
    else
        return
    end
end
function v_u_9._AddAllObjects(p25)
    for _, v26 in pairs(v_u_1:GetTagged("UIKeybindContainer")) do
        p25:_ObjectAdded(v26)
    end
end
function v_u_9._Init(p_u_27)
    v_u_1:GetInstanceRemovedSignal("UIKeybindContainer"):Connect(function(p28)
        p_u_27:_ObjectRemoved(p28)
    end)
    v_u_1:GetInstanceAddedSignal("UIKeybindContainer"):Connect(function(p29)
        p_u_27:_ObjectAdded(p29)
    end)
    v_u_7.InputBegan:Connect(function(p30)
        for _, v31 in pairs(p_u_27._objects) do
            if v31.Enum == p30.KeyCode or v31.Enum == p30.UserInputType then
                v31.Slot.Icon.Image = v31.PressedIcon
                v31.Slot.Icon.Title.Position = UDim2.new(0.5, 0, 0.525, 0)
            end
        end
    end)
    v_u_7.InputEnded:Connect(function(p32)
        for _, v33 in pairs(p_u_27._objects) do
            if v33.Enum == p32.KeyCode or v33.Enum == p32.UserInputType then
                v33.Slot.Icon.Image = v33.Icon
                v33.Slot.Icon.Title.Position = UDim2.new(0.5, 0, 0.45, 0)
            end
        end
    end)
    v_u_7.ControlsChanged:Connect(function()
        p_u_27:_AddAllObjects()
    end)
    for v34, v35 in pairs(v_u_4.Info) do
        if v35.InputType == "Hotkey" then
            v_u_6:GetDataChangedSignal(v34):Connect(function()
                p_u_27:_AddAllObjects()
            end)
        end
    end
    task.spawn(p_u_27._AddAllObjects, p_u_27)
end
return v_u_9._new()