local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GroupService")
local v3 = game:GetService("Players")
local v_u_4 = require(v_u_1.Modules.CONSTANTS)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseContractSlot"))
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_10 = setmetatable({}, v_u_9)
v_u_10.__index = v_u_10
function v_u_10._new()
    local v11 = v_u_9.new(script.Name)
    local v12 = v_u_10
    local v13 = setmetatable(v11, v12)
    v13.CloseButton = v13.PageFrame:WaitForChild("Close")
    v13.PromptsFrame = v13.PageFrame:WaitForChild("Prompts")
    v13.Container = v13.PageFrame:WaitForChild("Container")
    v13.VerifyButton = v13.Container:WaitForChild("Verify")
    v13.VerifyButtonReadyFrame = v13.VerifyButton:WaitForChild("Ready")
    v13.VerifyButtonCountdownFrame = v13.VerifyButton:WaitForChild("Countdown")
    v13.VerifyButtonCountdownText = v13.VerifyButtonCountdownFrame:WaitForChild("Title")
    v13.PromptSystem = v_u_7.new(v13.PromptsFrame)
    v13._verify_countdown_hash = 0
    v13._contract_slot = v_u_6.new()
    v13:_Init()
    return v13
end
function v_u_10._UpdateClaimed(p14)
    local v15 = v_u_5:Get("ClaimedGroupReward")
    p14.VerifyButton.Visible = not v15
    p14._contract_slot:SetProgress(v15 and 2 or 0)
end
function v_u_10._Countdown(p_u_16)
    p_u_16._verify_countdown_hash = p_u_16._verify_countdown_hash + 1
    local v_u_17 = p_u_16._verify_countdown_hash
    p_u_16.VerifyButtonCountdownFrame.Visible = true
    p_u_16.VerifyButtonReadyFrame.Visible = false
    task.spawn(function()
        for v18 = 15, 1, -1 do
            p_u_16.VerifyButtonCountdownText.Text = v18
            wait(1)
            if v_u_17 ~= p_u_16._verify_countdown_hash then
                return
            end
        end
        p_u_16.VerifyButtonCountdownFrame.Visible = false
        p_u_16.VerifyButtonReadyFrame.Visible = true
    end)
end
function v_u_10._Setup(p19)
    p19._contract_slot:SetTitle("Free Rewards")
    p19._contract_slot:SetImage("rbxassetid://84811629597038", UDim2.new(1.25, 0, 1, 0))
    p19._contract_slot:SetScale(1.25)
    p19._contract_slot:SetRequiresPreviousMilestoneCompleted(false)
    p19._contract_slot:SetDescription("Like the game (RIVALS) \240\159\145\141 and join the group (Nosniy Games) \240\159\146\156 to claim!")
    p19._contract_slot:AddMilestone(2, {
        ["Name"] = "RIVALS",
        ["Weapon"] = "IsUniversal"
    })
    p19._contract_slot:AddMilestone(2, {
        ["Name"] = "Nosniy Games",
        ["Weapon"] = "IsUniversal"
    })
    p19._contract_slot:AddMilestone(2, {
        ["Name"] = "Key",
        ["Quantity"] = 3
    })
    p19._contract_slot.Frame.Parent = p19.Container
end
function v_u_10._Init(p_u_20)
    p_u_20.CloseButton.MouseButton1Click:Connect(function()
        p_u_20:CloseRequest()
    end)
    p_u_20.VerifyButton.MouseButton1Click:Connect(function()
        if p_u_20.VerifyButtonReadyFrame.Visible then
            p_u_20:_Countdown()
            local v21, v22 = pcall(v_u_2.PromptJoinAsync, v_u_2, v_u_4.GROUP_ID)
            if not v21 then
                warn("Failed to prompt group join, error:", v22)
            end
            if v_u_1.Remotes.Data.ClaimGroupReward:InvokeServer() then
                v_u_1.Remotes.Data.ClaimLikeReward:FireServer()
            else
                p_u_20.PromptSystem:Open("ErrorMessage", "Woops!", "Failed to verify, make sure to like the game AND join the group!")
            end
        else
            return
        end
    end)
    v_u_5:GetDataChangedSignal("ClaimedGroupReward"):Connect(function()
        p_u_20:_UpdateClaimed()
    end)
    p_u_20:_Setup()
    p_u_20:_UpdateClaimed()
    v_u_8:Add(p_u_20.CloseButton)
    v_u_8:Add(p_u_20.VerifyButton)
end
return v_u_10._new()