local v_u_1 = game:GetService("UserInputService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Equipment = p7
    v9._connections = {}
    v9._frame = Instance.new("ImageButton")
    v9._is_mouse_down = nil
    v9._last_position = nil
    v9._velocity = Vector2.zero
    v9._rad = Vector2.zero
    v9._last_state = nil
    v9._start_resetting = nil
    v9:_Init()
    return v9
end
function v_u_6.GetCFrame(p10)
    return CFrame.Angles(0, p10._rad.X, 0) * CFrame.Angles(p10._rad.Y, 0, 0)
end
function v_u_6.Update(p11, _)
    if p11._velocity.Magnitude <= 0.001 and not p11._is_mouse_down then
        if not p11._start_resetting or tick() > p11._start_resetting then
            if p11._rad.X < -3.141592653589793 then
                p11._rad = Vector2.new(p11._rad.X + 6.283185307179586, p11._rad.Y)
            elseif p11._rad.X > 3.141592653589793 then
                p11._rad = Vector2.new(p11._rad.X - 6.283185307179586, p11._rad.Y)
            end
            if p11._rad.Y < -3.141592653589793 then
                p11._rad = Vector2.new(p11._rad.X, p11._rad.Y + 6.283185307179586)
            elseif p11._rad.Y > 3.141592653589793 then
                p11._rad = Vector2.new(p11._rad.X, p11._rad.Y - 6.283185307179586)
            end
            local v12
            if p11._start_resetting then
                local v13 = ((tick() - p11._start_resetting) / 4) ^ 2
                v12 = math.clamp(v13, 0, 1)
            else
                v12 = 1
            end
            local v14 = 1 - v12 * 0.05
            p11._rad = p11._rad * v14
        end
    else
        p11._start_resetting = tick() + 0
        p11._velocity = p11._velocity * 0.975
        p11:_Increment(p11._velocity)
        return
    end
end
function v_u_6.OnStateChanged(p15)
    p15:_CheckResetSpin()
end
function v_u_6.OnOpen(p16)
    p16._frame.Parent = p16.Equipment.IsOpen and v_u_5.MainGui or nil
    p16:_VerifyControls()
end
function v_u_6._CheckResetSpin(p17)
    local v18 = p17.Equipment:GetStateID()
    if v18 ~= p17._last_state then
        p17._last_state = v18
        p17._velocity = Vector2.zero
        p17._rad = Vector2.zero
    end
end
function v_u_6._IsDisabled(p19)
    local v20 = p19.Equipment:GetSelectedWeapon()
    local v21 = v_u_3:GetWeaponData(v20)
    if v20 then
        v20 = not v21
    end
    return v20
end
function v_u_6._GetMouseLocation(_)
    return v_u_5:GetMouseLocation()
end
function v_u_6._Increment(p22, p23)
    p22._rad = p22._rad + p23
    p22._rad = Vector2.new(p22._rad.X % 6.283185307179586, p22._rad.Y % 6.283185307179586)
end
function v_u_6._VerifyControls(p_u_24)
    for _, v25 in pairs(p_u_24._connections) do
        v25:Disconnect()
    end
    p_u_24._connections = {}
    if p_u_24.Equipment.IsOpen then
        p_u_24._is_mouse_down = nil
        p_u_24._last_position = nil
        p_u_24._velocity = Vector2.zero
        local v26 = p_u_24._connections
        local v27 = p_u_24._frame.InputBegan
        table.insert(v26, v27:Connect(function(p28)
            if not (p_u_24:_IsDisabled() or p_u_24._is_mouse_down) then
                if p28.UserInputType == Enum.UserInputType.MouseButton1 or (p28.UserInputType == Enum.UserInputType.MouseButton2 or p28.UserInputType == Enum.UserInputType.Touch) then
                    p_u_24._is_mouse_down = p28
                    p_u_24._last_position = nil
                    p_u_24._velocity = Vector2.zero
                end
            end
        end))
        local v29 = p_u_24._connections
        local v30 = v_u_1.InputEnded
        local function v33(p31)
            local v32
            if v_u_4.CurrentControls == "Touch" then
                v32 = p31 ~= p_u_24._is_mouse_down
            else
                v32 = not p_u_24._is_mouse_down
            end
            if not v32 then
                if p31.UserInputType == Enum.UserInputType.MouseButton1 or (p31.UserInputType == Enum.UserInputType.MouseButton2 or p31.UserInputType == Enum.UserInputType.Touch) then
                    p_u_24._is_mouse_down = nil
                    if p_u_24._last_position then
                        p_u_24._velocity = (p_u_24:_GetMouseLocation() - p_u_24._last_position) / 400
                    end
                end
            end
        end
        table.insert(v29, v30:Connect(v33))
        local v34 = p_u_24._connections
        local v35 = v_u_1.InputChanged
        local function v39(p36)
            local v37
            if v_u_4.CurrentControls == "Touch" then
                v37 = p36 ~= p_u_24._is_mouse_down
            else
                v37 = not p_u_24._is_mouse_down
            end
            if not v37 then
                local v38 = p_u_24:_GetMouseLocation()
                if p_u_24._last_position then
                    p_u_24:_Increment((v38 - p_u_24._last_position) / 800 * (v_u_4.CurrentControls == "Touch" and 3 or 1))
                end
                p_u_24._last_position = v38
            end
        end
        table.insert(v34, v35:Connect(v39))
    end
end
function v_u_6._Setup(p40)
    p40._frame.Name = "EquipmentSpinControls"
    p40._frame.AnchorPoint = Vector2.new(0.5, 0.5)
    p40._frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    p40._frame.Size = UDim2.new(1, 0, 1, 0)
    p40._frame.Image = ""
    p40._frame.BackgroundTransparency = 1
    p40._frame.ZIndex = -1000
    p40._frame.Visible = true
end
function v_u_6._Init(p41)
    p41:_Setup()
end
return v_u_6