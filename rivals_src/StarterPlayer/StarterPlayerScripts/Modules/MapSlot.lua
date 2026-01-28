local v1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.ServerOsTime)
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.VoteBanFrame)
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_9 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("VoterSlot")
local v_u_10 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MapSlot")
local v_u_11 = {
    ["ReleaseRatio"] = 1.025,
    ["HoverRatio"] = 1.025
}
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(p13, p14)
    local v15 = v_u_12
    local v16 = setmetatable({}, v15)
    v16.CreateSound = v_u_6.new()
    v16.Name = p13
    v16.Frame = v_u_10:Clone()
    v16.VoteBanFrame = v_u_7.new(v16.Frame.Button)
    v16._ignore_button_effect = p14
    v16._voter_slots = {}
    v16._is_banned = false
    v16:_Init()
    return v16
end
function v_u_12.SetParent(p17, p18)
    p17.Frame.Parent = p18
end
function v_u_12.UpdateVotes(p19, p20, p21, p22, p23, p24, p25)
    for _, v26 in pairs(p19._voter_slots) do
        v26:Destroy()
    end
    p19._voter_slots = {}
    for _, v27 in pairs(p22 or {}) do
        local v28 = v_u_9:Clone()
        v28.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, v27)
        v28.Background.ImageColor3 = v_u_5:GetTeamColor(p23[tostring(v27)])
        v28.Parent = p19.Frame.Button.Votes
        local v29 = p19._voter_slots
        table.insert(v29, v28)
    end
    p19.Frame.Button.Votes.Visible = p20 ~= nil
    local v30 = p19.Frame.Button.Title
    local v31 = p19.Name
    local v32
    if p25 == "Chance" and (p20 and p20 > 0) then
        local v33 = p20 / p21 * 100
        v32 = " [" .. math.floor(v33) .. "%]"
    else
        v32 = ""
    end
    v30.Text = v31 .. v32
    p19.Frame.Button.Title.TextColor3 = p24 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    p19.Frame.Button.Background.ImageColor3 = p24 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    p19.Frame.Button.Votes.Chance.Visible = false
end
function v_u_12.Destroy(p34)
    p34.CreateSound:Destroy()
    p34.VoteBanFrame:Destroy()
    p34.Frame:Destroy()
end
function v_u_12._Setup(p35)
    local v36 = p35.Name == "Random"
    local v37 = v_u_5.Maps[p35.Name]
    local v38 = v36 and "" or v37.Image
    local v39 = v_u_5.MapDifficulties[v36 and "None" or v37.Difficulty]
    local v40
    if v36 then
        v40 = false
    else
        v40 = v_u_4:Get() < v37.ReleaseTime + v_u_5.NEW_MAP_RELEASE_DURATION
    end
    p35.Frame.Button.Picture.Image = v38
    p35.Frame.Button.Random.Visible = v36
    p35.Frame.Button.Background.Texture.ImageColor3 = v39.Color
    p35.Frame.Button.Difficulty.BackgroundColor3 = v39.Color
    p35.Frame.Button.Difficulty.UIStroke.Color = v39.Color
    p35.Frame.Button.DifficultyVignette.ImageColor3 = v39.Color
    p35.Frame.Button.DifficultyVignette.ImageTransparency = v39.Value >= v_u_5.MapDifficulties.Hard.Value and 0 or 0.5
    p35.Frame.Button.NewRelease.Visible = v40
    if not p35._ignore_button_effect then
        v_u_8:Add(p35.Frame.Button, nil, v_u_11)
    end
end
function v_u_12._Init(p_u_41)
    p_u_41.VoteBanFrame.CreateSound:Connect(function(...)
        p_u_41.CreateSound:Fire(...)
    end)
    p_u_41:_Setup()
    p_u_41:UpdateVotes()
end
return v_u_12