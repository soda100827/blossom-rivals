local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.CosmeticLibrary)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_6.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10.UnequippedViewModel = nil
    v10._shield_attached = false
    v10._update_shield_queued = false
    v10:_Init()
    return v10
end
function v_u_7.ReplicateFromServer(p11, p12, ...)
    if p12 == "AbsorbedHit" then
        if p11:IsRendered() then
            p11.ViewModel:Impulse(Vector3.new(0, -20, 0), 1, nil, true)
            p11.ViewModel:AbsorbedHit()
        end
    else
        v_u_6.ReplicateFromServer(p11, p12, ...)
        return
    end
end
function v_u_7.Destroy(p13)
    p13.UnequippedViewModel:Destroy()
    v_u_6.Destroy(p13)
end
function v_u_7._WaitForUnequippedViewModelRoot(p14)
    local v15 = p14.ClientFighter.Entity and p14.ClientFighter.Entity.Model
    if v15 then
        v15 = p14.ClientFighter.Entity.Model:WaitForChild("UpperTorso")
    end
    return v15
end
function v_u_7._UpdateUnequippedViewModel(p_u_16)
    if p_u_16._shield_attached and not p_u_16._update_shield_queued then
        p_u_16._update_shield_queued = true
        task.delay(0.1, function()
            p_u_16._update_shield_queued = false
            if not p_u_16._destroyed then
                local v17 = not (p_u_16.IsEquipped or p_u_16.ClientFighter:IsActuallyFirstPerson())
                if v17 then
                    v17 = not p_u_16.ClientFighter:Get("IsHiddenByEmotes")
                end
                local v18
                if v17 then
                    v18 = p_u_16:_WaitForUnequippedViewModelRoot()
                else
                    v18 = v17
                end
                if v18 then
                    p_u_16.UnequippedViewModel:BreakWeld(v18)
                    p_u_16.UnequippedViewModel:PivotTo(v18.CFrame, "_riot_shield_back")
                    p_u_16.UnequippedViewModel:WeldTo(v18)
                end
                local v19 = p_u_16.UnequippedViewModel
                local v20
                if v17 then
                    v20 = p_u_16.ViewModel:GetWrap()
                else
                    v20 = nil
                end
                v19:SetWrap(v20)
                local v21 = p_u_16.UnequippedViewModel
                local v22
                if v17 then
                    v22 = p_u_16.ClientFighter.Entity and p_u_16.ClientFighter.Entity.Model or nil
                else
                    v22 = nil
                end
                v21:SetParent(v22)
            end
        end)
    end
end
function v_u_7._AttachUneqippedViewModel(p23)
    if p23._shield_attached then
        return
    else
        local v24 = p23:_WaitForUnequippedViewModelRoot()
        if v24 and (not p23._shield_attached and p23.ClientFighter:IsAlive()) then
            p23._shield_attached = true
            p23.UnequippedViewModel:PivotTo(v24.CFrame, "_riot_shield_back")
            p23.UnequippedViewModel:WeldTo(v24)
            p23:_UpdateUnequippedViewModel()
        end
    end
end
function v_u_7._Setup(p25)
    p25.UnequippedViewModel = v_u_5.new(p25.ViewModel.Name)
    p25.UnequippedViewModel:SetCharm(p25.ViewModel:Get("Charm"))
end
function v_u_7._Init(p_u_26)
    p_u_26.EquippedChanged:Connect(function()
        p_u_26:_UpdateUnequippedViewModel()
    end)
    local v27 = p_u_26._connections
    local v28 = p_u_26.ClientFighter:GetDataChangedSignal("IsSpectating")
    table.insert(v27, v28:Connect(function()
        p_u_26:_UpdateUnequippedViewModel()
    end))
    local v29 = p_u_26._connections
    local v30 = p_u_26.ClientFighter:GetDataChangedSignal("IsHiddenByEmotes")
    table.insert(v29, v30:Connect(function()
        p_u_26:_UpdateUnequippedViewModel()
    end))
    local v31 = p_u_26._connections
    local v32 = p_u_26.ClientFighter.EntityAdded
    table.insert(v31, v32:Connect(function()
        p_u_26:_AttachUneqippedViewModel()
    end))
    local v33 = p_u_26._connections
    local v34 = p_u_26.ClientFighter.HealthChanged
    table.insert(v33, v34:Connect(function()
        p_u_26:_AttachUneqippedViewModel()
    end))
    local v35 = p_u_26._connections
    local v36 = v_u_3:GetDataChangedSignal("Settings Wraps Disabled")
    table.insert(v35, v36:Connect(function()
        p_u_26:_UpdateUnequippedViewModel()
    end))
    local v37 = p_u_26._connections
    local v38 = v_u_4.POVStateChanged
    table.insert(v37, v38:Connect(function()
        p_u_26:_UpdateUnequippedViewModel()
    end))
    p_u_26:_Setup()
    task.defer(p_u_26._AttachUneqippedViewModel, p_u_26)
end
return v_u_7