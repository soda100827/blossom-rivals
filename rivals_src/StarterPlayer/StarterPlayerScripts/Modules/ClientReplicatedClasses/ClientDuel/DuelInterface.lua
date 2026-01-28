local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GuiService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect)
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules.UserInterface.Inset)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_9 = require(script:WaitForChild("EliminationFeed"))
local v_u_10 = require(script:WaitForChild("HardcoreParkour"))
local v_u_11 = require(script:WaitForChild("FinalResults"))
local v_u_12 = require(script:WaitForChild("RoundResult"))
local v_u_13 = require(script:WaitForChild("StoryDialog"))
local v_u_14 = require(script:WaitForChild("MatchPoint"))
local v_u_15 = require(script:WaitForChild("Scoreboard"))
local v_u_16 = require(script:WaitForChild("HeadHoncho"))
local v_u_17 = require(script:WaitForChild("Buttons"))
local v_u_18 = require(script:WaitForChild("Scores"))
local v_u_19 = require(script:WaitForChild("Voting"))
local v_u_20 = require(script:WaitForChild("UpNext"))
local v_u_21 = require(script:WaitForChild("Timer"))
local v_u_22 = require(script:WaitForChild("Blur"))
local v_u_23 = v3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelInterface")
local v_u_24 = {}
v_u_24.__index = v_u_24
function v_u_24.new(p25)
    local v26 = v_u_24
    local v27 = setmetatable({}, v26)
    v27.ClientDuel = p25
    v27.Frame = v_u_23:Clone()
    v27.FinalResults = v_u_11.new(v27)
    v27.Voting = v_u_19.new(v27)
    v27.EliminationFeed = v_u_9.new(v27)
    v27.RoundResult = v_u_12.new(v27)
    v27.MatchPoint = v_u_14.new(v27)
    v27.Scoreboard = v_u_15.new(v27)
    v27.Scores = v_u_18.new(v27)
    v27.Timer = v_u_21.new(v27)
    v27.UpNext = v_u_20.new(v27)
    v27.HeadHoncho = v_u_16.new(v27)
    v27.HardcoreParkour = v_u_10.new(v27)
    v27.StoryDialog = v_u_13.new(v27)
    v27.Buttons = v_u_17.new(v27)
    v27.Blur = v_u_22.new(v27)
    v27._destroyed = false
    v27._connections = {}
    v27._sounds = {}
    v27._client_duelers = {}
    v27:_Init()
    return v27
end
function v_u_24.IsActive(p28)
    return p28.Frame.Visible
end
function v_u_24.IsPageOpen(_)
    return v_u_6.PageSystem.CurrentPage ~= nil
end
function v_u_24.GetLoggedClientDuelers(p29, p30)
    if p29.ClientDuel:Get("ArcadeMode") then
        local v31 = {}
        for v32 in pairs(p29._client_duelers) do
            if not table.find(p29.ClientDuel.Duelers, v32) then
                v31[v32] = true
            end
        end
        for v33 in pairs(v31) do
            p29._client_duelers[v33] = nil
        end
    end
    if not p30 then
        return p29._client_duelers
    end
    local v34 = {}
    for v35 in pairs(p29._client_duelers) do
        local v36 = {
            ["ClientDueler"] = v35
        }
        local v37
        if p29.ClientDuel:Get("ArcadeMode") then
            if p29.ClientDuel:Get("ScoresBehavior") == "Duelers" then
                v37 = p29.ClientDuel:Get("Scores")[v35:Get("DuelerID")] or -1
            else
                v37 = p29.ClientDuel:Get("ScoresBehavior") == "Teams" and (p29.ClientDuel:Get("Scores")[v35:Get("TeamID")] or -1) or false
            end
        else
            v37 = -1
        end
        v36.Score = v37
        v36.Damage = v35:Get("Damage") or -1
        table.insert(v34, v36)
    end
    table.sort(v34, function(p38, p39)
        if p38.Score == p39.Score then
            return p38.Damage > p39.Damage
        else
            return p38.Score > p39.Score
        end
    end)
    local v40 = {}
    for _, v41 in pairs(v34) do
        local v42 = v41.ClientDueler
        table.insert(v40, v42)
    end
    return v40
