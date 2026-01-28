local v1 = game:GetService("Players")
local v_u_2 = require(script:WaitForChild("DailyShop"))
local v_u_3 = require(script:WaitForChild("Currency"))
local v_u_4 = require(script:WaitForChild("Bundles"))
local v_u_5 = require(script:WaitForChild("Ranked"))
local v_u_6 = require(script:WaitForChild("Home"))
local v_u_7 = v1.LocalPlayer.PlayerScripts.Assets:WaitForChild("Temp"):WaitForChild("ShopPages")
local v_u_8 = {}
v_u_8.__index = v_u_8
function v_u_8.new(p9)
    local v10 = v_u_8
    local v11 = setmetatable({}, v10)
    v11.Shop = p9
    v11.Frame = v11.Shop.Container:WaitForChild("Pages")
    v11.DailyShop = v_u_2.new(v11)
    v11.Currency = v_u_3.new(v11)
    v11.Bundles = v_u_4.new(v11)
    v11.Ranked = v_u_5.new(v11)
    v11.Home = v_u_6.new(v11)
    v11._page_frames = {}
    v11:_Init()
    return v11
end
function v_u_8.Open(p12)
    p12.Home:Open()
    p12.Ranked:Open()
    p12.Bundles:Open()
    p12.Currency:Open()
    p12.DailyShop:Open()
end
function v_u_8.Close(p13)
    p13.Home:Close()
    p13.Ranked:Close()
    p13.Bundles:Close()
    p13.Currency:Close()
    p13.DailyShop:Close()
end
function v_u_8.Setup(p14)
    p14.Home:Setup()
    p14.Ranked:Setup()
    p14.Bundles:Setup()
    p14.Currency:Setup()
    p14.DailyShop:Setup()
    p14:_Update()
end
function v_u_8._Update(p15)
    for v16, v17 in pairs(p15._page_frames) do
        local v18 = v16 == p15.Shop.CurrentPage
        v17.Parent = v18 and p15.Frame or v_u_7
        v17.Visible = v18
    end
end
function v_u_8._Setup(p19)
    for _, v20 in pairs(p19.Shop.PAGE_NAMES) do
        local v21 = p19.Frame:WaitForChild(v20)
        v21.Visible = false
        v21.Parent = v_u_7
        p19._page_frames[v20] = v21
    end
end
function v_u_8._Init(p_u_22)
    p_u_22.Shop.CurrentPageChanged:Connect(function()
        p_u_22:_Update()
    end)
    p_u_22:_Setup()
end
return v_u_8