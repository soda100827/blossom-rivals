local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_5 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ContractMilestoneSlot")
local v_u_6 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ContractSlot")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(_, _)
    local v8 = v_u_7
    local v9 = setmetatable({}, v8)
    v9.Frame = v_u_6:Clone()
    v9._num_milestones = 0
    v9._progress = 0
    v9._scale = 1
    v9._milestones = {}
    v9._default_tostring_function = nil
    v9._requires_previous_milestone_completed = true
    v9:_Init()
    return v9
end
function v_u_7.SetImage(p10, p11, p12)
    p10.Frame.Container.Title.Left.Image = p11
    p10.Frame.Container.Title.Left.Size = p12 or p10.Frame.Container.Title.Left.Size
end
function v_u_7.SetTitle(p13, p14)
    p13.Frame.Container.Title.Text = p14
end
function v_u_7.SetDescription(p15, p16, p17)
    p15.Frame.Container.Description.Text = p16
    p15.Frame.Container.Description.Size = UDim2.new(0.9, 0, 0.025 * (p17 or 1), 0)
    p15:_Update()
end
function v_u_7.SetScale(p18, p19)
    p18._scale = p19
    p18:_Update()
end
function v_u_7.SetProgress(p20, p21)
    p20._progress = p21
    p20:_Update()
end
function v_u_7.SetRequiresPreviousMilestoneCompleted(p22, p23)
    p22._requires_previous_milestone_completed = p23
    p22:_Update()
end
function v_u_7.AddMilestone(p24, p25, p26, p27)
    p24._num_milestones = p24._num_milestones + 1
    local v28 = v_u_5:Clone()
    v28.LayoutOrder = p24._num_milestones
    v28.ZIndex = p24._num_milestones
    v28.Goal.Visible = v28.Contract.Visible
    v28.Parent = p24.Frame.Container.Milestones
    local v29 = p24._milestones
    local v30 = {
        v28,
        p25,
        p26,
        p27 or p24._default_tostring_function
    }
    table.insert(v29, v30)
    if p26 then
        v_u_4.new(p26).Frame.Parent = v28.Reward
    end
    p24:_Update()
end
function v_u_7.Destroy(p31)
    p31.Frame:Destroy()
end
function v_u_7._Update(p32)
    p32.Frame.Container.Milestones.Position = UDim2.new(0, 0, 0.1 + (p32.Frame.Container.Description.Text == "" and 0 or (0.01 + p32.Frame.Container.Description.Size.Y.Scale or 0)), 0)
    p32.Frame.Container.Size = UDim2.new(1, 0, 1 * p32._scale, 0)
    p32.Frame.Size = UDim2.new(1, 0, (p32.Frame.Container.Milestones.Position.Y.Scale + 0.075 * p32._num_milestones + 0.025) * p32._scale, 0)
    local v33 = true
    for _, v34 in pairs(p32._milestones) do
        local v35, v36, _, v37 = table.unpack(v34)
        local v38 = p32._requires_previous_milestone_completed
        if v38 then
            v38 = not v33
        end
        v33 = v36 <= p32._progress
        v35.Progress.Bar.Visible = not v38
        v35.Locked.Visible = v38
        v35.Completed.Visible = not v38 and v33
        local v39 = v35.Contract
        local v40 = not v38
        if v40 then
            v40 = not v33
        end
        v39.Visible = v40
        local v41 = v35.Progress.Bar
        local v42 = UDim2.new
        local v43 = p32._progress / v36
        v41.Size = v42(math.clamp(v43, 0, 1), 0, 1, 2)
        v35.Progress.Bar.BackgroundColor3 = v33 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(0, 190, 255)
        local v44 = v35.Goal
        local v45 = not v38
        if v45 then
            v45 = not v33
        end
        v44.Visible = v45
        v35.Goal.Text = v37(p32._progress) .. " / " .. v37(v36)
    end
end
function v_u_7._Setup(p46)
    function p46._default_tostring_function(...)
        return v_u_3:PrettyNumber(...)
    end
end
function v_u_7._Init(p47)
    p47:_Setup()
    p47:SetImage("")
    p47:SetTitle("")
    p47:SetDescription("")
    p47:SetScale(1)
    p47:SetProgress(0)
    p47:SetRequiresPreviousMilestoneCompleted(true)
end
return v_u_7