end
function v_u_24.CreateSound(p43, ...)
    if p43:IsActive() then
        local v44 = v_u_4:CreateSound(...)
        local v45 = p43._sounds
        table.insert(v45, v44)
        return v44
    end
end
function v_u_24.RawCreateSound(p46, ...)
    local v47 = p46:CreateSound(...)
    local v48
    if v47 then
        v48 = table.find(p46._sounds, v47)
    else
        v48 = v47
    end
    if v48 then
        table.remove(p46._sounds, v48)
    end
    return v47
end
function v_u_24.Destroy(p49)
    p49._destroyed = true
    for _, v50 in pairs(p49._connections) do
        v50:Disconnect()
    end
    for _, v51 in pairs(p49._sounds) do
        v51:Destroy()
    end
    p49._client_duelers = {}
    p49.EliminationFeed:Destroy()
    p49.HardcoreParkour:Destroy()
    p49.FinalResults:Destroy()
    p49.StoryDialog:Destroy()
    p49.RoundResult:Destroy()
    p49.MatchPoint:Destroy()
    p49.Scoreboard:Destroy()
    p49.HeadHoncho:Destroy()
    p49.Buttons:Destroy()
    p49.Scores:Destroy()
    p49.Voting:Destroy()
    p49.UpNext:Destroy()
    p49.Timer:Destroy()
    p49.Blur:Destroy()
    p49.Frame:Destroy()
