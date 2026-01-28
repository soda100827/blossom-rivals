local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.ItemLibrary)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Modules.VoteBanFrame)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local v_u_8 = v2.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("WeaponSlot")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9.new(p10, p11)
    local v12 = v_u_9
    local v13 = setmetatable({}, v12)
    v13.PlayBanFrameSound = v_u_4.new()
    v13.Name = p10
    v13.WeaponData = p11
    v13.Frame = v_u_8:Clone()
    v13._destroyed = false
    v13._vote_ban_frame = nil
    v13:_Init()
    return v13
end
function v_u_9.DisableButton(p14)
    p14.Frame.Button.Interactable = false
end
function v_u_9.ToggleBanned(p_u_15, p16, p17)
    p_u_15.Frame.Button.Icon.ClipsDescendants = true
    p_u_15.Frame.Button.Title.Visible = false
    local v18 = v_u_6.new(p_u_15.Frame.Button, UDim2.new(0.75, 0, 0.75, 0))
    v18.CreateSound:Connect(function(...)
        p_u_15.PlayBanFrameSound:Fire(...)
    end)
    task.delay(p16, v18.Play, v18, p17, true)
end
function v_u_9.HideName(p19)
    p19.Frame.Button.Title.Text = "???"
end
function v_u_9.Lock(p20)
    p20.Frame.Button.Locked.Visible = true
    p20.Frame.Button.Title.TextTransparency = 0.5
    p20.Frame.Button.Icon.Picture.ImageColor3 = Color3.fromRGB(0, 0, 0)
    p20.Frame.Button.Icon.Picture.ImageTransparency = 0.5
end
function v_u_9.Destroy(p_u_21)
    if not p_u_21._destroyed then
        p_u_21._destroyed = true
        p_u_21.PlayBanFrameSound:Destroy()
        if p_u_21._vote_ban_frame then
            p_u_21._vote_ban_frame:Destroy()
        end
        pcall(function()
            p_u_21.Frame:Destroy()
        end)
    end
end
function v_u_9._Setup(p22)
    p22.Frame.Button.Title.Text = p22.Name
    p22.Frame.Button.Icon.Picture.Image = p22.WeaponData and v_u_3:GetViewModelImageFromWeaponData(p22.WeaponData) or (v_u_3:GetViewModelImage(p22.Name) or "")
    v_u_5:ApplyItemStatusToBackground(p22.Frame.Button.Background, p22.Frame.Button.Background.UIStroke, v_u_3.Items[p22.Name].Status)
end
function v_u_9._Init(p_u_23)
    p_u_23.Frame.Destroying:Connect(function()
        p_u_23:Destroy()
    end)
    p_u_23:_Setup()
    v_u_7:Add(p_u_23.Frame.Button)
end
return v_u_9