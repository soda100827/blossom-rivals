local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.ConceptsLibrary)
local v_u_5 = require(v_u_1.Modules.Utility)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_8 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem"))
local v_u_9 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local v_u_10 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local v_u_11 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CreditsPlayerSlot")
local v_u_12 = {
    { "Tester", Color3.fromRGB(255, 215, 0) },
    { "Moderator", Color3.fromRGB(255, 127, 0) },
    { "Community Staff", Color3.fromRGB(127, 110, 255) }
}
local v13 = Color3.fromRGB(159, 25, 255)
local v_u_14 = Color3.fromRGB(46, 204, 113)
local v_u_15 = {
    {
        20349956,
        "Nosniy",
        "Owner, 3D Artist",
        v13
    },
    {
        15941965,
        "SenseiWarrior",
        "Owner, Programmer, UI/UX, SFX",
        v13
    },
    { 780350915, "nekoanims", "Animation" },
    { 8034104, "GreatGuyBoom", "3D Artist, 2D Artist" },
    { 1730213868, "Brian1KB", "Matchmaking, Technical Advisor" },
    { 13108868, "ShadowTrojan", "3D Artist, 2D Artist, Wraps Artist" },
    { 25056711, "PrimeVoxel", "Particles" },
    { 42477697, "D_reamz", "Renders" },
    { 945382833, "himochu", "2D Artist" },
    { 113947873, "LiamGame09", "Wraps Artist" },
    { 182316511, "BSlickMusic", "Music, SFX" },
    { 1080973296, "xlISinner", "Anticheat" },
    { 424377859, "Kurookku", "Technical Advisor" },
    { 4444072910, "FluxxyBoiOfficial", "Bot Developer" },
    { 274029164, "StaredSystemized", "Graphics" },
    { 167445091, "SoftGB", "Graphics" }
}
local v_u_16 = setmetatable({}, v_u_10)
v_u_16.__index = v_u_16
function v_u_16._new()
    local v17 = v_u_10.new(script.Name)
    local v18 = v_u_16
    local v19 = setmetatable(v17, v18)
    v19.PromptsFrame = v19.PageFrame:WaitForChild("Prompts")
    v19.PageContainer = v19.PageFrame:WaitForChild("Container")
    v19.CloseButton = v19.PageContainer:WaitForChild("Close")
    v19.List = v19.PageContainer:WaitForChild("List")
    v19.Container = v19.List:WaitForChild("Container")
    v19.Layout = v19.Container:WaitForChild("Layout")
    v19.ConceptorsFrame = v19.Container:WaitForChild("Conceptors")
    v19.ConceptorsContainer = v19.ConceptorsFrame:WaitForChild("Container")
    v19.ConceptorsPlayersFrame = v19.ConceptorsContainer:WaitForChild("Players")
    v19.ConceptorsPlayersLayout = v19.ConceptorsPlayersFrame:WaitForChild("Layout")
    v19.ConceptorsRewardFrame = v19.ConceptorsContainer:WaitForChild("Reward")
    v19.TeamFrame = v19.Container:WaitForChild("Team")
    v19.TeamContainer = v19.TeamFrame:WaitForChild("Container")
    v19.TeamPlayersFrame = v19.TeamContainer:WaitForChild("Players")
    v19.TeamPlayersLayout = v19.TeamPlayersFrame:WaitForChild("Layout")
    v19.ContributorsFrame = v19.Container:WaitForChild("Contributors")
    v19.ContributorsContainer = v19.ContributorsFrame:WaitForChild("Container")
    v19.ContributorsPlayersFrame = v19.ContributorsContainer:WaitForChild("Players")
    v19.ContributorsPlayersLayout = v19.ContributorsPlayersFrame:WaitForChild("Layout")
    v19.PromptSystem = v_u_8.new(v19.PromptsFrame)
    v19:_Init()
    return v19
end
function v_u_16._Update(p20)
    p20.List.Size = UDim2.new(0.85, 0, 0, p20.PageFrame.AbsoluteSize.Y * 0.75)
    p20.List.CanvasSize = UDim2.new(0, 0, 0, p20.Layout.AbsoluteContentSize.Y)
    p20.TeamFrame.Size = UDim2.new(1, 0, 0.1125, p20.TeamPlayersLayout.AbsoluteContentSize.Y)
    p20.ContributorsFrame.Size = UDim2.new(1, 0, 0.1125, p20.ContributorsPlayersLayout.AbsoluteContentSize.Y)
    p20.ConceptorsFrame.Size = UDim2.new(1, 0, 0.1325, p20.ConceptorsPlayersLayout.AbsoluteContentSize.Y)
