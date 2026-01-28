local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController"))
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Lobby"):WaitForChild("Matchmaking"))
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_8 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PartyMemberSlot")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11)
    local v12 = v_u_9
    local v13 = setmetatable({}, v12)
    v13.Frame = p10
    v13._connections = {}
    v13._slots = {}
    v13._inverted_order = p11
    v13:_Init()
    return v13
end
function v_u_9.Destroy(p14)
    for _, v15 in pairs(p14._connections) do
        v15:Disconnect()
    end
    p14:_Clear()
end
function v_u_9._Clear(p16)
    for _, v17 in pairs(p16._slots) do
        v17:Destroy()
    end
    p16._slots = {}
end
function v_u_9._Generate(p_u_18)
    p_u_18:_Clear()
    local v19 = v_u_4.CurrentParty or { v_u_2.LocalPlayer }
    local function v27(p20, p21)
        local v22 = v_u_8:Clone()
        v22.Button.Icon.Image = not p21 and "" or string.format(v_u_3.HEADSHOT_IMAGE, p21.UserId)
        local v23 = v22.Button.Leader
        local v24 = v_u_4.CurrentParty
        if v24 then
            v24 = p20 == 1
        end
        v23.Visible = v24
        v22.Button.Invite.Visible = not p21
        v22.Button.Inputs.Visible = not p21
        v22.Button.Inputs.Gamepad.Keybind.Position = p_u_18._inverted_order and UDim2.new(0.5, 0, -0.25, 0) or UDim2.new(1.25, 0, 0.5, 0)
        v22.Size = p20 == 1 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.75, 0, 0.75, 0)
        v22.LayoutOrder = p20 * (p_u_18._inverted_order and -1 or 1)
        v22.Button.MouseButton1Click:Connect(function()
            if not v_u_5:IsVisible() then
                local v25 = v_u_6.PageSystem.CurrentPage
                if v25 then
                    v25 = v_u_6.PageSystem.CurrentPage.Name
                end
                v_u_6.PageSystem:OpenPage("Party", true)
                v_u_6.PageSystem:WaitForPage("Party"):RedirectTo(v25)
            end
        end)
        v22.Parent = p_u_18.Frame
        local v26 = p_u_18._slots
        table.insert(v26, v22)
        v_u_7:Add(v22.Button)
    end
    for v28, v29 in pairs(v19) do
        v27(v28, v29)
    end
    if #v19 < v_u_3.MAX_PARTY_SIZE and v_u_4:IsPartyLeader() then
        v27(#v19 + 1, nil)
    end
end
function v_u_9._Init(p_u_30)
    local v31 = p_u_30._connections
    local v32 = v_u_4.PartyChanged
    table.insert(v31, v32:Connect(function()
        p_u_30:_Generate()
    end))
    p_u_30:_Generate()
end
return v_u_9