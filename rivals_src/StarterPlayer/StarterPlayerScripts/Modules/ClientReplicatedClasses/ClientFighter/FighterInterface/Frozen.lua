local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2)
    local v3 = v_u_1
    local v4 = setmetatable({}, v3)
    v4.FighterInterface = p2
    v4.Vignette = v4.FighterInterface.Frame:WaitForChild("FrozenVignette")
    v4.VignetteTexture = v4.Vignette:WaitForChild("Texture")
    v4:_Init()
    return v4
end
function v_u_1.Refresh(p5)
    local v6 = p5.FighterInterface.ClientFighter and (p5.FighterInterface.ClientFighter.Entity and p5.FighterInterface.ClientFighter.Entity:Get("IsFrozen"))
    if v6 then
        v6 = p5.FighterInterface.ClientFighter:IsAlive()
    end
    p5.Vignette.ImageTransparency = v6 and 0 or 1
    p5.VignetteTexture.ImageTransparency = p5.Vignette.ImageTransparency
end
function v_u_1.Destroy(_) end
function v_u_1._Init(_) end
return v_u_1