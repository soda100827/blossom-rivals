local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1.Modules.EventLibrary)
local v_u_3 = {
    ["Info"] = {},
    ["Order"] = {}
}
local function v18(p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)
    local v16 = {
        ["IsHidden"] = p4,
        ["OrderIndex"] = #v_u_3.Order + 1,
        ["DataName"] = p5,
        ["CanBePurchasedWithRobux"] = p6,
        ["OnlyDisplayAboveZeroBalance"] = p7,
        ["OnlyDisplayBuyButtonAboveZeroBalance"] = p8,
        ["DisplayName"] = p9,
        ["DisplayNamePlural"] = p10,
        ["Image"] = p11,
        ["ImageFlat"] = p12,
        ["ImageFlatOutline"] = p13,
        ["Color"] = p14 or Color3.fromRGB(255, 255, 255),
        ["ColorGradient"] = p15 or ColorSequence.new(Color3.fromRGB(255, 255, 255))
    }
    v_u_3.Info[p5] = v16
    local v17 = v_u_3.Order
    table.insert(v17, p5)
end
v18(false, "WeaponKeys", true, false, false, "Key", "Keys", "rbxassetid://17860673529", "rbxassetid://17495953455", "rbxassetid://17495953350", Color3.fromRGB(255, 255, 255), ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.464, Color3.fromRGB(251, 243, 4)), ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 192, 21)) }))
v18(false, "UnlockTokens", false, true, false, "Unlock Token", "Unlock Tokens", "rbxassetid://140345278696055", "rbxassetid://17495953455", "rbxassetid://17495953350", Color3.fromRGB(255, 255, 255))
v18(false, "EventCurrency", true, false, false, v2.EVENT_DETAILS.CURRENCY_NAME, v2.EVENT_DETAILS.CURRENCY_NAME_PLURAL, v2.EVENT_DETAILS.CURRENCY_IMAGE, v2.EVENT_DETAILS.CURRENCY_IMAGE_FLAT, v2.EVENT_DETAILS.CURRENCY_IMAGE_FLAT_OUTLINE, v2.EVENT_DETAILS.CURRENCY_COLOR, v2.EVENT_DETAILS.CURRENCY_COLOR_GRADIENT)
v18(false, "Glory", false, false, false, "Glory", "Glory", "rbxassetid://91728915485540", "rbxassetid://99547957275402", "rbxassetid://126219583943163", Color3.fromRGB(204, 92, 255))
v18(false, "SkinTickets", false, true, true, "Skin Ticket", "Skin Tickets", "rbxassetid://84112365209074", "rbxassetid://77049671345769", "rbxassetid://76853894340797", Color3.fromRGB(255, 255, 255), ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.464, Color3.fromRGB(251, 243, 4)), ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 192, 21)) }))
return v_u_3