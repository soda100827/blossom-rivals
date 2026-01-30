local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.AnimationLibrary)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules.ViewModels.Medkit)
local v_u_6 = setmetatable({}, v_u_5)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_5.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9._play_cat_gif_hash = 0
    v9._cat_surface_gui = v9.ItemModel:WaitForChild("MedkitTop"):WaitForChild("Screen"):WaitForChild("CatGui")
    v9._cat_image_label = v9._cat_surface_gui:WaitForChild("Frame"):WaitForChild("ImageLabel"):WaitForChild("Picture"):WaitForChild("ImageLabel")
    v9._use_surface_gui = v9.ItemModel:WaitForChild("MedkitTop"):WaitForChild("Screen"):WaitForChild("UseGui")
    v9._use_bar = v9._use_surface_gui:WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Bar")
    v9._use_text = v9._use_surface_gui:WaitForChild("Frame"):WaitForChild("Progress")
    v9._use_background = v9._use_surface_gui:WaitForChild("Frame"):WaitForChild("ImageLabel")
    v9._use_effect_hash = 0
    v9._use_tween = nil
    v9:_Init()
    return v9
end
function v_u_6._CancelTween(p10)
    if p10._use_tween then
        p10._use_tween:Pause()
        p10._use_tween = nil
    end
end
function v_u_6._UpdateUseBar(p11)
    local v12 = p11._use_text
    local v13
    if p11._use_bar.AbsoluteSize.X <= 1 then
        v13 = "\226\128\162 \226\128\162 \226\128\162"
    else
        local v14 = p11._use_bar.AbsoluteSize.X / p11._use_bar.Parent.AbsoluteSize.X * 100
        v13 = math.floor(v14) .. "%"
    end
    v12.Text = v13
end
function v_u_6._UpdateUseGui(p_u_15)
    p_u_15:_CancelTween()
    p_u_15._use_effect_hash = p_u_15._use_effect_hash + 1
    local v_u_16 = p_u_15._use_effect_hash
    local v17 = p_u_15:IsAnimationPlaying("Use")
    local v18 = not v17 or p_u_15:IsAnimationPlaying("UseQuick")
    p_u_15._use_surface_gui.Enabled = v17 or v18
    if p_u_15._use_surface_gui.Enabled then
        task.spawn(function()
            while not p_u_15._destroyed and p_u_15._use_effect_hash == v_u_16 do
                p_u_15._use_background.Image = "rbxassetid://134936596399147"
                wait(0.1)
                if p_u_15._destroyed or p_u_15._use_effect_hash ~= v_u_16 then
                    return
                end
                p_u_15._use_background.Image = "rbxassetid://115756225131937"
                wait(0.1)
            end
        end)
        p_u_15._use_bar.Size = UDim2.new(0, 0, 1, 0)
        if v17 then
            wait(2)
            if not p_u_15._destroyed and p_u_15._use_effect_hash == v_u_16 then
                p_u_15._use_tween = v_u_2:Create(p_u_15._use_bar, TweenInfo.new(v_u_4.Info[p_u_15.Info.Animations.Use].ActionTimestamp - 2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    ["Size"] = UDim2.new(1, 0, 1, 0)
                })
                p_u_15._use_tween:Play()
            end
        else
            if v18 then
                wait(v_u_4.Info[p_u_15.Info.Animations.UseQuick].ActionTimestamp)
                if p_u_15._destroyed or p_u_15._use_effect_hash ~= v_u_16 then
                    return
                end
                p_u_15._use_bar.Size = UDim2.new(1, 0, 1, 0)
            end
            return
        end
    else
        return
    end
end
function v_u_6._UpdateCatGui(p19)
    p19._play_cat_gif_hash = p19._play_cat_gif_hash + 1
    local v20 = p19._play_cat_gif_hash
    p19._cat_surface_gui.Enabled = p19:IsAnimationPlaying("RareInspect")
    if p19._cat_surface_gui.Enabled then
        local v21 = 1
        while not p19._destroyed and (p19:IsAnimationPlaying("RareInspect") and p19._play_cat_gif_hash == v20) do
            local v22 = (v21 - 1) % (Vector3.new(4, 4, -2)).X
            local v23 = (v21 - 1) / (Vector3.new(4, 4, -2)).Y
            local v24 = math.floor(v23)
            p19._cat_image_label.Position = UDim2.new(v22 * -1, 0, v24 * -1, 0)
            v21 = v21 % ((Vector3.new(4, 4, -2)).X * (Vector3.new(4, 4, -2)).Y + (Vector3.new(4, 4, -2)).Z) + 1
            wait(0.1)
        end
    end
end
function v_u_6._Setup(p25)
    p25._cat_image_label.Image = "rbxassetid://120426879154579"
    p25._cat_image_label.Size = UDim2.new(p25._cat_image_label.Size.X.Scale * (Vector3.new(4, 4, -2)).X, p25._cat_image_label.Size.X.Offset * (Vector3.new(4, 4, -2)).X, p25._cat_image_label.Size.Y.Scale * (Vector3.new(4, 4, -2)).Y, p25._cat_image_label.Size.Y.Offset * (Vector3.new(4, 4, -2)).Y)
end
function v_u_6._Init(p_u_26)
    p_u_26.AnimationPlayed:Connect(function(p27)
        if p27 == "RareInspect" then
            p_u_26:_UpdateCatGui()
        elseif p27 == "Use" or p27 == "UseQuick" then
            p_u_26:_UpdateUseGui()
        end
    end)
    p_u_26.AnimationStopped:Connect(function(p28)
        if p28 == "RareInspect" then
            p_u_26:_UpdateCatGui()
        elseif p28 == "Use" or p28 == "UseQuick" then
            p_u_26:_UpdateUseGui()
        end
    end)
    p_u_26.Equipped:Connect(function()
        p_u_26:_CancelTween()
    end)
    p_u_26._use_bar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        p_u_26:_UpdateUseBar()
    end)
    p_u_26:_Setup()
end
return v_u_6