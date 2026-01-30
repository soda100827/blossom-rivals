local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("GamepadService")
local v_u_3 = game:GetService("Lighting")
local v_u_4 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_8 = v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("Pages")
local v_u_9 = Color3.fromRGB(255, 255, 255)
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10.new(p11)
    local v12 = typeof(p11) == "Instance"
    local v13 = "Argument 1 invalid, expected an Instance, got " .. tostring(p11)
    assert(v12, v13)
    local v14 = v_u_10
    local v15 = setmetatable({}, v14)
    v15.CurrentPage = nil
    v15.PageAdded = v_u_6.new()
    v15.PageOpened = v_u_6.new()
    v15.PageClosed = v_u_6.new()
    v15.PagesActivity = v_u_6.new()
    v15._pages = {}
    v15._container = p11
    v15._blur = Instance.new("BlurEffect")
    v15._colorcorrection = Instance.new("ColorCorrectionEffect")
    v15._tween_hash = 0
    v15:_Init()
    return v15
end
function v_u_10.GetDefaultElement(p16)
    local v17 = p16.CurrentPage
    if v17 then
        v17 = p16.CurrentPage:GetDefaultElement()
    end
    return v17
end
function v_u_10.CloseRequest(p18)
    if p18.CurrentPage then
        p18.CurrentPage:CloseRequest()
    end
end
function v_u_10.GetPage(p19, p20)
    local v21 = typeof(p20) == "string"
    local v22 = "Argument 1 invalid, expected a string, got " .. tostring(p20)
    assert(v21, v22)
    for v23, v24 in pairs(p19._pages) do
        if v24.Name == p20 then
            return v24, v23
        end
    end
end
function v_u_10.OpenPage(p25, p26, p27)
    local v28 = typeof(p26) == "string"
    local v29 = "Argument 1 invalid, expected a string, got " .. tostring(p26)
    assert(v28, v29)
    local v30 = not p27 or typeof(p27) == "boolean"
    local v31 = "Argument 2 invalid, expected a boolean or nil, got " .. tostring(p27)
    assert(v30, v31)
    local v32 = p25:GetPage(p26)
    if not v32 then
        p25:CreatePage(p26)
        v32 = p25:WaitForPage(p26)
    end
    local v33 = v32 ~= nil
    local v34 = "Argument 1 invalid, expected a valid page name, got " .. tostring(p26)
    assert(v33, v34)
    if v32 == p25.CurrentPage then
        if not p27 then
            p25:CloseCurrentPage()
        end
    else
        if p27 ~= false then
            p25:CloseCurrentPage()
            p25:_TweenLightingEffects(true, v32)
            p25:_OpenPage(v32)
        end
        return
    end
end
function v_u_10.CloseCurrentPage(p35)
    local v36 = p35.CurrentPage
    if v36 then
        p35:_TweenLightingEffects(false, v36)
        v36:Close()
        p35.CurrentPage = nil
        p35.PageClosed:Fire(v36)
    end
end
function v_u_10.WaitForPage(p37, p38)
    local v39 = typeof(p38) == "string"
    local v40 = "Argument 1 invalid, expected a string, got " .. tostring(p38)
    assert(v39, v40)
    local v41 = p37:GetPage(p38)
    while not v41 or v41.Name ~= p38 do
        v41 = p37.PageAdded:Wait()
    end
    return v41
end
function v_u_10.CreatePage(p_u_42, p43)
    local v44 = typeof(p43) == "string"
    local v45 = "Argument 1 invalid, expected a string, got " .. tostring(p43)
    assert(v44, v45)
    local v_u_46 = require(v_u_8:WaitForChild(p43))
    local v47 = v_u_46.GetDefaultElement
    local v48 = "You forgot to implement " .. p43 .. ":GetDefaultElement()"
    assert(v47, v48)
    local v49 = v_u_46.CloseRequest
    local v50 = "You forgot to implement " .. p43 .. ":CloseRequest()"
    assert(v49, v50)
    v_u_46.Closed:Connect(function()
        p_u_42:OpenPage(v_u_46.Name, false)
    end)
    v_u_46.OpenPage:Connect(function(...)
        if v_u_46:IsOpen() then
            p_u_42:OpenPage(...)
        end
    end)
    v_u_46:Close()
    local v51 = p_u_42._pages
    table.insert(v51, v_u_46)
    p_u_42.PageAdded:Fire(v_u_46)
end
function v_u_10._TweenLightingEffects(p_u_52, p53, p54)
    p_u_52._tween_hash = p_u_52._tween_hash + 1
    local v_u_55 = p_u_52._tween_hash
    local v56 = p54:GetLightingTintColor()
    local v57 = p54:GetLightingBrightness()
    local v58 = p54:GetLightingContrast()
    local v59 = p54:GetLightingBlur()
    local v_u_60 = p_u_52._colorcorrection.TintColor
    local v_u_61 = p_u_52._colorcorrection.Contrast
    local v_u_62 = p_u_52._colorcorrection.Brightness
    local v_u_63 = p_u_52._blur.Size
    local v_u_64 = p53 and v56 and v56 or v_u_9
    local v_u_65 = p53 and v57 and v57 or 0
    local v_u_66 = p53 and v58 and v58 or 0
    local v_u_67 = p53 and v59 and v59 or 0
    task.spawn(v_u_5.RenderstepForLoop, v_u_5, 0, 100, 2, function(p68)
        if v_u_55 ~= p_u_52._tween_hash then
            return true
        end
        local v69 = 1 - (1 - p68 / 100) ^ 5
        p_u_52._blur.Size = v_u_63 + (v_u_67 - v_u_63) * v69
        p_u_52._colorcorrection.Brightness = v_u_62 + (v_u_65 - v_u_62) * v69
        p_u_52._colorcorrection.Contrast = v_u_61 + (v_u_66 - v_u_61) * v69
        p_u_52._colorcorrection.TintColor = v_u_60:Lerp(v_u_64, v69)
    end)
end
function v_u_10._OpenPage(p70, p71)
    p70.CurrentPage = p71
    p70.CurrentPage:Open(p70._container)
    p70.PageOpened:Fire(p70.CurrentPage)
    if v_u_7.CurrentControls == "Gamepad" then
        local v72 = p70.CurrentPage:GetDefaultElement()
        if not (v72 and v72:IsDescendantOf(v_u_4.LocalPlayer.PlayerGui)) then
            return
        end
        v_u_2:EnableGamepadCursor(v72)
    end
end
function v_u_10._Setup(p73)
    p73._blur.Size = 0
    p73._blur.Name = "PageSystem"
    p73._blur.Parent = v_u_3
    p73._colorcorrection.Name = "PageSystem"
    p73._colorcorrection.Parent = v_u_3
end
function v_u_10._Init(p_u_74)
    p_u_74.PageOpened:Connect(function()
        p_u_74.PagesActivity:Fire()
    end)
    p_u_74.PageClosed:Connect(function()
        p_u_74.PagesActivity:Fire()
    end)
    p_u_74:_Setup()
end
return v_u_10