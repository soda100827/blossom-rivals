local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GamepadService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v1.Modules.InputLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v1.Modules.Signal)
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_9 = v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface")
local v_u_10 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MainGui")
local v_u_11 = {
    "Shutdown",
    "PurchasePrompt",
    "MobileButtons",
    "Inset",
    "SwitchCameraPOV",
    "Pages",
    "Panels",
    "Equipment",
    "Queue",
    "EliminatedEffect",
    "Spectate",
    "HUD",
    "Lobby",
    "Notifications",
    "SideTasks",
    "Teleporting",
    "ShootingRange",
    "MatchmadeOverlay",
    "Spotlight",
    "JoystickModal",
    "SideParty",
    "BossHealth",
    "PlayerList"
}
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_12
    local v14 = setmetatable({}, v13)
    v14.ElementsLoaded = v_u_7.new()
    v14.PageSystemPagesActivity = v_u_7.new()
    v14.EquipmentOpened = v_u_7.new()
    v14.MainGui = v_u_10
    v14._are_elements_loaded = false
    v14._elements = {}
    v14._selected_object_connections = {}
    v14._gamepad_connections = {}
    v14:_Init()
    return v14
end
function v_u_12.GetDefaultElement(p15)
    return p15._elements.Pages and p15._elements.Pages:GetDefaultElement() or nil
end
function v_u_12.IsPageOpen(p16, p17)
    local v18 = p16._elements[p17 or "Pages"]
    local v19 = v18 and v18.PageSystem
    if v19 then
        v19 = v18.PageSystem.CurrentPage
    end
    return v19
end
function v_u_12.IsEquipmentOpen(p20)
    local v21 = p20._elements.Equipment
    if v21 then
        v21 = p20._elements.Equipment.IsOpen
    end
    return v21
end
function v_u_12.GetPage(p22, ...)
    local v23 = p22._elements.Pages
    if v23 then
        v23 = p22._elements.Pages.PageSystem:GetPage(...)
    end
    return v23
end
function v_u_12.OpenPage(p24, ...)
    local v25 = p24._elements.Pages
    if v25 then
        v25 = p24._elements.Pages.PageSystem:OpenPage(...)
    end
    return v25
end
function v_u_12.WaitUntilLoaded(p26)
    if not p26._are_elements_loaded then
        p26.ElementsLoaded:Wait()
    end
end
function v_u_12.CloseRequest(p27)
    local v28 = p27:IsPageOpen()
    if v28 then
        if not v28.CantBeClosedFromInputs then
            p27._elements.Pages:CloseRequest()
        end
        return
    elseif p27:IsEquipmentOpen() then
        p27._elements.Equipment:CloseRequest()
        return
    else
        local v29 = p27:_GetSpectatedDuelInterface()
        if v29 and (v29.FinalResults.Buttons.LeaveFrame.Visible or v29.FinalResults.Buttons.ContinueFrame.Visible) then
            if v29.FinalResults.Buttons.ContinueFrame.Visible then
                v29.FinalResults.Buttons:Continue()
            else
                v29.FinalResults.Buttons:LeaveRequest()
            end
        else
            return
        end
    end
end
function v_u_12.PrimaryAction(p30)
    if p30._elements.Lobby and (p30._elements.Lobby.Play and (p30._elements.Lobby.Play.IsPlayVisible and v_u_6:IsUIElementVisible(p30._elements.Lobby.Play.PlayButton))) then
        p30._elements.Lobby.Play:OpenPlayPage()
        return
    else
        local v31 = p30:_GetSpectatedDuelInterface()
        if v31 and v31.FinalResults.Buttons.PlayAgainFrame.Visible then
            v31.FinalResults.Buttons:PlayAgain()
        end
    end
end
function v_u_12.SecondaryAction(p32)
    if p32._elements.Pages then
        local v33 = p32:_GetSpectatedDuelInterface()
        if v33 and v33.FinalResults.Buttons.RematchFrame.Visible then
            v33.FinalResults.Buttons:Rematch()
        else
            local v34 = p32:_GetSpectatedSubject()
            if v34 then
                v34 = v34:Get("IsInShootingRange") or v34:Get("IsInDuel")
            end
            local v35 = p32:IsPageOpen()
            if not (v35 or v34) or v35 and v35.Name ~= "Party" then
                local v36 = p32._elements.Lobby and p32._elements.Lobby.Party
                if v36 then
                    v36 = p32._elements.Lobby.Party.IsVisible
                end
                local v37 = p32._elements.SideParty
                if v37 then
                    v37 = p32._elements.SideParty.IsVisible
                end
                if v36 or v37 then
                    p32._elements.Pages.PageSystem:OpenPage("Party", true)
                    return
                end
            end
        end
    else
        return
    end
