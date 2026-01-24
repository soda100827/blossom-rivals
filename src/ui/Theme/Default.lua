local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Header = Color3.fromRGB(30, 30, 45),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(50, 50, 60),
    
    ElementBackground = Color3.fromRGB(35, 35, 45),
    ElementHover = Color3.fromRGB(45, 45, 55)
}

function Theme:GetColor(key)
    return self[key] or Color3.new(1, 0, 1)
end

return Theme
