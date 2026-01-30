local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.SettingsInfo)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_6 = v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings")
local v_u_7 = {
    { "QueueName", "QueueName", "Dropdown" },
    { "PlayersPerTeam", "PlayersPerTeam", "Slider" },
    { "InfinitePlayersPerTeam", "InfinitePlayersPerTeam", "Toggle" },
    { "UnlimitedTime", "UnlimitedTime", "Toggle" },
    { "CanPlayAllMaps", "CanPlayAllMaps", "Toggle" },
    { "CanSelfQueue", "CanSelfQueue", "Toggle" }
}
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8._new()
    local v9 = v_u_5.new(script.Name)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11.CloseButton = v11.PageFrame:WaitForChild("Close")
    v11.List = v11.PageFrame:WaitForChild("List")
    v11.Container = v11.List:WaitForChild("Container")
    v11.Layout = v11.Container:WaitForChild("Layout")
    v11.HeaderFrame = v11.Container:WaitForChild("Header")
    v11.HeaderTitle = v11.HeaderFrame:WaitForChild("Title")
    v11._client_queue_pad = nil
    v11._setting_objects = {}
    v11._connections = {}
    v11:_Init()
    return v11
end
function v_u_8.SetQueuePad(p_u_12, p13)
    for _, v14 in pairs(p_u_12._connections) do
        v14:Disconnect()
    end
    p_u_12._connections = {}
    p_u_12._client_queue_pad = p13
    if p_u_12._client_queue_pad then
        p_u_12.HeaderTitle.Text = p13:Get("Model").Name
        for _, v15 in pairs(p_u_12._setting_objects) do
            v15.SettingObject.SettingsInfo = v15.RegenerateSettingsInfo()
        end
        local function v18()
            for _, v16 in pairs(p_u_12._setting_objects) do
                local v17 = p_u_12._client_queue_pad:Get(v16.DataName)
                if v17 == nil then
                    v17 = v16.SettingObject.SettingsInfo.DefaultValue
                end
                v16.SettingObject:SetValue(v17, true, true)
            end
        end
        local v19 = p_u_12._connections
        local v20 = p_u_12._client_queue_pad.Activity
        table.insert(v19, v20:Connect(v18))
        v18()
    end
end
function v_u_8.Close(p21, ...)
    p21:SetQueuePad(nil)
    v_u_5.Close(p21, ...)
end
function v_u_8._GetSettingsInfoValueParams(p22, p23)
    if p23 == "InfinitePlayersPerTeam" or (p23 == "UnlimitedTime" or (p23 == "CanPlayAllMaps" or p23 == "CanSelfQueue")) then
        return false, nil
    end
    if p23 == "PlayersPerTeam" then
        return 1, 1, p22._client_queue_pad and p22._client_queue_pad:GetMaxPlayersPerTeam() or 1, 1
    end
    if p23 == "QueueName" then
        local v24 = p22._client_queue_pad and p22._client_queue_pad:GetDuelLogics(v_u_2.LocalPlayer) or { "Classic" }
        return v24[1], v24
    end
    assert(false, p23)
end
function v_u_8._Setup(p_u_25)
    for _, v26 in pairs(v_u_7) do
        local v_u_27, v_u_28, v_u_29 = table.unpack(v26)
        local v30 = p_u_25.Container:WaitForChild(v_u_27)
        local v31 = v30:WaitForChild("Template")
        local v32 = v31:WaitForChild("Container")
        local v_u_33 = v32:WaitForChild("Title").Text
        local v_u_34 = v32:WaitForChild("Icon").Image
        local v_u_35 = v32:WaitForChild("Description").Text
        local function v36()
            return v_u_3.new("", "", v_u_33, v_u_34, v_u_35, v_u_29, p_u_25:_GetSettingsInfoValueParams(v_u_27))
        end
        local v_u_37 = require(v_u_6[v_u_29]).new(v_u_3.new("", "", v_u_33, v_u_34, v_u_35, v_u_29, p_u_25:_GetSettingsInfoValueParams(v_u_27)), v31)
        v_u_37.Replicate:Connect(function()
            if p_u_25._client_queue_pad then
                v_u_1.Remotes.PrivateServer.EditQueuePad:FireServer(p_u_25._client_queue_pad:Get("ObjectID"), v_u_28, v_u_37.Value)
            end
        end)
        v_u_37.SettingFrame.Parent = v30
        v31:Destroy()
        p_u_25._setting_objects[v_u_27] = {
            ["DataName"] = v_u_28,
            ["SettingObject"] = v_u_37,
            ["RegenerateSettingsInfo"] = v36
        }
    end
    p_u_25._setting_objects.InfinitePlayersPerTeam.SettingObject.Changed:Connect(function()
        p_u_25._setting_objects.PlayersPerTeam.SettingObject.SettingFrame.Parent.Visible = not p_u_25._setting_objects.InfinitePlayersPerTeam.SettingObject.Value
    end)
    p_u_25._setting_objects.PlayersPerTeam.SettingObject.SettingFrame.Parent.Visible = not p_u_25._setting_objects.InfinitePlayersPerTeam.SettingObject.Value
end
function v_u_8._Init(p_u_38)
    p_u_38.CloseButton.MouseButton1Click:Connect(function()
        p_u_38:CloseRequest()
    end)
    p_u_38.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_38.List.CanvasSize = UDim2.new(0, 0, 0, p_u_38.Layout.AbsoluteContentSize.Y)
        p_u_38.List.Active = p_u_38.Layout.AbsoluteContentSize.Y >= p_u_38.List.AbsoluteSize.Y
    end)
    p_u_38:_Setup()
    v_u_4:Add(p_u_38.CloseButton)
end
return v_u_8._new()