end
function v_u_24._UpdateSpectating(p_u_52)
    for _, v53 in pairs(p_u_52._connections) do
        v53:Disconnect()
    end
    p_u_52._connections = {}
    p_u_52.Frame.Visible = p_u_52.ClientDuel:Get("IsSpectating")
    p_u_52.Blur:Update()
    p_u_52.HardcoreParkour:Update()
    if p_u_52.Frame.Visible then
        local v54 = p_u_52._connections
        local v55 = p_u_52.ClientDuel.DuelerRemoved
        table.insert(v54, v55:Connect(function(p56)
            if p_u_52.ClientDuel:Get("ArcadeMode") then
                p_u_52._client_duelers[p56] = nil
            end
            p_u_52.Scoreboard:Generate()
        end))
        local v57 = p_u_52._connections
        local v58 = p_u_52.ClientDuel:GetDataChangedSignal("MaxMapBansPerTeam")
        table.insert(v57, v58:Connect(function()
            p_u_52.Voting:Generate()
        end))
        local v59 = p_u_52._connections
        local v60 = p_u_52.ClientDuel:GetDataChangedSignal("VoteBansRemaining")
        table.insert(v59, v60:Connect(function()
            p_u_52.Voting:Generate()
        end))
        local v61 = p_u_52._connections
        local v62 = p_u_52.ClientDuel:GetDataChangedSignal("VoteOptions")
        table.insert(v61, v62:Connect(function()
            p_u_52.Voting:Generate()
            p_u_52.Timer:UpdateSizeAndPosition()
            p_u_52.Scores:Generate()
        end))
        local v63 = p_u_52._connections
        local v64 = p_u_52.ClientDuel:GetDataChangedSignal("ScoreNeededToWin")
        table.insert(v63, v64:Connect(function()
            p_u_52.Scores:Generate()
        end))
        local v65 = p_u_52._connections
        local v66 = p_u_52.ClientDuel:GetDataChangedSignal("ScoresBehavior")
        table.insert(v65, v66:Connect(function()
            p_u_52.Scores:Generate()
        end))
        local v67 = p_u_52._connections
        local v68 = p_u_52.ClientDuel:GetDataChangedSignal("Status")
        table.insert(v67, v68:Connect(function()
            p_u_52.Buttons:Update()
            p_u_52.Scoreboard:Open()
            p_u_52.HeadHoncho:Update()
            p_u_52.HardcoreParkour:Update()
            p_u_52.StoryDialog:Update()
            p_u_52.UpNext:Update()
            if p_u_52.ClientDuel:Get("ArcadeMode") and p_u_52.ClientDuel:Get("Status") == "GameOver" then
                p_u_52:CreateSound("rbxassetid://99135525400251", 2, 1, script, true, 5)
            end
        end))
        local v69 = p_u_52._connections
        local v70 = p_u_52.ClientDuel:GetDataChangedSignal("CanSwitchItems")
        table.insert(v69, v70:Connect(function()
            p_u_52.Buttons:Update()
        end))
        local v71 = p_u_52._connections
        local v72 = p_u_52.ClientDuel:GetDataChangedSignal("RoundNum")
        table.insert(v71, v72:Connect(function()
            p_u_52.Buttons:Update()
        end))
        local v73 = p_u_52._connections
        local v74 = p_u_52.ClientDuel:GetDataChangedSignal("CanTrackStatistics")
        table.insert(v73, v74:Connect(function()
            p_u_52.Buttons:Update()
        end))
        local v75 = p_u_52._connections
        local v76 = p_u_52.ClientDuel:GetDataChangedSignal("RematchCount")
        table.insert(v75, v76:Connect(function()
            p_u_52.FinalResults.Buttons:Update()
        end))
        local v77 = p_u_52._connections
        local v78 = p_u_52.ClientDuel:GetDataChangedSignal("RematchGoal")
        table.insert(v77, v78:Connect(function()
            p_u_52.FinalResults.Buttons:Update()
        end))
        local v79 = p_u_52._connections
        local v80 = p_u_52.ClientDuel:GetDataChangedSignal("RematchAvailable")
        table.insert(v79, v80:Connect(function()
            p_u_52.FinalResults.Buttons:Update()
        end))
        local v81 = p_u_52._connections
        local v82 = p_u_52.ClientDuel:GetDataChangedSignal("RematchSuccess")
        table.insert(v81, v82:Connect(function()
            p_u_52.FinalResults.Buttons:Update()
        end))
        local v83 = p_u_52._connections
        local v84 = p_u_52.ClientDuel:GetDataChangedSignal("StaggeredSpawnsOrder")
        table.insert(v83, v84:Connect(function()
            p_u_52.Scoreboard:Generate()
            p_u_52.UpNext:Update()
            p_u_52.Buttons:Update()
        end))
        local v85 = p_u_52._connections
        local v86 = p_u_52.ClientDuel:GetDataChangedSignal("HideMostDuelInterfaceElements")
        table.insert(v85, v86:Connect(function()
            p_u_52.Timer:Update()
            p_u_52.Scores:UpdateVisibility()
        end))
        local v87 = p_u_52._connections
        local v88 = v_u_2:GetPropertyChangedSignal("PreferredTransparency")
        table.insert(v87, v88:Connect(function()
            p_u_52.Scoreboard:UpdatePreferredTransparency()
        end))
        local v89 = p_u_52._connections
        local v90 = v_u_5.VisibilityChanged
        table.insert(v89, v90:Connect(function()
            p_u_52.UpNext:Update()
        end))
        local v91 = p_u_52._connections
        local v92 = v_u_6.PageSystem.PagesActivity
        table.insert(v91, v92:Connect(function()
            p_u_52.Buttons:Update()
            p_u_52.Scores:UpdateVisibility()
            p_u_52.EliminationFeed:Update()
            p_u_52.Timer:Update()
            p_u_52.Scoreboard:Open()
            p_u_52.Voting:Generate()
            p_u_52.RoundResult:UpdateVisibility()
            p_u_52.FinalResults:UpdateVisibility()
            p_u_52.HeadHoncho:Update()
            p_u_52.HardcoreParkour:Update()
            p_u_52.StoryDialog:Update()
        end))
        local v93 = p_u_52._connections
        local v94 = v_u_7.MainFrame:GetPropertyChangedSignal("AbsoluteSize")
        table.insert(v93, v94:Connect(function()
            p_u_52.EliminationFeed:UpdatePosition()
        end))
        local function v102(p95, _)
            local v96 = p_u_52._connections
            local v97 = p95:GetDataChangedSignal("ObbyStartPosition")
            local function v98()
                p_u_52.HardcoreParkour:Update()
            end
            table.insert(v96, v97:Connect(v98))
            local v99 = p_u_52._connections
            local v100 = p95:GetDataChangedSignal("ObbyFinishPosition")
            local function v101()
                p_u_52.HardcoreParkour:Update()
            end
            table.insert(v99, v100:Connect(v101))
            p_u_52.HardcoreParkour:Update()
        end
        local v103 = p_u_52._connections
        local v104 = p_u_52.ClientDuel.MapAdded
        table.insert(v103, v104:Connect(v102))
        if p_u_52.ClientDuel.Map then
            task.spawn(v102, p_u_52.ClientDuel.Map, true)
        end
        local function v161(p_u_105, p106)
            local v107 = p_u_52._connections
            local v108 = p_u_105:GetDataChangedSignal("LastVote")
            local function v109()
                p_u_52.Voting:Generate()
            end
            table.insert(v107, v108:Connect(v109))
            local v110 = p_u_52._connections
            local v111 = p_u_105:GetDataChangedSignal("IsHeadHoncho")
            local function v112()
                p_u_52.HeadHoncho:Update()
            end
            table.insert(v110, v111:Connect(v112))
            local v113 = p_u_52._connections
            local v114 = p_u_105:GetDataChangedSignal("Eliminations")
            local function v115()
                p_u_52.Scoreboard:Generate()
            end
            table.insert(v113, v114:Connect(v115))
            local v116 = p_u_52._connections
            local v117 = p_u_105:GetDataChangedSignal("Deaths")
            local function v118()
                p_u_52.Scoreboard:Generate()
            end
            table.insert(v116, v117:Connect(v118))
            local v119 = p_u_52._connections
            local v120 = p_u_105:GetDataChangedSignal("Assists")
            local function v121()
                p_u_52.Scoreboard:Generate()
            end
            table.insert(v119, v120:Connect(v121))
            local v122 = p_u_52._connections
            local v123 = p_u_105:GetDataChangedSignal("Damage")
            local function v124()
                p_u_52.Scoreboard:Generate()
            end
            table.insert(v122, v123:Connect(v124))
            local v125 = p_u_52._connections
            local v126 = p_u_105.ItemAdded
            local function v127()
                p_u_52.Scoreboard:Generate()
            end
            table.insert(v125, v126:Connect(v127))
            local v128 = p_u_52._connections
            local v129 = p_u_105.ItemRemoved
            local function v130()
                p_u_52.Scoreboard:Generate()
            end
            table.insert(v128, v129:Connect(v130))
            local v131 = p_u_52._connections
            local v132 = p_u_105.Died
            local function v133()
                p_u_52.UpNext:Update()
                if p_u_105.IsLocalPlayer then
                    p_u_52.Buttons:Update()
                end
            end
            table.insert(v131, v132:Connect(v133))
            local v134 = p_u_52._connections
            local v135 = p_u_105.EntityAdded
            local function v136()
                p_u_52.UpNext:Update()
                if p_u_105.IsLocalPlayer then
                    p_u_52.Buttons:Update()
                end
            end
            table.insert(v134, v135:Connect(v136))
            local v137 = p_u_52._connections
            local v138 = p_u_105.HealthChanged
            local function v139()
                p_u_52.Scoreboard:Generate()
                p_u_52.UpNext:Update()
                if p_u_105.IsLocalPlayer then
                    p_u_52.Buttons:Update()
                end
            end
            table.insert(v137, v138:Connect(v139))
            local v140 = p_u_52._connections
            local v141 = p_u_105.ClientFighter:GetDataChangedSignal("ConnectionLevel")
            local function v142()
                p_u_52.Scoreboard:Generate()
            end
            table.insert(v140, v141:Connect(v142))
            if p_u_105.IsLocalPlayer then
                local v143 = p_u_52._connections
                local v144 = p_u_105:GetDataChangedSignal("SwitchItemsCount")
                local function v145()
                    p_u_52.Buttons:Update()
                end
                table.insert(v143, v144:Connect(v145))
                local v146 = p_u_52._connections
                local v147 = p_u_105:GetDataChangedSignal("SwitchItemsMax")
                local function v148()
                    p_u_52.Buttons:Update()
                end
                table.insert(v146, v147:Connect(v148))
                local v149 = p_u_52._connections
                local v150 = p_u_105:GetDataChangedSignal("TeamID")
                local function v151()
                    p_u_52.Scores:Generate()
                end
                table.insert(v149, v150:Connect(v151))
                local v152 = p_u_52._connections
                local v153 = p_u_105.ClientFighter:GetDataChangedSignal("CanPickWeapons")
                local function v154()
                    p_u_52.Buttons:Update()
                end
                table.insert(v152, v153:Connect(v154))
                local v155 = p_u_52._connections
                local v156 = p_u_105.ClientFighter:GetDataChangedSignal("LastPickedWeapons")
                local function v157()
                    p_u_52.Buttons:Update()
                end
                table.insert(v155, v156:Connect(v157))
                local v158 = p_u_52._connections
                local v159 = p_u_105.ClientFighter.InvincibilityChanged
                local function v160()
                    p_u_52.Buttons:Update()
                end
                table.insert(v158, v159:Connect(v160))
            end
            p_u_52._client_duelers[p_u_105] = true
            if not p106 then
                p_u_52.Buttons:Update()
                p_u_52.Scoreboard:Generate()
                p_u_52.StoryDialog:Update()
                if p_u_105.IsLocalPlayer then
                    p_u_52.Scores:Generate()
                end
            end
        end
        local v162 = p_u_52._connections
        local v163 = p_u_52.ClientDuel.DuelerAdded
        table.insert(v162, v163:Connect(v161))
        for _, v164 in pairs(p_u_52.ClientDuel.Duelers) do
            task.spawn(v161, v164, true)
        end
        p_u_52.Buttons:Update()
        p_u_52.Scores:UpdateVisibility()
        p_u_52.Scores:Generate()
        p_u_52.Voting:Generate()
        p_u_52.Timer:UpdateSizeAndPosition()
        p_u_52.Timer:Update()
        p_u_52.Scoreboard:Generate()
        p_u_52.Scoreboard:UpdatePreferredTransparency()
        p_u_52.Scoreboard:Open(false)
        p_u_52.EliminationFeed:Update()
        p_u_52.RoundResult:UpdateVisibility()
        p_u_52.FinalResults:UpdateVisibility()
        p_u_52.UpNext:Update()
        p_u_52.HeadHoncho:Update()
        p_u_52.HardcoreParkour:Update()
        p_u_52.StoryDialog:Update()
    end
end
function v_u_24._Setup(p165)
    p165.Frame.Visible = false
    p165.Frame.Parent = v_u_8:GetTo("MainFrame", "DuelInterfaces")
end
function v_u_24._Init(p_u_166)
    p_u_166.ClientDuel:GetDataChangedSignal("IsSpectating"):Connect(function()
        p_u_166:_UpdateSpectating()
    end)
    p_u_166:_Setup()
    task.spawn(p_u_166._UpdateSpectating, p_u_166)
end
return v_u_24