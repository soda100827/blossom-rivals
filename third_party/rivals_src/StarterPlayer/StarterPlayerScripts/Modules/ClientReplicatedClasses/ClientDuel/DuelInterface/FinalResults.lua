local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Signal)
local v_u_3 = require(script:WaitForChild("Buttons"))
local v_u_4 = require(script:WaitForChild("Summary"))
local v_u_5 = require(script:WaitForChild("Winners"))
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.new(p7)
    local v8 = v_u_6
    local v9 = setmetatable({}, v8)
    v9.Activated = v_u_2.new()
    v9.PageChanged = v_u_2.new()
    v9.CurrentPage = nil
    v9.DuelInterface = p7
    v9.Frame = v9.DuelInterface.Frame:WaitForChild("FinalResults")
    v9.Summary = v_u_4.new(v9)
    v9.Winners = v_u_5.new(v9)
    v9.Buttons = v_u_3.new(v9)
    v9._is_active = false
    v9:_Init()
    return v9
end
function v_u_6.IsActive(p10)
    return p10._is_active
end
function v_u_6.SetPage(p11, p12)
    p11.CurrentPage = p12
    p11.PageChanged:Fire()
    p11.Winners:SetVisible(p11.CurrentPage == "Winners")
    p11.Summary:SetVisible(p11.CurrentPage == "Summary")
end
function v_u_6.Play(p13, ...)
    p13._is_active = true
    p13.Activated:Fire()
    return p13.Winners:Play(...)
end
function v_u_6.UpdateVisibility(p14)
    local v15 = p14.Frame
    local v16 = p14:IsActive()
    if v16 then
        v16 = not p14.DuelInterface:IsPageOpen()
    end
    v15.Visible = v16
end
function v_u_6.Destroy(p17)
    p17.Activated:Destroy()
    p17.PageChanged:Destroy()
    p17.Summary:Destroy()
    p17.Winners:Destroy()
    p17.Buttons:Destroy()
end
function v_u_6._Setup(p18)
    p18.Frame.Visible = false
end
function v_u_6._Init(p_u_19)
    p_u_19.Activated:Connect(function()
        p_u_19:UpdateVisibility()
    end)
    p_u_19:_Setup()
    p_u_19:SetPage("Winners")
end
return v_u_6