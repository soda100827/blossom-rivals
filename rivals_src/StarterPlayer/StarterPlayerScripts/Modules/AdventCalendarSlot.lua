local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.AdventCalendarLibrary)
local v_u_4 = require(v1.Modules.TaskLibrary)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.TimerController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("AdventCalendarSlot")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.Container = p10
    v12.Frame = v_u_8:Clone()
    v12.TitleText = v12.Frame:WaitForChild("Title")
    v12.Icon = v12.TitleText:WaitForChild("ImageLabel")
    v12.TimerText = v12.Frame:WaitForChild("Timer")
    v12.RewardsFrame = v12.Frame:WaitForChild("Rewards")
    v12._connections = {}
    v12._reward_slots = {}
    v12:_Init()
    return v12
end
function v_u_9.SetEnabled(p_u_13, p14)
    for _, v15 in pairs(p_u_13._connections) do
        v15:Disconnect()
    end
    p_u_13._connections = {}
    if p14 then
        local v16 = p_u_13._connections
        local v17 = v_u_5:GetDataChangedSignal("Tasks")
        table.insert(v16, v17:Connect(function()
            p_u_13:_Update()
        end))
        local v18 = p_u_13._connections
        local v19 = v_u_5:GetDataChangedSignal("BonusTasks")
        table.insert(v18, v19:Connect(function()
            p_u_13:_Update()
        end))
        local v20 = p_u_13._connections
        local v21 = v_u_5:GetDataChangedSignal("StatisticDuelsPlayed")
        table.insert(v20, v21:Connect(function()
            p_u_13:_Update()
        end))
        local v22 = p_u_13._connections
        local v23 = v_u_5:GetDataChangedSignal("SpecialChallenges")
        table.insert(v22, v23:Connect(function()
            p_u_13:_Update()
        end))
        local v24 = p_u_13._connections
        local v25 = v_u_5:GetDataChangedSignal("BeginnerTasksCompleted")
        table.insert(v24, v25:Connect(function()
            p_u_13:_Update()
        end))
        local v26 = p_u_13._connections
        local v27 = v_u_6.TimerUpdated
        table.insert(v26, v27:Connect(function()
            p_u_13:_Update()
        end))
        p_u_13:_Update()
    end
end
function v_u_9._Update(p_u_28)
    for _, v29 in pairs(p_u_28._reward_slots) do
        v29:Destroy()
    end
    p_u_28._reward_slots = {}
    local v30 = v_u_3:GetReward()
    local v31 = v_u_5:Get("BeginnerTasksCompleted") >= v_u_4.NUM_BEGINNER_TASKS
    local v32 = p_u_28.Container
    if v31 then
        v31 = v30 ~= nil
    end
    v32.Visible = v31
    if p_u_28.Container.Visible then
        local v33 = v_u_3:GetReward(1)
        local v34 = v_u_5:Get("AdventCalendarLastDayClaimed") >= v30.Day
        p_u_28.TitleText.Text = "Advent Calendar - Day " .. v30.Day
        p_u_28.Icon.Image = v34 and "rbxassetid://17588806026" or "rbxassetid://71486631710031"
        p_u_28.Icon.ImageColor3 = v34 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
        p_u_28.TimerText.Text = v34 and (v33 and "" or "Advent Calendar completed!") or "Complete your Daily Tasks to claim!"
        v_u_6:OnStep("TaskPageAdventCalendar", "AdventCalendar", v34 and (v30 and v33) and function(_, p35)
            p_u_28.TimerText.Text = "next reward in " .. p35
        end or nil)
        for _, v36 in pairs(v30.Rewards) do
            local v37 = v_u_7.new(v36)
            v37:SetParent(p_u_28.RewardsFrame)
            local v38 = p_u_28._reward_slots
            table.insert(v38, v37)
        end
    end
end
function v_u_9._Setup(p39)
    p39.Frame.Parent = p39.Container
end
function v_u_9._Init(p40)
    p40:_Setup()
end
return v_u_9