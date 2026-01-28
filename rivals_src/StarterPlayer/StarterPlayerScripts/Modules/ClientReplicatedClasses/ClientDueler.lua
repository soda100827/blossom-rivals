local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.ReplicatedClass)
local v_u_5 = require(v1.Modules.DuelLibrary)
local v_u_6 = require(v1.Modules.ItemLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
require(v_u_2.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_10 = require(script:WaitForChild("HeadHoncho"))
local v_u_11 = v_u_2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TeammateLabel")
local v_u_12 = v_u_2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("DefaultDueler")
local v_u_13 = setmetatable({}, v_u_4)
v_u_13.__index = v_u_13
function v_u_13.new(p14, p15, p16)
    local v17 = v_u_4.new(p14)
    local v18 = v_u_13
    local v19 = setmetatable(v17, v18)
    v19.Died = v_u_8.new()
    v19.EntityAdded = v_u_8.new()
    v19.HealthChanged = v_u_8.new()
    v19.Eliminated = v_u_8.new()
    v19.ItemAdded = v_u_8.new()
    v19.ItemRemoved = v_u_8.new()
    local v20 = p14.Player
    if not v20 then
        if p15 then
            v20 = p15.Player
        else
            v20 = p15
        end
    end
    v19.Player = v20
    v19.ClientFighter = p15
    v19.ClientDuel = p16
    v19.IsLocalPlayer = v19.ClientFighter.IsLocalPlayer
    v19.HeadHoncho = v_u_10.new(v19)
    v19._destroyed = false
    v19._connections = {}
    v19._is_ally = false
    v19._ally_highlight = nil
    v19._ally_label = nil
    v19._preloaded_character_model = nil
    v19._is_preloading_character_model = false
    v19._recorded_viewmodel_details = {}
    v19._viewmodel_detail_check = {}
    v19:_Init()
    return v19
end
function v_u_13.IsAlive(p21)
    local v22 = p21.ClientFighter
    if v22 then
        v22 = p21.ClientFighter:IsAlive()
    end
    return v22
end
function v_u_13.IsRendered(p23)
    return p23.ClientDuel:IsRendered()
end
function v_u_13.GetHealth(p24)
    return p24.ClientFighter and p24.ClientFighter:GetHealth() or 0
end
function v_u_13.GetMaxHealth(p25)
    return p25.ClientFighter and p25.ClientFighter:GetMaxHealth() or 100
end
function v_u_13.GetCharacterModel(p26)
    return (p26._preloaded_character_model or v_u_12):Clone()
end
function v_u_13.GetCharacterModelForCutscene(p27)
    local v28 = (p27._preloaded_character_model or v_u_12):Clone()
    for _, v29 in pairs(v28:GetDescendants()) do
        if v29:IsA("BasePart") then
            v29.CanCollide = false
            v29.CanTouch = false
            v29.CanQuery = false
        end
    end
    if v28:FindFirstChild("HumanoidRootPart") then
        v28.HumanoidRootPart.Anchored = true
    end
    return v28
end
function v_u_13.GetRandomPlayedViewModelDetails(p30, p31)
    table.sort(p30._recorded_viewmodel_details, function(p32, p33)
        return v_u_7:StringLessThan(p32.ViewModelName, p33.ViewModelName)
    end)
    local v34
    if #p30._recorded_viewmodel_details > 0 then
        v34 = p30._recorded_viewmodel_details[(p31 or Random.new()):NextInteger(1, #p30._recorded_viewmodel_details)]
    else
        v34 = false
    end
    return v34
end
function v_u_13.GetStaggeredSpawnsTurn(p35)
    return table.find(p35.ClientDuel:Get("StaggeredSpawnsOrder") and (p35.ClientDuel:Get("StaggeredSpawnsOrder")[p35:Get("TeamID")] or {}) or {}, p35.Player.UserId)
end
function v_u_13.SetAlly(p36, p37)
    p36._is_ally = p37
    p36:_UpdateAllyVisuals()
end
function v_u_13.ReplicateFromServer(p38, p39, ...)
    if p39 == "EliminationEffect" then
        if p38:IsRendered() then
            p38.ClientDuel.DuelInterface.EliminationFeed:Play(p38.Player, ...)
        end
    elseif p39 == "SummaryDetails" then
        if p38.IsLocalPlayer then
            p38.ClientDuel.DuelInterface.FinalResults.Summary:SetDetails(...)
        end
    else
        v_u_4.ReplicateFromServer(p38, p39, ...)
        return
    end
end
function v_u_13.Destroy(p40)
    p40._destroyed = true
    for _, v41 in pairs(p40._connections) do
        v41:Disconnect()
    end
    if p40._ally_highlight then
        p40._ally_highlight:Destroy()
    end
    if p40._ally_label then
        p40._ally_label:Destroy()
    end
    p40.HeadHoncho:Destroy()
    p40.Died:Destroy()
    p40.EntityAdded:Destroy()
    p40.HealthChanged:Destroy()
    p40.Eliminated:Destroy()
    p40.ItemAdded:Destroy()
    p40.ItemRemoved:Destroy()
    if p40._preloaded_character_model then
        p40._preloaded_character_model:Destroy()
        p40._preloaded_character_model = nil
    end
    if p40.ClientFighter then
        p40.ClientFighter:ClearInterface()
        if p40.ClientFighter.Entity then
            p40.ClientFighter.Entity:SetTranslucent(false)
        end
    end
    v_u_4.Destroy(p40)
end
function v_u_13._UpdateTranslucence(p42)
    if not p42.IsLocalPlayer and (p42.ClientFighter and (p42.ClientFighter.Entity and p42.ClientDuel:Get("IsSpectating"))) then
        p42.ClientFighter.Entity:SetTranslucent(p42.ClientDuel:Get("Status") == "RoundStarting")
    end
end
function v_u_13._RecordEquippedViewModelDetails(p43)
    if p43.ClientFighter and (p43.ClientFighter.EquippedItem and not p43._viewmodel_detail_check[p43.ClientFighter.EquippedItem:Get("ObjectID")]) then
        p43._viewmodel_detail_check[p43.ClientFighter.EquippedItem:Get("ObjectID")] = true
        local v44 = p43.ClientFighter.EquippedItem:GetViewModelDetails()
        if v44 and not v_u_6.THIRD_PERSON_VIEWMODEL_BLACKLIST[v44.ViewModelName] then
            local v45 = p43._recorded_viewmodel_details
            table.insert(v45, v44)
        end
    else
        return
    end
end
function v_u_13._PreloadCharacterModel(p46)
    if not p46._is_preloading_character_model and p46.ClientDuel:Get("IsSpectating") then
        p46._is_preloading_character_model = true
        for _ = 1, 3 do
            wait(1)
            if p46._destroyed then
                return
            end
            local v47, v48 = pcall(v_u_2.GetHumanoidDescriptionFromUserId, v_u_2, p46.Player.UserId)
            if v47 then
                if p46._destroyed then
                    return
                end
                v48.Head = 2432102561
                v48.Torso = 15365012259
                v48.LeftArm = 15365010034
                v48.RightArm = 15365012263
                v48.LeftLeg = 15365010038
                v48.RightLeg = 15365010030
                local v49, v50 = pcall(v_u_2.CreateHumanoidModelFromDescription, v_u_2, v48, Enum.HumanoidRigType.R15)
                if v49 then
                    if p46._destroyed then
                        v50:Destroy()
                        return
                    end
                    p46._preloaded_character_model = v50
                else
                    warn("Failed to create humanoid model:", v50)
                end
            else
                warn("Failed to fetch humanoid description:", v48)
            end
        end
    end
end
function v_u_13._ClearAllyVisuals(p51)
    if p51._ally_highlight then
        p51._ally_highlight:Destroy()
        p51._ally_highlight = nil
    end
    if p51._ally_label then
        p51._ally_label:Destroy()
        p51._ally_label = nil
    end
end
function v_u_13._UpdateAllyVisuals(p52)
    p52:_ClearAllyVisuals()
    if p52.ClientDuel.LocalDueler and not (p52._is_ally and p52:IsAlive()) then
        return
    elseif not (p52.ClientFighter and (p52.ClientFighter:Get("IsSpectating") or p52.ClientFighter:Get("IsHiddenByEmotes")) or v_u_9:Get("Settings Hide Teammate Icons")) then
        local v53 = v_u_5:GetTeamColor(p52.ClientFighter:Get("TeamID"))
        local v54 = p52.ClientFighter.Entity and (p52.ClientFighter.Entity:GetHealth() / p52.ClientFighter.Entity:GetMaxHealth() or 0) or 0
        local v55 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), v54), v54)
        local v56 = Color3.new(v55.R / 2, v55.G / 2, v55.B / 2)
        p52._ally_label = v_u_11:Clone()
        p52._ally_label.Player.BackgroundColor3 = v53
        p52._ally_label.Player.Headshot.Image = string.format(v_u_3.HEADSHOT_IMAGE, p52.ClientFighter.Player.UserId)
        p52._ally_label.Health.Bar.Visible = v54 > 0
        p52._ally_label.Health.Bar.Size = UDim2.new(v54, 0, 1, 0)
        p52._ally_label.Health.BackgroundColor3 = v56
        p52._ally_label.Health.UIStroke.Color = Color3.new(v55.R * 0.25, v55.G * 0.25, v55.B * 0.25)
        p52._ally_label.Health.Bar.BackgroundColor3 = v55
        p52._ally_label.Health.Bar.UIStroke.Color = v55
        p52._ally_label.Parent = p52.ClientFighter and (p52.ClientFighter.Entity and p52.ClientFighter.Entity.RootPart) or nil
    end
end
function v_u_13._Setup(p_u_57)
    p_u_57:_RecordEquippedViewModelDetails()
    p_u_57:_UpdateAllyVisuals()
    if p_u_57.ClientFighter then
        local v58 = p_u_57._connections
        local v59 = p_u_57.ClientFighter.Died
        table.insert(v58, v59:Connect(function(...)
            p_u_57.Died:Fire(...)
        end))
        local v60 = p_u_57._connections
        local v61 = p_u_57.ClientFighter.EntityAdded
        table.insert(v60, v61:Connect(function(...)
            p_u_57.EntityAdded:Fire(...)
        end))
        local v62 = p_u_57._connections
        local v63 = p_u_57.ClientFighter.HealthChanged
        table.insert(v62, v63:Connect(function(...)
            p_u_57.HealthChanged:Fire(...)
        end))
        local v64 = p_u_57._connections
        local v65 = p_u_57.ClientFighter.Eliminated
        table.insert(v64, v65:Connect(function(...)
            p_u_57.Eliminated:Fire(...)
        end))
        local v66 = p_u_57._connections
        local v67 = p_u_57.ClientFighter.ItemAdded
        table.insert(v66, v67:Connect(function(...)
            p_u_57.ItemAdded:Fire(...)
        end))
        local v68 = p_u_57._connections
        local v69 = p_u_57.ClientFighter.ItemRemoved
        table.insert(v68, v69:Connect(function(...)
            p_u_57.ItemRemoved:Fire(...)
        end))
        local v70 = p_u_57._connections
        local v71 = p_u_57.ClientFighter:GetDataChangedSignal("IsSpectating")
        table.insert(v70, v71:Connect(function(...)
            p_u_57:_UpdateAllyVisuals()
        end))
        local v72 = p_u_57._connections
        local v73 = p_u_57.ClientFighter:GetDataChangedSignal("IsHiddenByEmotes")
        table.insert(v72, v73:Connect(function(...)
            p_u_57:_UpdateAllyVisuals()
        end))
        local v74 = p_u_57._connections
        local v75 = p_u_57.ClientFighter.EquippedItemChanged
        table.insert(v74, v75:Connect(function()
            p_u_57:_RecordEquippedViewModelDetails()
        end))
    end
end
function v_u_13._Init(p_u_76)
    p_u_76.Died:Connect(function()
        p_u_76:_UpdateAllyVisuals()
    end)
    p_u_76.EntityAdded:Connect(function()
        p_u_76:SetAlly(p_u_76._is_ally)
    end)
    p_u_76.HealthChanged:Connect(function()
        p_u_76:_UpdateAllyVisuals()
        p_u_76:_UpdateTranslucence()
    end)
    local v77 = p_u_76._connections
    local v78 = p_u_76.ClientDuel:GetDataChangedSignal("IsSpectating")
    table.insert(v77, v78:Connect(function(...)
        p_u_76:_UpdateTranslucence()
        p_u_76:_PreloadCharacterModel()
    end))
    local v79 = p_u_76._connections
    local v80 = p_u_76.ClientDuel:GetDataChangedSignal("Status")
    table.insert(v79, v80:Connect(function(...)
        p_u_76:_UpdateTranslucence()
    end))
    local v81 = p_u_76._connections
    local v82 = v_u_9:GetDataChangedSignal("Settings Hide Teammate Icons")
    table.insert(v81, v82:Connect(function(...)
        p_u_76:_UpdateAllyVisuals()
    end))
    local v83 = p_u_76._connections
    local v84 = v_u_9:GetDataChangedSignal("Settings Hide Player Nametags")
    table.insert(v83, v84:Connect(function()
        p_u_76:_UpdateAllyVisuals()
    end))
    p_u_76:_Setup()
    task.spawn(p_u_76._PreloadCharacterModel, p_u_76)
end
return v_u_13