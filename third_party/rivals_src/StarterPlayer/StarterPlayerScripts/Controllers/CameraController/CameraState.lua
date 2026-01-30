local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_4 = require(v1.Modules.DebugLibrary)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PrivateServerController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_9 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CustomFreecam")
local v_u_10 = {
    ["FirstPerson"] = "FirstPerson",
    ["ThirdPerson"] = "ThirdPerson",
    ["ThirdPersonMirrored"] = "ThirdPersonMirrored",
    ["ThirdPersonUnlockedMouse"] = "ThirdPersonUnlockedMouse",
    ["CustomFreecam"] = "CustomFreecam"
}
local v_u_11 = {
    ["8358627342"] = true,
    ["8387653630"] = true
}
local v_u_12 = {}
v_u_12.__index = v_u_12
v_u_12.States = v_u_10
v_u_12.POVStates = {
    "FirstPerson",
    "ThirdPerson",
    "ThirdPersonMirrored",
    "ThirdPersonUnlockedMouse"
}
function v_u_12.new(p13)
    local v14 = v_u_12
    local v15 = setmetatable({}, v14)
    v15.StateChanged = v_u_5.new()
    v15.FreecamAccessChanged = v_u_5.new()
    v15.CameraController = p13
    v15._public_state = nil
    v15._pov_state = nil
    v15._is_active = false
    v15._custom_freecam_enabled = false
    v15._custom_freecam = v_u_9:Clone()
    v15._custom_freecam_script = v15._custom_freecam:WaitForChild("LocalScript")
    v15:_Init()
    return v15
end
function v_u_12.GetPublicState(p16)
    return p16._public_state
end
function v_u_12.HasFreecamAccess(_)
    local v17 = v_u_4:HasTotalAccess(v_u_3.LocalPlayer.UserId, v_u_7:Get("GroupRank"))
    if not v17 then
        local v18 = v_u_11
        local v19 = v_u_3.LocalPlayer.UserId
        v17 = v18[tostring(v19)] or v_u_6:Get("FreecamEnabled")
    end
    return v17
end
function v_u_12.SetActive(p20, p21)
    if p21 ~= p20._is_active then
        p20._is_active = p21
        p20:_UpdateState()
    end
end
function v_u_12.SetCustomFreecamEnabled(p22, p23)
    if p23 ~= p22._custom_freecam_enabled then
        p22._custom_freecam_enabled = p23
        p22:_UpdateState()
        p22._custom_freecam_script.Disabled = false
        p22._custom_freecam.Parent = v_u_3.LocalPlayer:WaitForChild("PlayerGui")
        task.defer(p22._custom_freecam.LocalScript.Toggle.Fire, p22._custom_freecam.LocalScript.Toggle, p22._custom_freecam_enabled)
    end
end
function v_u_12.TogglePOV(p24)
    local v25 = p24.CameraController:HasThirdPersonAccess()
    local v26
    if v25 then
        v26 = p24.CameraController:HasUnlockedMouseAccess()
    else
        v26 = v25
    end
    if p24._pov_state == p24.States.FirstPerson and v25 then
        p24:_SetPOVState(p24.States.ThirdPerson)
        return
    elseif p24._pov_state == p24.States.ThirdPerson and v25 then
        p24:_SetPOVState(p24.States.ThirdPersonMirrored)
        return
    elseif p24._pov_state == p24.States.ThirdPersonMirrored and v26 then
        p24:_SetPOVState(p24.States.ThirdPersonUnlockedMouse)
        return
    elseif p24.CameraController:IsSubjectEmoting() then
        p24:_SetPOVState(p24.States.ThirdPerson)
    else
        p24:_SetPOVState(p24.States.FirstPerson)
    end
end
function v_u_12.VerifyPOV(p27)
    local v28
    if p27._pov_state == p27.States.FirstPerson then
        v28 = false
    else
        v28 = not p27.CameraController:HasThirdPersonAccess()
    end
    local v29
    if p27._pov_state == p27.States.ThirdPersonUnlockedMouse then
        v29 = not p27.CameraController:HasUnlockedMouseAccess()
    else
        v29 = false
    end
    if v29 then
        if v28 then
            p27:_SetPOVState(p27.States.FirstPerson)
        else
            p27:_SetPOVState(p27.States.ThirdPerson)
        end
    else
        if v28 then
            p27:_SetPOVState(p27.States.FirstPerson)
        end
        return
    end
end
function v_u_12._SetState(p30, p31)
    local v32 = not p31 or v_u_10[p31]
    assert(v32, p31)
    if p31 ~= p30._public_state then
        local v33 = p30._public_state
        p30._public_state = p31
        p30.StateChanged:Fire(p30._public_state, v33)
    end
