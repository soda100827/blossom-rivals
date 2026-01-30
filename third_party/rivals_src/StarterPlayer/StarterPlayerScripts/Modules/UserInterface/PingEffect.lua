local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.BetterDebris)
local v_u_6 = require(v1.Modules.DuelLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_10 = v3.LocalPlayer.PlayerScripts.Assets.Misc.PingEffect
local v_u_11 = v3.LocalPlayer.PlayerScripts.UserInterface.PingSlot
local v_u_12 = {}
v_u_12.__index = v_u_12
function v_u_12._new()
    local v13 = v_u_12
    local v14 = setmetatable({}, v13)
    v14.Frame = v_u_9:GetTo("MainFrame", "PingEffect")
    v14._ping_objects = {}
    v14._ping_slots = {}
    v14._is_looping = false
    v14:_Init()
    return v14
end
function v_u_12.Play(p_u_15, p16, p_u_17)
    if (p16 - workspace.CurrentCamera.CFrame.Position).Magnitude <= v_u_4.RENDER_DISTANCE and v_u_8:Get("Settings Pings") then
        if p_u_15._ping_objects[p_u_17] then
            p_u_15._ping_objects[p_u_17]:Destroy()
        end
        local v18 = v_u_6:GetTeamColor(p_u_17:GetAttribute("TeamID"), Color3.fromRGB(255, 255, 255))
        local v_u_19 = v_u_10:Clone()
        v_u_19.CFrame = CFrame.new(p16)
        v_u_19.OnTop.Picture.Image = string.format(v_u_4.HEADSHOT_IMAGE, p_u_17.UserId)
        v_u_19.OnTop.Shadow.ImageColor3 = v18
        v_u_19.OnTop.Ping.ImageColor3 = v18
        v_u_19.Bright.Shadow.ImageColor3 = v18
        v_u_19.Bright.Ping.ImageColor3 = v18
        v_u_19.Parent = workspace
        v_u_5:AddItem(v_u_19, 8)
        p_u_15._ping_objects[p_u_17] = v_u_19
        v_u_19.OnTop.Picture:TweenPosition(UDim2.new(0.5, 0, 0.25, 0), "Out", "Quint", 0.25, true)
        v_u_19.OnTop.Ping:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25, true)
        v_u_19.Bright.Ping:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.25, true)
        v_u_7:CreateSound("rbxassetid://17270018886", 1, 1.5, v_u_19, true, 5)
        v_u_19.Destroying:Connect(function()
            if p_u_15._ping_objects[p_u_17] == v_u_19 then
                p_u_15._ping_objects[p_u_17] = nil
            end
            if p_u_15._ping_slots[v_u_19] then
                p_u_15._ping_slots[v_u_19]:Destroy()
                p_u_15._ping_slots[v_u_19] = nil
            end
        end)
        local v20 = v_u_11:Clone()
        v20.Picture.Image = v_u_19.OnTop.Picture.Image
        v20.Ping.ImageColor3 = v18
        v20.Parent = p_u_15.Frame
        p_u_15._ping_slots[v_u_19] = v20
        task.spawn(p_u_15._StartLoop, p_u_15)
    end
end
function v_u_12._StartLoop(p21)
    if p21._is_looping then
        return
    else
        p21._is_looping = true
        while true do
            local v22 = true
            for v23, v24 in pairs(p21._ping_slots) do
                v22 = false
                local v25 = Vector2.one * 40 + v24.AbsoluteSize / 2
                local v26 = p21.Frame.AbsoluteSize - Vector2.one * 40 - v24.AbsoluteSize / 2
                local v27, v28 = workspace.CurrentCamera:WorldToScreenPoint(v23.Position)
                local v29 = v_u_9:ScreenPointToPosition(Vector2.new(v27.X, v27.Y), p21.Frame.AbsolutePosition)
                local v30 = Vector2.new
                local v31 = v29.X
                local v32 = v25.X
                local v33 = v26.X
                local v34 = math.clamp(v31, v32, v33)
                local v35 = v29.Y
                local v36 = v25.Y
                local v37 = v26.Y
                local v38 = v30(v34, (math.clamp(v35, v36, v37)))
                if v28 or v27.Z < 0 then
                    local v39
                    if v28 then
                        v39 = false
                    else
                        v39 = v24.Visible
                    end
                    v24.Visible = v39
                else
                    local v40 = v29.X - v38.X
                    local v41 = v29.Y - v38.Y
                    local v42 = math.atan2(v40, v41)
                    local v43 = 360 - math.deg(v42)
                    v24.Rotation = v43
                    v24.Picture.Rotation = -v43
                    v24.Position = UDim2.new(0, v38.X, 0, v38.Y)
                    v24.Visible = true
                end
            end
            if v22 then
                p21._is_looping = false
                return
            end
            v_u_2.RenderStepped:Wait()
        end
    end
end
function v_u_12._Init(_) end
return v_u_12._new()