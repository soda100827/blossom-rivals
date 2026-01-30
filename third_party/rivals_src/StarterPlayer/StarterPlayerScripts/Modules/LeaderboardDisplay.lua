local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.LeaderboardLibrary)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.ComplianceController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.RankIcon)
local v_u_9 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LeaderboardPlayerSlot")
local v_u_10 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LeaderboardButton")
local v_u_11 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LeaderboardGui")
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12.new(p13)
    local v14 = v_u_12
    local v15 = setmetatable({}, v14)
    v15.Part = p13
    v15.SurfaceGui = v_u_11:Clone()
    v15._display_id = v15.Part:GetAttribute("DisplayID")
    v15._whitelist = nil
    v15._leaderboards_serial = {}
    v15._leaderboard_name = nil
    v15._player_slots = {}
    v15._generate_hash = 0
    v15._leaderboard_buttons = {}
    v15:_Init()
    return v15
end
function v_u_12.SetSerial(p16, p17)
    p16._leaderboards_serial = p17 or {}
    task.spawn(p16._Generate, p16)
end
function v_u_12.SelectLeaderboard(p18, p19)
    p18._leaderboard_name = p19
    task.spawn(p18._Generate, p18)
    for v20, v21 in pairs(p18._leaderboard_buttons) do
        v21.Button.Icon.Image = v_u_4.DisplayInfo[v20][v20 == p18._leaderboard_name and "IconFilled" or "Icon"]
        v21.Button.Icon.Size = v20 == p18._leaderboard_name and UDim2.new(1, 0, 1, 0) or UDim2.new(0.6, 0, 0.6, 0)
    end
end
function v_u_12._LiveDisplay(p22, p23)
    while true do
        p22.SurfaceGui.Live.Text = "\226\128\162 LIVE"
        wait(1)
        if p23 ~= p22._generate_hash then
            break
        end
        p22.SurfaceGui.Live.Text = "LIVE"
        wait(0.25)
        if p23 ~= p22._generate_hash then
            return
        end
    end