end
function v_u_12._UpdateState(p34)
    p34.CameraController:GetCurrentSubject()
    local v35
    if p34._custom_freecam_enabled then
        v35 = p34.States.CustomFreecam
    elseif p34._is_active then
        v35 = p34._pov_state
    else
        v35 = nil
    end
    p34:_SetState(v35)
end
function v_u_12._SetPOVState(p36, p37)
    local v38 = not p37 or v_u_10[p37]
    assert(v38, p37)
    if p37 ~= p36._pov_state then
        p36._pov_state = p37
        p36:_UpdateState()
    end
end
function v_u_12._SetupEmoteLogic(p_u_39)
    local v_u_40 = nil
    local v_u_41 = {}
    local function v_u_42()
        task.defer(function()
            if p_u_39.CameraController:IsSubjectEmoting() then
                v_u_40 = v_u_40 or p_u_39._pov_state
                p_u_39:_SetPOVState(p_u_39.States.ThirdPersonUnlockedMouse)
            else
                if v_u_40 then
                    p_u_39:_SetPOVState(v_u_40)
                    v_u_40 = nil
                end
                p_u_39:VerifyPOV()
            end
        end)
    end
    local function v58()
        for _, v43 in pairs(v_u_41) do
            v43:Disconnect()
        end
        v_u_41 = {}
        local v44 = p_u_39.CameraController:GetCurrentSubject()
        if v44 then
            local v45 = v_u_41
            local v46 = v44.EntityRemoved
            local v47 = v_u_42
            table.insert(v45, v46:Connect(v47))
            local function v52(p48)
                local v49 = v_u_41
                local v50 = p48.EmoteStatusChanged
                local v51 = v_u_42
                table.insert(v49, v50:Connect(v51))
                task.defer(function()
                    if p_u_39.CameraController:IsSubjectEmoting() then
                        v_u_40 = v_u_40 or p_u_39._pov_state
                        p_u_39:_SetPOVState(p_u_39.States.ThirdPersonUnlockedMouse)
                    else
                        if v_u_40 then
                            p_u_39:_SetPOVState(v_u_40)
                            v_u_40 = nil
                        end
                        p_u_39:VerifyPOV()
                    end
                end)
            end
            local v53 = v_u_41
            local v54 = v44.EntityAdded
            table.insert(v53, v54:Connect(v52))
            if v44.Entity then
                local v55 = v_u_41
                local v56 = v44.Entity.EmoteStatusChanged
                local v57 = v_u_42
                table.insert(v55, v56:Connect(v57))
                task.defer(function()
                    if p_u_39.CameraController:IsSubjectEmoting() then
                        v_u_40 = v_u_40 or p_u_39._pov_state
                        p_u_39:_SetPOVState(p_u_39.States.ThirdPersonUnlockedMouse)
                    else
                        if v_u_40 then
                            p_u_39:_SetPOVState(v_u_40)
                            v_u_40 = nil
                        end
                        p_u_39:VerifyPOV()
                    end
                end)
            end
        end
    end
    p_u_39.CameraController.SubjectChanged:Connect(v58)
    v58()
end
function v_u_12._SetupFreecam(p_u_59)
    task.spawn(function()
        v_u_3.LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(p60)
            if p60:IsA("ScreenGui") and p60.Name == "Freecam" then
                task.defer(p60.Destroy, p60)
            end
        end)
        for _, v61 in pairs(v_u_3.LocalPlayer.PlayerGui:GetChildren()) do
            if v61:IsA("ScreenGui") and v61.Name == "Freecam" then
                task.defer(v61.Destroy, v61)
            end
        end
    end)
    v_u_2.InputBegan:Connect(function(p62, _)
        if p62.KeyCode == Enum.KeyCode.P and (v_u_2:IsKeyDown(Enum.KeyCode.LeftShift) and p_u_59:HasFreecamAccess()) then
            p_u_59:SetCustomFreecamEnabled(not p_u_59._custom_freecam_enabled)
        end
    end)
end
function v_u_12._Setup(p63)
    if p63.CameraController:HasThirdPersonAccess() then
        p63:_SetPOVState(p63.States.FirstPerson)
    end
end
function v_u_12._Init(p_u_64)
    v_u_8.ControlsChanged:Connect(function()
        p_u_64:VerifyPOV()
    end)
    v_u_6:GetDataChangedSignal("FreecamEnabled"):Connect(function()
        p_u_64.FreecamAccessChanged:Fire()
    end)
    p_u_64:_Setup()
    p_u_64:_UpdateState()
    task.defer(p_u_64._SetupFreecam, p_u_64)
    task.defer(p_u_64._SetupEmoteLogic, p_u_64)
end
return v_u_12