local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.ConceptsLibrary)
local v_u_5 = require(v1.Modules.CosmeticLibrary)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_9 = setmetatable({}, v_u_8)
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11)
    local v12 = v_u_8.new(script.Name)
    local v13 = v_u_9
    local v14 = setmetatable(v12, v13)
    v14.CloseButton = v14.PromptFrame:WaitForChild("Close")
    v14.Headshot = v14.PromptFrame:WaitForChild("Headshot")
    v14.Title = v14.PromptFrame:WaitForChild("Title")
    v14.Points = v14.PromptFrame:WaitForChild("Points")
    v14.List = v14.PromptFrame:WaitForChild("List")
    v14.Container = v14.List:WaitForChild("Container")
    v14.Layout = v14.Container:WaitForChild("Layout")
    v14._user_id = p10
    v14._username = p11
    local v15 = v_u_4.Conceptors
    local v16 = v14._user_id
    v14._conceptor_info = v15[tostring(v16)]
    v14._reward_slots = {}
    v14:_Init()
    return v14
end
function v_u_9.Destroy(p17)
    for _, v18 in pairs(p17._reward_slots) do
        v18:Destroy()
    end
    v_u_8.Destroy(p17)
end
function v_u_9._Update(p19)
    p19.List.CanvasSize = UDim2.new(0, 0, 0, p19.Layout.AbsoluteContentSize.Y)
    p19.List.ClipsDescendants = p19.List.AbsoluteCanvasSize.Y > p19.List.AbsoluteWindowSize.Y
end
function v_u_9._Setup(p20)
    p20.Title.Text = p20._username
    p20.Points.Text = string.format("%.1f", v_u_4:GetConceptScore(p20._user_id)) .. " points"
    p20.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, p20._user_id)
    for _, v21 in pairs(p20._conceptor_info.CosmeticConcepts) do
        local v22 = v_u_5.Cosmetics[v21]
        local v23 = v_u_7.new({
            ["Name"] = v21,
            ["Weapon"] = v22.ItemName
        })
        v23:SetParent(p20.Container)
        local v24 = p20._reward_slots
        table.insert(v24, v23)
    end
end
function v_u_9._Init(p_u_25)
    p_u_25.CloseButton.MouseButton1Click:Connect(function()
        p_u_25:CloseRequest()
    end)
    p_u_25.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_25:_Update()
    end)
    p_u_25.List:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
        p_u_25:_Update()
    end)
    p_u_25.List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
        p_u_25:_Update()
    end)
    p_u_25:_Setup()
    p_u_25:_Update()
    v_u_6:Add(p_u_25.CloseButton)
end
return v_u_9