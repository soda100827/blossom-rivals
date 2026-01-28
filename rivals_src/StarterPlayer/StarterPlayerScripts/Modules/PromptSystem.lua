local v1 = game:GetService("ReplicatedStorage")
game:GetService("UserInputService")
game:GetService("GuiService")
local v2 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v1.Modules.Signal)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Modules.UILibrary)
local v_u_6 = v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompts")
local v_u_7 = {}
v_u_7.__index = v_u_7
function v_u_7.new(p8)
    local v9
    if typeof(p8) == "Instance" then
        v9 = p8:IsA("ImageButton")
    else
        v9 = false
    end
    local v10 = "Argument 1 invalid, expected an ImageButton, got " .. tostring(p8)
    assert(v9, v10)
    local v11 = v_u_7
    local v12 = setmetatable({}, v11)
    v12.PromptAdded = v_u_4.new()
    v12.PromptRemoved = v_u_4.new()
    v12.PromptsFrame = p8
    v12.PromptsFrameBackground = v12.PromptsFrame:WaitForChild("Background")
    v12.CurrentPrompt = nil
    v12._locked = false
    v12:_Init()
    return v12
end
function v_u_7.GetDefaultElement(p13)
    local v14 = p13.CurrentPrompt
    if v14 then
        v14 = p13.CurrentPrompt:GetDefaultElement()
    end
    return v14
end
function v_u_7.Lock(p15, p16)
    local v17 = typeof(p16) == "boolean"
    local v18 = "Argument 1 invalid, expected a boolean, got " .. tostring(p16)
    assert(v17, v18)
    p15._locked = p16
end
function v_u_7.Open(p_u_19, p20, ...)
    local v21 = not p20 or typeof(p20) == "string"
    local v22 = "Argument 1 invalid, expected a string or nil, got " .. tostring(p20)
    assert(v21, v22)
    p_u_19:Close(true)
    if p20 then
        local v23 = require(v_u_6[p20])
        local v24 = v23.GetDefaultElement
        local v25 = "You forgot to implement " .. p20 .. ":GetDefaultElement()"
        assert(v24, v25)
        local v26 = v23.CloseRequest
        local v27 = "You forgot to implement " .. p20 .. ":CloseRequest()"
        assert(v26, v27)
        local v28 = v23.Open
        local v29 = "You forgot to implement " .. p20 .. ":Open()"
        assert(v28, v29)
        local v30 = v23.Destroy
        local v31 = "You forgot to implement " .. p20 .. ":Destroy()"
        assert(v30, v31)
        p_u_19.CurrentPrompt = v23.new(...)
        p_u_19.CurrentPrompt.Closed:Connect(function()
            p_u_19:Close()
        end)
        p_u_19.CurrentPrompt.OpenPrompt:Connect(function(...)
            p_u_19:Open(...)
        end)
        p_u_19.CurrentPrompt:Open(p_u_19.PromptsFrame)
        local v_u_32 = p_u_19.CurrentPrompt
        p_u_19.PromptsFrame.Visible = true
        task.spawn(v_u_3.RenderstepForLoop, v_u_3, (1 - p_u_19.PromptsFrameBackground.BackgroundTransparency) * 100, 100, 4, function(p33)
            if p_u_19.CurrentPrompt ~= v_u_32 then
                return true
            end
            local v34 = 1 - (1 - p33 / 100) ^ 5
            p_u_19.PromptsFrameBackground.BackgroundTransparency = 1 + -0.667 * v34
        end)
        p_u_19.PromptAdded:Fire(p_u_19.CurrentPrompt)
    end
    return p_u_19.CurrentPrompt
end
function v_u_7.Close(p_u_35, p36)
    local v37 = not p36 or typeof(p36) == "boolean"
    local v38 = "Argument 1 invalid, expected a boolean or nil, got " .. tostring(p36)
    assert(v37, v38)
    local v39 = p_u_35.CurrentPrompt
    if v39 then
        p_u_35.CurrentPrompt = nil
        p_u_35:Lock(false)
        v39:Destroy()
        p_u_35.PromptRemoved:Fire(v39)
        if p36 then
            return
        end
        task.spawn(function()
            v_u_3:RenderstepForLoop(p_u_35.PromptsFrameBackground.BackgroundTransparency * 100, 100, 10, function(p40)
                if p_u_35.CurrentPrompt then
                    return true
                end
                local v41 = p40 / 100
                p_u_35.PromptsFrameBackground.BackgroundTransparency = 0.333 + 0.667 * v41
            end)
            p_u_35.PromptsFrame.Visible = p_u_35.CurrentPrompt ~= nil
        end)
    end
end
function v_u_7.Destroy(p42)
    p42:Close(true)
    p42.PromptAdded:Destroy()
    p42.PromptRemoved:Destroy()
end
function v_u_7._IsMouseWithinPromptBounds(p43)
    if p43._locked then
        return true
    end
    local v44 = p43.CurrentPrompt
    if v44 then
        v44 = p43.CurrentPrompt.PromptFrame
    end
    if v44 then
        v44 = v_u_5:IsMouseWithinBounds(v44.AbsolutePosition, v44.AbsoluteSize)
    end
    return v44
end
function v_u_7._Init(p_u_45)
    p_u_45.PromptsFrame.MouseButton1Click:Connect(function()
        if not p_u_45:_IsMouseWithinPromptBounds() then
            p_u_45:Close()
        end
    end)
end
return v_u_7