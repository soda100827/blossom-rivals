local v_u_1 = {}
v_u_1.__index = v_u_1
function v_u_1.new(p2)
    local v3 = v_u_1
    local v4 = setmetatable({}, v3)
    v4.Pages = p2
    v4.Frame = v4.Pages.Frame:WaitForChild("Bundles")
    v4.Container = v4.Frame:WaitForChild("Container")
    v4:_Init()
    return v4
end
function v_u_1.Open(_) end
function v_u_1.Close(_) end
function v_u_1.Setup(p5)
    for _, v6 in pairs(p5.Pages.Shop.BUNDLE_NAMES) do
        p5.Pages.Shop:CreateBundleSlot(p5.Container:WaitForChild(v6), v6)
    end
end
function v_u_1._Init(_) end
return v_u_1