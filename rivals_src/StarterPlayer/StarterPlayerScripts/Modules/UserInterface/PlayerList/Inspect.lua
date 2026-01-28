local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("StarterGui")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v1.Modules.CONSTANTS)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_9 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_10 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController"))
local v_u_11 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController"))
local v_u_12 = require(v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_13 = require(v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_14 = require(v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_15 = require(v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_16 = UDim2.new(1.25, 0, 0.5, 0)
local v_u_17 = UDim2.new(0, 0, 0.5, 0)
local v_u_18 = v_u_5.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PlayerListInspectActionSlot")
local v_u_19 = {
    ["HoverRatio"] = 1,
    ["ReleaseRatio"] = 1
}
local v_u_20 = {
    {
        "Invite",
        "Party Invite",
        Color3.fromRGB(100, 255, 0),
        "rbxassetid://89570813431745",
        0.55
    },
    {
        "Friend",
        "Add Connection",
        Color3.fromRGB(100, 255, 0),
        "rbxassetid://95245645462537"
    },
    {
        "Challenge",
        "Challenge",
        Color3.fromRGB(255, 150, 0),
        "rbxassetid://18525954682"
    },
    {
        "Spectate",
        "Spectate",
        Color3.fromRGB(255, 150, 0),
        "rbxassetid://17332217644"
    },
    {
        "ViewProfile",
        "View Profile",
        Color3.fromRGB(0, 150, 255),
        "rbxassetid://113844621753627",
        0.65
    },
    {
        "ViewAvatar",
        "View Avatar",
        Color3.fromRGB(0, 150, 255),
        "rbxassetid://113844621753627",
        0.65
    },
    {
        "Unfriend",
        "Remove Connection",
        Color3.fromRGB(255, 50, 50),
        "rbxassetid://99528569460280"
    },
    {
        "Block",
        "Block",
        Color3.fromRGB(255, 50, 50),
        "rbxassetid://71490041005019"
    },
    {
        "Unblock",
        "Unblock",
        Color3.fromRGB(255, 50, 50),
        "rbxassetid://71490041005019"
    },
    {
        "Gift",
        "Send Gift",
        Color3.fromRGB(255, 149, 253),
        "rbxassetid://127400882945494",
        0.65
    }
}
local v_u_21 = {}
v_u_21.__index = v_u_21
function v_u_21.new(p22)
    local v23 = v_u_21
    local v24 = setmetatable({}, v23)
    v24.PlayerList = p22
    v24.Frame = v24.PlayerList.Container:WaitForChild("Inspect")
    v24.Container = v24.Frame:WaitForChild("Container")
    v24.Layout = v24.Container:WaitForChild("Layout")
    v24.PlayerFrame = v24.Container:WaitForChild("Player")
    v24.PlayerHeadshot = v24.PlayerFrame:WaitForChild("Headshot")
    v24.PlayerUsername = v24.PlayerFrame:WaitForChild("Username")
    v24.PlayerDisplayName = v24.PlayerFrame:WaitForChild("DisplayName")
    v24._selected_player_list_slot = false
    v24._action_slots = {}
    v24:_Init()
    return v24
end
function v_u_21.SelectPlayer(p25, p26)
    if p26 == p25._selected_player_list_slot then
        return
    elseif p26 and not p25.PlayerList.IsOpen then
        return
    else
        p25._selected_player_list_slot = p26
        for _, v27 in pairs(p25.PlayerList.Elements.PlayerListSlots) do
            v27:SetHighlighted(p25._selected_player_list_slot == v27)
        end
        local v28
        if p25._selected_player_list_slot then
            v28 = UDim2.new(0, -4, 0, p25._selected_player_list_slot.Frame.AbsolutePosition.Y - p25.PlayerList.Container.AbsolutePosition.Y)
        else
            v28 = p25.Frame.Position
        end
        local v29
        if p25._selected_player_list_slot then
            v29 = v_u_17
        else
            v29 = v_u_16
        end
        p25.Frame.Position = v28
        local v30 = p25.Container
        local v31
        if p25._selected_player_list_slot then
            v31 = v_u_16
        else
            v31 = p25.Container.Position
        end
        v30.Position = v31
        if p25.Container:IsDescendantOf(v_u_5.LocalPlayer.PlayerGui) then
            p25.Container:TweenPosition(v29, "Out", "Quint", 0.25, true)
        else
            p25.Container.Position = v29
        end
        if p25._selected_player_list_slot then
            local v32 = p25._selected_player_list_slot.ClientFighter.Player
            local v33 = p25._selected_player_list_slot.ClientFighter.IsLocalPlayer
            local v34 = p25._selected_player_list_slot:IsBlocked()
            local v35 = not v34
            if v35 then
                v35 = p25._selected_player_list_slot:IsFriend()
            end
            local v36 = p25._action_slots.Invite
            local v37 = not v34
            if v37 then
                v37 = v_u_8:CanInvitePlayerToParty(v32)
            end
            v36.Visible = v37
            local v38 = p25._action_slots.Friend
            local v39 = not (v34 or v35)
            if v39 then
                local v40 = not v33
                v39 = v40 and true or v40
            end
            v38.Visible = v39
            local v41 = p25._action_slots.Challenge
            local v42 = not v34
            if v42 then
                v42 = v_u_10:CanChallenge(v32)
            end
            v41.Visible = v42
            local v43 = p25._action_slots.Spectate
            local v44 = not v34
            if v44 then
                v44 = v_u_11:GetDuel(v32) ~= nil
            end
            v43.Visible = v44
            p25._action_slots.ViewProfile.Visible = not v34
            p25._action_slots.ViewAvatar.Visible = not v34
            local v45 = p25._action_slots.Unfriend
            local v46 = not v34
            if v46 then
                if v35 then
                    local v47 = not v33
                    v46 = v47 and true or v47
                else
                    v46 = v35
                end
            end
            v45.Visible = v46
            local v48 = p25._action_slots.Block
            local v49 = not v34
            if v49 then
                v49 = not v33
            end
            v48.Visible = v49
            local v50 = p25._action_slots.Unblock
            local v51
            if v34 then
                v51 = not v33
            else
                v51 = v34
            end
            v50.Visible = v51
            local v52 = p25._action_slots.Gift
            local v53 = not v34
            if v53 then
                if v35 then
                    v35 = not v33
                end
            else
                v35 = v53
            end
            v52.Visible = v35
            p25.PlayerHeadshot.Image = string.format(v_u_6.HEADSHOT_IMAGE, v32.UserId)
            p25.PlayerDisplayName.Text = v_u_7:GetName(p25._selected_player_list_slot.ClientFighter.Player, v32.DisplayName, true)
            p25.PlayerUsername.Text = "@" .. v32.Name
            v_u_13:ClearStatusElements(p25.PlayerDisplayName)
            v_u_13:ApplyItemStatusToText(p25.PlayerDisplayName, v32:GetAttribute("PlayerStatus"))
            p25:_UpdateCooldowns()
        end
    end
end
function v_u_21.OnOpened(p_u_54)
    p_u_54.PlayerList:AddOpenedConnection(v_u_10.ChallengeRequestCooldownChanged:Connect(function()
        p_u_54:_UpdateCooldowns()
    end))
    p_u_54.PlayerList:AddOpenedConnection(v_u_8.InviteRequestCooldownChanged:Connect(function()
        p_u_54:_UpdateCooldowns()
    end))
    p_u_54.PlayerList:AddOpenedConnection(v_u_2.InputBegan:Connect(function(p55)
        if v_u_15:IsMouseWithinBounds(p_u_54.Container.AbsolutePosition, p_u_54.Layout.AbsoluteContentSize) then
            return
        elseif not v_u_15:IsMouseWithinBounds(p_u_54.PlayerList.Elements.Frame.AbsolutePosition, p_u_54.PlayerList.Elements.Frame.AbsoluteSize) then
            if p55.UserInputType == Enum.UserInputType.MouseButton1 or p55.UserInputType == Enum.UserInputType.Touch then
                p_u_54:SelectPlayer(nil)
            end
        end
    end))
    p_u_54:_UpdateCooldowns()
end
function v_u_21._UpdateCooldowns(p56)
    local v57 = p56._selected_player_list_slot
    if v57 then
        v57 = p56._selected_player_list_slot.ClientFighter.Player
    end
    local v58 = p56._action_slots.Challenge.Button.Cooldown
    local v59
    if v57 then
        v59 = v_u_10:IsChallengeRequestOnCooldown(v57)
    else
        v59 = v57
    end
    v58.Visible = v59
    p56._action_slots.Challenge.Button.Icon.Visible = not p56._action_slots.Challenge.Button.Cooldown.Visible
    local v60 = p56._action_slots.Invite.Button.Cooldown
    if v57 then
        v57 = v_u_8:IsInviteRequestOnCooldown(v57)
    end
    v60.Visible = v57
    p56._action_slots.Invite.Button.Icon.Visible = not p56._action_slots.Invite.Button.Cooldown.Visible
end
function v_u_21._SlotAdded(p_u_61, p_u_62)
    p_u_62.Clicked:Connect(function()
        local v63 = p_u_61
        local v64
        if p_u_61._selected_player_list_slot == p_u_62 then
            v64 = nil
        else
            v64 = p_u_62
        end
        v63:SelectPlayer(v64)
    end)
    p_u_62:SetHighlighted(p_u_61._selected_player_list_slot == p_u_62)
end
function v_u_21._Setup(p_u_65)
    for _, v66 in pairs(v_u_20) do
        local v67, v68, v_u_69, v70, v71 = table.unpack(v66)
        local v_u_72 = v_u_18:Clone()
        v_u_72.Button.Background.ImageColor3 = v_u_69
        v_u_72.Button.Icon.Image = v70
        v_u_72.Button.Icon.Size = UDim2.new(0.2, 0, v71 or 0.75, 0)
        v_u_72.Button.Title.Text = v68
        v_u_72.Parent = p_u_65.Container
        p_u_65._action_slots[v67] = v_u_72
        v_u_14:Add(v_u_72.Button, nil, v_u_19)
        v_u_72.Button.MouseLeave:Connect(function()
            v_u_72.Button.Background.ImageColor3 = v_u_69
            v_u_72.Button.Background.ImageTransparency = 0.5
            v_u_72.Button.Background.UIGradient.Enabled = true
            v_u_72.Button.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            v_u_72.Button.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        v_u_72.Button.MouseEnter:Connect(function()
            v_u_72.Button.Background.ImageColor3 = Color3.fromRGB(255, 255, 255)
            v_u_72.Button.Background.ImageTransparency = 0
            v_u_72.Button.Background.UIGradient.Enabled = false
            v_u_72.Button.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
            v_u_72.Button.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
        end)
    end
    p_u_65._action_slots.Invite.Button.MouseButton1Click:Connect(function()
        v_u_8:SendPartyInvite(p_u_65._selected_player_list_slot.ClientFighter.Player)
    end)
    p_u_65._action_slots.Friend.Button.MouseButton1Click:Connect(function()
        v_u_4:SetCore("PromptSendFriendRequest", p_u_65._selected_player_list_slot.ClientFighter.Player)
    end)
    p_u_65._action_slots.Challenge.Button.MouseButton1Click:Connect(function()
        v_u_10:SendChallengeRequest(p_u_65._selected_player_list_slot.ClientFighter.Player)
    end)
    p_u_65._action_slots.Spectate.Button.MouseButton1Click:Connect(function()
        p_u_65._action_slots.Spectate.Visible = false
        local v73 = v_u_11:GetDuel(p_u_65._selected_player_list_slot.ClientFighter.Player)
        if v73 then
            v_u_9:SpectateDuelRequest(v73)
        end
    end)
    p_u_65._action_slots.ViewProfile.Button.MouseButton1Click:Connect(function()
        local v74 = p_u_65._selected_player_list_slot.ClientFighter.Player
        v_u_12.PageSystem:OpenPage("ViewProfile")
        v_u_12.PageSystem:WaitForPage("ViewProfile"):Fetch(v74)
    end)
    p_u_65._action_slots.ViewAvatar.Button.MouseButton1Click:Connect(function()
        v_u_3:InspectPlayerFromUserId(p_u_65._selected_player_list_slot.ClientFighter.Player.UserId)
    end)
    p_u_65._action_slots.Unfriend.Button.MouseButton1Click:Connect(function()
        v_u_4:SetCore("PromptUnfriend", p_u_65._selected_player_list_slot.ClientFighter.Player)
    end)
    p_u_65._action_slots.Block.Button.MouseButton1Click:Connect(function()
        v_u_4:SetCore("PromptBlockPlayer", p_u_65._selected_player_list_slot.ClientFighter.Player)
    end)
    p_u_65._action_slots.Unblock.Button.MouseButton1Click:Connect(function()
        v_u_4:SetCore("PromptUnblockPlayer", p_u_65._selected_player_list_slot.ClientFighter.Player)
    end)
    p_u_65._action_slots.Gift.Button.MouseButton1Click:Connect(function()
        local v75 = p_u_65._selected_player_list_slot.ClientFighter.Player
        v_u_12.PageSystem:OpenPage("Gifting")
        v_u_12.PageSystem:WaitForPage("Gifting"):SelectPlayer(v75)
        v_u_12.PageSystem:WaitForPage("Gifting"):DontRedirect()
    end)
end
function v_u_21._Init(p_u_76)
    p_u_76.PlayerList.OpenedChanged:Connect(function()
        if not p_u_76.PlayerList.IsOpen then
            p_u_76:SelectPlayer(nil)
        end
    end)
    p_u_76.PlayerList.Elements.PlayerListSlotRemoved:Connect(function(p77)
        if p77 == p_u_76._selected_player_list_slot then
            p_u_76:SelectPlayer(nil)
        end
    end)
    p_u_76.PlayerList.Elements.PlayerListSlotAdded:Connect(function(p78)
        p_u_76:_SlotAdded(p78)
    end)
    for _, v79 in pairs(p_u_76.PlayerList.Elements.PlayerListSlots) do
        task.defer(p_u_76._SlotAdded, p_u_76, v79)
    end
    p_u_76:_Setup()
    p_u_76:SelectPlayer(nil)
end
return v_u_21