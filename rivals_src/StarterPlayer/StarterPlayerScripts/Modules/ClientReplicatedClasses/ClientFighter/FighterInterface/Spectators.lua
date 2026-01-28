local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2)
    local v3 = v_u_1
    local v4 = setmetatable({}, v3)
    v4.FighterInterface = p2
    v4.Frame = v4.FighterInterface.Frame:WaitForChild("Health"):WaitForChild("Spectators")
    v4.Title = v4.Frame:WaitForChild("Value")
    v4:_Init()
    return v4
end
function v_u_1.Refresh(p5)
    local v6 = p5.FighterInterface.ClientFighter:Get("NumSpectators")
    p5.Frame.Visible = v6 > 0
    p5.Title.Text = v6
end
function v_u_1.Destroy(_) end
function v_u_1._Init(_) end
return v_u_1