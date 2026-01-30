local v_u_1 = game:GetService("Lighting")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_4 = require(script:WaitForChild("FinisherPlayer"))
local v_u_5 = require(script:WaitForChild("EmotePlayer"))
local v_u_6 = require(script:WaitForChild("UnlockModel"))
local v_u_7 = v2.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("EquipmentScene")
local v_u_8 = {
    "Default",
    "Green Screen",
    "Pink Screen",
    "Blue Screen"
}
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10)
    local v11 = v_u_9
    local v12 = setmetatable({}, v11)
    v12.Equipment = p10
    v12.Model = v_u_7:Clone()
    v12.FinisherPlayer = v_u_4.new(v12)
    v12.EmotePlayer = v_u_5.new(v12)
    v12.UnlockModel = v_u_6.new(v12)
    v12._backgrounds_folder = v12.Model:WaitForChild("Backgrounds")
    v12._hide_career_folder = v12._backgrounds_folder:WaitForChild("Default"):WaitForChild("HideCareer")
    v12._backgrounds = {}
    v12._dof = Instance.new("DepthOfFieldEffect")
    v12:_Init()
    return v12
end
function v_u_9.GetCFrame(p13)
    return p13.Model.Primary.CFrame
end
function v_u_9.GetHumanoidCFrame(p14)
    return p14.FinisherPlayer:GetHumanoidCFrame()
end
function v_u_9.OnOpen(p15, ...)
    p15.Model.Parent = p15.Equipment.IsOpen and workspace or nil
    p15:_UpdateDOF()
    p15.UnlockModel:OnOpen(...)
end
function v_u_9.OnCustomizingStateChanged(p16, ...)
    p16.FinisherPlayer:OnCustomizingStateChanged(...)
    p16.EmotePlayer:OnCustomizingStateChanged(...)
end
function v_u_9.OnStateChanged(p17, ...)
    p17.FinisherPlayer:OnStateChanged(...)
    p17.EmotePlayer:OnStateChanged(...)
    p17.UnlockModel:OnStateChanged(...)
end
function v_u_9._UpdateDOF(p18)
    local v19 = p18._dof
    local v20
    if p18.Equipment.IsOpen and p18.Equipment:IsOpenEffectDone() ~= p18.Equipment.Camera:IsClosing() then
        v20 = v_u_1 or nil
    else
        v20 = nil
    end
    v19.Parent = v20
end
function v_u_9._UpdateCareerFolder(p21)
    local v22 = p21.Equipment:IsCareerPageOpen()
    local v23 = p21.Equipment:GetCustomizingType()
    local v24 = v22 or (v23 == "Finisher" and true or v23 == "Emote")
    local v25 = p21._hide_career_folder
    local v26
    if v24 then
        v26 = nil
    else
        v26 = p21._backgrounds.Default or nil
    end
    v25.Parent = v26
end
function v_u_9._UpdateBackgroundFolder(p27)
    local v28 = v_u_3:Get("Settings Equipment Background")
    for v29, v30 in pairs(p27._backgrounds) do
        local v31
        if v29 == v28 then
            v31 = p27._backgrounds_folder or nil
        else
            v31 = nil
        end
        v30.Parent = v31
    end
end
function v_u_9._Setup(p32)
    for _, v33 in pairs(v_u_8) do
        p32._backgrounds[v33] = p32._backgrounds_folder:WaitForChild(v33)
    end
    p32._dof.FarIntensity = 0.75
    p32._dof.FocusDistance = 0.05
    p32._dof.InFocusRadius = 15
    p32._dof.NearIntensity = 0
    p32._dof.Name = "Equipment"
end
function v_u_9._Init(p_u_34)
    p_u_34.Equipment.CareerPageOpened:Connect(function()
        p_u_34:_UpdateCareerFolder()
    end)
    p_u_34.Equipment.CustomizingChanged:Connect(function()
        p_u_34:_UpdateCareerFolder()
    end)
    p_u_34.Equipment.FinishedOpenEffect:Connect(function()
        p_u_34:_UpdateDOF()
    end)
    v_u_3:GetDataChangedSignal("Settings Equipment Background"):Connect(function()
        p_u_34:_UpdateBackgroundFolder()
    end)
    p_u_34:_Setup()
    p_u_34:_UpdateCareerFolder()
    p_u_34:_UpdateBackgroundFolder()
end
return v_u_9