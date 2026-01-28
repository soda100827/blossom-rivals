return function(p1, p2, ...)
    local v3 = Instance.new("Animation")
    v3.AnimationId = p2
    local v4 = p1:LoadAnimation(v3)
    v4:Play(...)
    return v4, v3
end