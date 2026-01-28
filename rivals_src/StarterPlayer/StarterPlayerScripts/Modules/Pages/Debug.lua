local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.DebugLibrary)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DebugController"))
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("HotkeysSettingContainer")
local v_u_9 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmptySlot")
local v_u_10 = v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings")
local v_u_11 = setmetatable({}, v_u_8)
v_u_11.__index = v_u_11
function v_u_11._new()
    local v12 = v_u_8.new(script.Name)
    local v13 = v_u_11
    local v14 = setmetatable(v12, v13)
    v14.CloseButton = v14.PageFrame:WaitForChild("Close")
    v14.PromptsFrame = v14.PageFrame:WaitForChild("Prompts")
    v14.List = v14.PageFrame:WaitForChild("List")
    v14.Container = v14.List:WaitForChild("Container")
    v14.Layout = v14.Container:WaitForChild("Layout")
    v14.PromptSystem = v_u_7.new(v14.PromptsFrame)
    v14.SettingObjects = {}
    v14:_Init()
    return v14
end
function v_u_11._Setup(p_u_15)
    local v_u_16 = 0
    local function v19(p_u_17)
        local v_u_18 = require(v_u_10:WaitForChild(p_u_17.InputType)).new(p_u_17)
        v_u_18.Replicate:Connect(function()
            v_u_5:Command(p_u_17.Name, v_u_18.Value)
        end)
        v_u_18.SettingFrame.LayoutOrder = v_u_16
        v_u_18.SettingFrame.Parent = p_u_15.Container
        p_u_15.SettingObjects[p_u_17.Name] = v_u_18
        v_u_16 = v_u_16 + 1
    end
    local function v24(p20)
        local v21 = p20 or 0
        local v22 = v21 - v_u_16
        for _ = 1, math.max(0, v22) + 2 - (v21 >= v_u_16 and 0 or (v_u_16 - 1) % 2 + 1) do
            local v23 = v_u_9:Clone()
            v23.LayoutOrder = v_u_16
            v23.Parent = p_u_15.Container
            v_u_16 = v_u_16 + 1
        end
    end
    local v25 = v_u_16
    local v26 = false
    for _, v27 in pairs(v_u_3.Order) do
        if v_u_3:HasAccessToCommand(v_u_2.LocalPlayer.UserId, v_u_4:Get("GroupRank"), v27.Name) then
            if v27.InputType == "Divider" then
                if v26 then
                    v24()
                    for _ = 1, v25 % 2 + 2 do
                        v19(v27)
                    end
                end
            else
                v19(v27)
                v26 = true
            end
        end
    end
    v24(16)
end
function v_u_11._Init(p_u_28)
    p_u_28.CloseButton.MouseButton1Click:Connect(function()
        p_u_28:CloseRequest()
    end)
    p_u_28.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_28.List.CanvasSize = UDim2.new(0, 0, 0, p_u_28.Layout.AbsoluteContentSize.Y)
    end)
    p_u_28:_Setup()
    v_u_6:Add(p_u_28.CloseButton)
end
return v_u_11._new()