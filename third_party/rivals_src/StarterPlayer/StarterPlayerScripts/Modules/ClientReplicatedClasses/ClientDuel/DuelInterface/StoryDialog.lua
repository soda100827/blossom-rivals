local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.DuelLibrary)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5.new(p6)
    local v7 = v_u_5
    local v8 = setmetatable({}, v7)
    v8.DuelInterface = p6
    v8.Frame = v8.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("StoryDialog")
    v8.Container = v8.Frame:WaitForChild("Container")
    v8.RightSpeakerFrame = v8.Container:WaitForChild("RightSpeaker")
    v8.RightSpeakerImage = v8.RightSpeakerFrame:WaitForChild("Player"):WaitForChild("Headshot")
    v8.LeftSpeakerFrame = v8.Container:WaitForChild("LeftSpeaker")
    v8.LeftSpeakerImage = v8.LeftSpeakerFrame:WaitForChild("Player"):WaitForChild("Headshot")
    v8.Message = v8.Container:WaitForChild("Message")
    v8._destroyed = false
    v8._is_playing_story = false
    v8._dont_play_more_stories = false
    v8._random = Random.new(v8.DuelInterface.ClientDuel:Get("DuelSeed"))
    v8:_Init()
    return v8
end
function v_u_5.CreateSound(p9, ...)
    local v10 = p9.Frame.Visible and p9.Container.Visible
    if v10 then
        v10 = p9.DuelInterface:CreateSound(...)
    end
    return v10
end
function v_u_5.Update(p11)
    local v12 = p11.Frame
    local v13 = not (p11.DuelInterface.Scoreboard:IsOpen() or p11.DuelInterface:IsPageOpen())
    if v13 then
        v13 = not p11.DuelInterface.RoundResult.Frame.Visible
    end
    v12.Visible = v13
    if p11.DuelInterface.ClientDuel:Get("Status") == "RoundStarted" then
        task.spawn(p11._AttemptToPlayStory, p11)
    end
end
function v_u_5.Destroy(p14)
    p14._destroyed = true
end
function v_u_5._GetRandomSpeaker(p15, ...)
    local v16 = { ... }
    local v17 = {}
    for _, v18 in pairs(p15.DuelInterface.ClientDuel.Duelers) do
        if v18.Player and not table.find(v16, v18.Player) then
            local v19 = v18.Player
            table.insert(v17, v19)
        end
    end
    table.sort(v17, function(p20, p21)
        return p20.UserId < p21.UserId
    end)
    if #v17 == 0 then
        return nil
    else
        return v17[p15._random:NextInteger(1, #v17)]
    end
end
function v_u_5._PlayDialog(p22, p23, p24)
    p22._is_playing_story = true
    p22.Container.Visible = true
    p22.Container.Size = UDim2.new(1, 0, 1, 0)
    p22:CreateSound("rbxassetid://105553937408843", 1, 1, script, true, 10)
    for v25, v26 in pairs(p24) do
        if p22._destroyed then
            return
        end
        task.delay(v25 == 1 and 0.5 or 0, p22.CreateSound, p22, "rbxassetid://124144337176625", 1, 0.9 + 0.2 * math.random(), script, true, 10)
        if p22.Container:IsDescendantOf(v_u_2.LocalPlayer.PlayerGui) then
            p22.Container.Size = UDim2.new(1.1, 0, 1.1, 0)
            p22.Container:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quint", 0.25, true)
        end
        p22.Message.Text = v26.Message
        p22.RightSpeakerFrame.Visible = table.find(p23, v26.Speaker) == 1
        p22.RightSpeakerImage.Image = string.format(v_u_3.HEADSHOT_IMAGE, v26.Speaker.UserId)
        p22.LeftSpeakerImage.Image = p22.RightSpeakerImage.Image
        p22.LeftSpeakerFrame.Visible = not p22.RightSpeakerFrame.Visible
        wait(v26.WaitBeforeMovingOn)
    end
    if p22.Container:IsDescendantOf(v_u_2.LocalPlayer.PlayerGui) then
        p22:CreateSound("rbxassetid://105553937408843", 1, 0.75, script, true, 10)
        p22.Container:TweenSize(UDim2.new(0.25, 0, 0.25, 0), "In", "Quint", 0.25, true)
        wait(0.25)
    end
    p22._is_playing_story = false
    p22.Container.Visible = false
end
function v_u_5._ZombieTower(p27)
    local v28 = p27:_GetRandomSpeaker()
    local v29 = p27:_GetRandomSpeaker(v28)
    if v28 and v29 then
        p27:_PlayDialog({ v28, v29 }, {
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "This must be the tower our intel had us locate."
            },
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "Let\'s find our way to the top and radio for rescue."
            },
            {
                ["Speaker"] = v29,
                ["WaitBeforeMovingOn"] = 4,
                ["Message"] = "Easier said than done!"
            },
            {
                ["Speaker"] = v29,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "Do you see how tall it is? I can\'t even see the top!"
            },
            {
                ["Speaker"] = v29,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "We\'re so dead. I really thought we had a chance."
            },
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 4,
                ["Message"] = "We do have a chance.\n"
            },
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 4,
                ["Message"] = "Just stay focused. We\'ve come too far to give up."
            },
            {
                ["Speaker"] = v29,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "We\'re looking for a.. what? A radio? Then what?"
            },
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "..then we hope for the best. Let\'s go!"
            }
        })
        return
    elseif v28 then
        p27:_PlayDialog({ v28 }, {
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "This is it. This is the tower they told me to find."
            },
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "I\'m the only one left. I can\'t give up now."
            },
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "All I need to do now is reach the top and.. radio for help."
            },
            {
                ["Speaker"] = v28,
                ["WaitBeforeMovingOn"] = 6,
                ["Message"] = "No problem at all. No big deal.. I got this.."
            }
        })
    end
end
function v_u_5._AttemptToPlayStory(p30)
    if not (p30._is_playing_story or p30._dont_play_more_stories) then
        local v31 = p30.DuelInterface.ClientDuel:Get("PlaySourceName")
        if v31 then
            v31 = v_u_4.PlaySources[v31].DuelLogic
        end
        if v31 == "Zombie Tower" then
            p30._dont_play_more_stories = true
            p30:_ZombieTower()
        end
    end
end
function v_u_5._Init(p_u_32)
    p_u_32.DuelInterface.RoundResult.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        p_u_32:Update()
    end)
    p_u_32.DuelInterface.Scoreboard.VisibilityChanged:Connect(function()
        p_u_32:Update()
    end)
end
return v_u_5