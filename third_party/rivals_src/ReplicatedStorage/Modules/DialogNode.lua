local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new()
    local v2 = v_u_1
    local v3 = setmetatable({}, v2)
    v3.Message = nil
    v3.ButtonAppearDelay = nil
    v3.Buttons = {}
    v3.DelayedContinue = nil
    v3:_Init()
    return v3
end
function v_u_1.SetMessage(p4, p5, p6, p7)
    p4.Message = {
        ["Picture"] = p5,
        ["Text"] = p6,
        ["SoundID"] = p7
    }
end
function v_u_1.SetButtonAppearDelay(p8, p9)
    p8.ButtonAppearDelay = p9
end
function v_u_1.ContinueAfterDelay(p10, p11, p12)
    p10.DelayedContinue = {
        ["Delay"] = p11,
        ["NextDialog"] = p12
    }
end
function v_u_1.AddButton(p13, p14, p15, p16)
    local v17 = p13.Buttons
    local v18 = {
        ["Text"] = p14,
        ["NextDialog"] = p15
    }
    local v19
    if p15 then
        v19 = nil
    else
        v19 = not p16 or nil
    end
    v18.IsCloseButton = v19
    v18.DialogActionKey = p16
    table.insert(v17, v18)
end
function v_u_1.AddCloseButton(p20, p21)
    p20:AddButton(p21 or "Goodbye", nil)
end
function v_u_1.IsDialogActionAvailable(p22, p_u_23)
    if not p_u_23 then
        return false
    end
    local function v_u_27(p24)
        for _, v25 in pairs(p24.Buttons or {}) do
            if v25.DialogActionKey == p_u_23 then
                return true
            end
            if v25.NextDialog and v_u_27(v25.NextDialog) then
                return true
            end
        end
        local v26 = p24.DelayedContinue and p24.DelayedContinue.NextDialog
        if v26 then
            v26 = v_u_27(p24.DelayedContinue.NextDialog)
        end
        return v26
    end
    return v_u_27(p22)
end
function v_u_1._Init(_) end
return v_u_1