end
function v_u_16._Generate(p_u_21)
    local v22 = v_u_1.Remotes.Misc.RequestGroupMembers:InvokeServer()
    local v23 = {}
    for _, v24 in pairs(v_u_15) do
        local v25 = v24[1]
        table.insert(v23, v25)
    end
    for _, v26 in pairs(v_u_12) do
        for _, v27 in pairs(v22[v26[1]] or {}) do
            table.insert(v23, v27)
        end
    end
    for _, v28 in pairs(v_u_4.Leaderboard) do
        local v29 = v28.key
        local v30 = tonumber(v29)
        table.insert(v23, v30)
    end
    local v31 = v_u_6:GetUserInfos(v23)
    local v32 = 0
    local v33
    if v_u_5:IsAprilFools() then
        local v34 = Color3.fromRGB(255, 255, 255)
        local v35 = p_u_21.ContributorsPlayersFrame
        v32 = v32 + 1
        local v36 = v_u_11:Clone()
        v36.LayoutOrder = v32
        v36.Description.Text = "Puppetmaster"
        v36.Username.Text = "00bandoboy"
        v36.Headshot.Image = "rbxassetid://129167087849991"
        v36.Background.ImageColor3 = v34
        v36.Parent = v35
        v33 = v32
    else
        v33 = v32
    end
    for _, v37 in pairs(v_u_15) do
        local v38, _, v39, v40 = table.unpack(v37)
        local v41 = v31[tostring(v38)]
        local v42 = v41 and (v41.Username and "@" .. v41.Username) or "\226\128\162 \226\128\162 \226\128\162"
        local v43 = v40 or v_u_14
        local v44 = p_u_21.ContributorsPlayersFrame
        v32 = v33 + 1
        local v45 = v_u_11:Clone()
        v45.LayoutOrder = v32
        v45.Description.Text = v39
        v45.Username.Text = v42
        v45.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, v38)
        v45.Background.ImageColor3 = v43
        v45.Parent = v44
        v33 = v32
    end
    for _, v46 in pairs(v_u_12) do
        local v47, v48 = table.unpack(v46)
        for _, v49 in pairs(v22[v47] or {}) do
            local v50 = v31[tostring(v49)]
            local v51 = v50 and (v50.Username and "@" .. v50.Username) or "\226\128\162 \226\128\162 \226\128\162"
            local v52 = p_u_21.TeamPlayersFrame
            v32 = v33 + 1
            local v53 = v_u_11:Clone()
            v53.LayoutOrder = v32
            v53.Description.Text = v47
            v53.Username.Text = v51
            v53.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, v49)
            v53.Background.ImageColor3 = v48
            v53.Parent = v52
            v33 = v32
        end
    end
    for v54, v_u_55 in pairs(v_u_4.Leaderboard) do
        local v56 = v31[v_u_55.key]
        local v_u_57 = v56 and (v56.Username and "@" .. v56.Username) or "\226\128\162 \226\128\162 \226\128\162"
        local v58 = string.format("%.1f", v_u_55.value) .. " points"
        local v59 = v_u_55.key
        local v60 = Color3.fromRGB(0, 0, 0)
        local v61 = p_u_21.ConceptorsPlayersFrame
        v32 = v33 + 1
        local v62 = v_u_11:Clone()
        v62.LayoutOrder = v32
        v62.Description.Text = v58
        v62.Username.Text = v_u_57
        v62.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, v59)
        v62.Background.ImageColor3 = v60
        v62.Parent = v61
        v62.LayoutOrder = v54
        v62.Button.Visible = true
        v62.Button.MouseButton1Click:Connect(function()
            local v63 = p_u_21.PromptSystem
            local v64 = v_u_55.key
            v63:Open("InspectConceptor", tonumber(v64), v_u_57)
        end)
        v_u_7:Add(v62.Button)
        v33 = v32
    end
end
function v_u_16._Setup(p65)
    v_u_9.new({
        ["Name"] = v_u_4.CONCEPT_REWARD_NAME,
        ["Weapon"] = "IsRandom"
    }):SetParent(p65.ConceptorsRewardFrame)
end
function v_u_16._Init(p_u_66)
    p_u_66.CloseButton.MouseButton1Click:Connect(function()
        p_u_66:CloseRequest()
    end)
    p_u_66.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_66:_Update()
    end)
    p_u_66.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_66:_Update()
    end)
    p_u_66.ContributorsPlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_66:_Update()
    end)
    p_u_66.ConceptorsPlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_66:_Update()
    end)
    p_u_66:_Setup()
    p_u_66:_Update()
    task.defer(p_u_66._Generate, p_u_66)
    v_u_7:Add(p_u_66.CloseButton)
end
return v_u_16._new()