end
function v_u_12.TertiaryAction(p38)
    if p38._elements.Lobby and (p38._elements.Lobby.Play and (p38._elements.Lobby.Play.IsHubVisible and v_u_6:IsUIElementVisible(p38._elements.Lobby.Play.HubButton))) then
        p38._elements.Lobby.Play:GoBackToHub()
    end
end
function v_u_12.QuaternaryAction(p39)
    if p39._elements.Lobby and (p39._elements.Lobby.Play and (p39._elements.Lobby.Play.IsRematchVisible and v_u_6:IsUIElementVisible(p39._elements.Lobby.Play.RematchButton))) then
        p39._elements.Lobby.Play:RematchRequest()
    end
end
function v_u_12._GetSpectatedSubject(_)
    return require(v_u_4.LocalPlayer.PlayerScripts.Controllers.SpectateController).CurrentSubject
end
function v_u_12._GetSpectatedDuelInterface(_)
    local v40 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.SpectateController)
    local v41 = v40.CurrentDuelSubject
    if v41 then
        v41 = v40.CurrentDuelSubject.DuelInterface
    end
    return v41
end
function v_u_12._CheckSelectedObjectVisible(_)
    if v_u_3.SelectedObject and not v_u_6:IsUIElementVisible(v_u_3.SelectedObject) then
        v_u_2:DisableGamepadCursor()
    end
end
function v_u_12._UpdateSelectedObject(p_u_42)
    if v_u_4.LocalPlayer:FindFirstChild("PlayerGui") then
        if v_u_3.SelectedObject then
            for _, v43 in pairs(p_u_42._selected_object_connections) do
                v43:Disconnect()
            end
            p_u_42._selected_object_connections = {}
            local v44 = p_u_42._selected_object_connections
            local v45 = v_u_3.SelectedObject.AncestryChanged
            table.insert(v44, v45:Connect(function()
                p_u_42:_CheckSelectedObjectVisible()
            end))
            local v46 = p_u_42._selected_object_connections
            local v47 = v_u_3.SelectedObject:GetPropertyChangedSignal("Visible")
            table.insert(v46, v47:Connect(function()
                p_u_42:_CheckSelectedObjectVisible()
            end))
            p_u_42:_CheckSelectedObjectVisible()
            return
        else
            local v48 = p_u_42:GetDefaultElement()
            local v49
            if v48 and (v48:IsDescendantOf(v_u_4.LocalPlayer.PlayerGui) and v48) then
                v49 = v48
            else
                v49 = nil
            end
            if v48 then
                v_u_2:EnableGamepadCursor(v49)
                v_u_3.SelectedObject = v49
            else
                v_u_2:DisableGamepadCursor()
                v_u_3.SelectedObject = nil
            end
        end
    else
        return
    end
end
function v_u_12._UpdateGamepadControls(p50)
    for _, v51 in pairs(p50._gamepad_connections) do
        v51:Disconnect()
    end
    for _, v52 in pairs(p50._selected_object_connections) do
        v52:Disconnect()
    end
    p50._gamepad_connections = {}
    p50._selected_object_connections = {}
    if v_u_8.CurrentControls ~= "Gamepad" then
    end
end
function v_u_12._Setup(p_u_53)
    task.defer(function()
        for _, v54 in pairs(v_u_11) do
            p_u_53._elements[v54] = require(v_u_9:WaitForChild(v54))
        end
        p_u_53._elements.Pages.PageSystem.PagesActivity:Connect(function(...)
            p_u_53.PageSystemPagesActivity:Fire(...)
        end)
        p_u_53._elements.Equipment.Opened:Connect(function(...)
            p_u_53.EquipmentOpened:Fire(...)
        end)
        p_u_53._are_elements_loaded = true
        p_u_53.ElementsLoaded:Fire()
    end)
    p_u_53.MainGui.Parent = v_u_4.LocalPlayer:WaitForChild("PlayerGui")
end
function v_u_12._Init(p_u_55)
    v_u_8.ControlsChanged:Connect(function()
        p_u_55:_UpdateGamepadControls()
    end)
    v_u_8.InputBegan:Connect(function(p56, p57)
        if p57 then
            return
        elseif v_u_5:InputIs(p56, "UICancelAction") then
            p_u_55:CloseRequest()
            return
        elseif v_u_5:InputIs(p56, "UIPrimaryAction") then
            p_u_55:PrimaryAction()
            return
        elseif v_u_5:InputIs(p56, "UISecondaryAction") then
            p_u_55:SecondaryAction()
            return
        elseif v_u_5:InputIs(p56, "UITertiaryAction") then
            p_u_55:TertiaryAction()
        elseif v_u_5:InputIs(p56, "UIQuaternaryAction") then
            p_u_55:QuaternaryAction()
        end
    end)
    p_u_55:_Setup()
    p_u_55:_UpdateGamepadControls()
end
return v_u_12._new()