end
function v_u_12._Generate(p24)
    for _, v25 in pairs(p24._player_slots) do
        v25:Destroy()
    end
    p24._player_slots = {}
    p24._generate_hash = p24._generate_hash + 1
    p24.SurfaceGui.Title.Text = "Loading..."
    p24.SurfaceGui.LiveBackground.Visible = false
    p24.SurfaceGui.Live.Visible = false
    local v26 = p24._leaderboards_serial[p24._leaderboard_name]
    local v27 = v_u_4.DisplayInfo[p24._leaderboard_name] or {}
    local v28 = p24._generate_hash
    local v29 = {}
    for _, v30 in pairs(v26 and (v26.Players or {}) or {}) do
        local v31 = v30.key
        local v32 = tonumber(v31)
        table.insert(v29, v32)
    end
    local v33 = ((not v26 or (#v26.Players == 0 or #v29 == 0)) and true or false) and {} or v_u_6:GetUserInfos(v29, 25)
    if v28 == p24._generate_hash then
        p24.SurfaceGui.Title.Text = v27 and (v27.DisplayName or "\226\128\162 \226\128\162 \226\128\162") or "\226\128\162 \226\128\162 \226\128\162"
        p24.SurfaceGui.Live.Visible = v27.LiveDisplayEnabled
        p24.SurfaceGui.LiveBackground.Visible = v27.LiveDisplayEnabled
        if v27.LiveDisplayEnabled then
            task.spawn(p24._LiveDisplay, p24, v28)
        end
        for v34, v35 in pairs(v26 and v26.Players or {}) do
            local v36 = v35.key
            local v37 = v35.value
            local v38 = v33[v36]
            local v39 = v38 and (v38.DisplayName .. (v38.HasVerifiedBadge and utf8.char(57344) or "") or "\226\128\162 \226\128\162 \226\128\162") or "\226\128\162 \226\128\162 \226\128\162"
            local v40
            if v38 and v38.Username then
                if v27.SanitizeUsernames then
                    v40 = v_u_5:SanitizeName(v38.Username)
                else
                    v40 = v38.Username
                end
            else
                v40 = nil
            end
            local v41 = v38 and (v40 and v40 ~= v38.DisplayName) and ("@" .. v40 or "") or ""
            local v42 = v_u_9:Clone()
            v42.Left.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, v36)
            v42.Left.Rank.Text = "#" .. v34
            v42.Left.Rank.TextColor3 = v34 == 1 and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
            v42.Left.Rank[v34 == 1 and "Normal" or "First"]:Destroy()
            v42.Left.DisplayName.Text = v39
            v42.Left.DisplayName.Size = v34 == 1 and UDim2.new(2, 0, 0.4, 0) or UDim2.new(3, 0, 0.4, 0)
            v42.Left.Username.Text = v41
            v42.Left.Username.Size = v34 == 1 and UDim2.new(2, 0, 0.4, 0) or UDim2.new(3, 0, 0.2, 0)
            v42.Right.Icon.Value.Text = v_u_5:PrettyNumber(v37)
            v42.Right.Icon.Image = v27 and (v27.Icon or "") or ""
            v42.Right.Icon.UIGradient.Color = v27.ColorSequence
            v42.Right.Icon.Value.Position = v27.TextPosition
            v42.Right.Icon.Value.UIStroke.UIGradient.Color = v27.DarkColorSequence
            v42.Size = v34 == 1 and UDim2.new(1, 0, 0.25, 0) or UDim2.new(1, 0, 0.15, 0)
            v42.LayoutOrder = v34
            v42.Parent = p24.SurfaceGui.List.Container
            local v43 = p24._player_slots
            table.insert(v43, v42)
            if p24._leaderboard_name == "Highest ELO" then
                v42.Right.Icon.Visible = false
                v42.Right.Rank.Size = v34 == 1 and UDim2.new(1, 0, 1, 0) or UDim2.new(1.5, 0, 1.5, 0)
                local v44 = v_u_8.new(v37, tonumber(v36), v34)
                v44:SetParent(v42.Right.Rank)
                v44:SetLabelFromELOEvent(nil, v37, 10)
                v44:GetLabel().BackgroundTransparency = 1
                local v45 = Instance.new("UIStroke")
                v45.Thickness = 2
                v45.Parent = v44:GetLabelText()
            end
            wait(0.1)
            if v28 ~= p24._generate_hash then
                return
            end
        end
    end
end
function v_u_12._UpdateCanvasSize(p46)
    p46.SurfaceGui.List.CanvasSize = UDim2.new(0, 0, 0, p46.SurfaceGui.List.Container.Layout.AbsoluteContentSize.Y)
end
function v_u_12._Setup(p_u_47)
    local v48 = nil
    for v49, v_u_50 in pairs(v_u_4.Order) do
        if v_u_4.DisplayInfo[v_u_50].DisplayID == p_u_47._display_id then
            local v51 = v_u_10:Clone()
            v51.LayoutOrder = v49
            v51.Parent = p_u_47.SurfaceGui.Buttons
            p_u_47._leaderboard_buttons[v_u_50] = v51
            v51.Button.MouseButton1Click:Connect(function()
                p_u_47:SelectLeaderboard(v_u_50)
            end)
            v_u_7:Add(v51.Button, nil, {
                ["HoverRatio"] = 1.05,
                ["ReleaseRatio"] = 1.05
            })
            v48 = v48 or v_u_50
        end
    end
    p_u_47:SelectLeaderboard(v48)
    p_u_47.SurfaceGui.Adornee = p_u_47.Part
    p_u_47.SurfaceGui.Parent = v_u_2.LocalPlayer.PlayerGui
end
function v_u_12._Init(p_u_52)
    p_u_52.SurfaceGui.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_52:_UpdateCanvasSize()
    end)
    p_u_52:_Setup()
    p_u_52:_UpdateCanvasSize()
end
return v_u_12