local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.CONSTANTS)
local v_u_3 = {
    ["Info"] = {},
    ["Order"] = {},
    ["LookupID"] = {}
}
local v_u_4 = {}
local v_u_5 = {}
local function v14(p6, p7, p8, p9, p10, p11)
    if not (p11 and v_u_2.IS_CLIENT) then
        local v12 = {
            ["Name"] = p7,
            ["Section"] = p6,
            ["BadgeID"] = p8,
            ["Rewards"] = p9,
            ["IsHidden"] = p10
        }
        v_u_3[p6] = v_u_3[p6] or {}
        v_u_3[p6][p7] = v12
        v_u_3.Info[p7] = v12
        v_u_3.LookupID[tostring(p8)] = v12
        local v13 = v_u_3.Order
        table.insert(v13, p7)
        if v_u_2.IS_SERVER then
            if p8 == 0 then
                warn("[BADGE] Badge ID missing: " .. p6 .. p7)
            end
            if v_u_4[tostring(p8)] and p8 > 0 then
                warn("[BADGE] Duplicate badge ID: " .. p8)
            else
                v_u_4[tostring(p8)] = true
            end
            if v_u_5[p7] then
                warn("[BADGE] Duplicate badge section & name: " .. p6 .. p7)
                return
            end
            v_u_5[p7] = true
        end
    end
end
v14("Misc", "Welcome", 2904819966736756)
v14("Misc", "AlphaTesterTesting", 1651092271685623)
v14("Misc", "AlphaTester", 1330297521556384, {
    {
        ["Name"] = "Alpha Coin",
        ["Weapon"] = "IsUniversal"
    }
})
v14("SpecialChallenge", "2024WinterSpotlight1", 3550066675718)
v14("SpecialChallenge", "2024WinterSpotlight2", 3480019912304713)
v14("SpecialChallenge", "TheHuntMegaEdition1", 2472187632273965)
v14("SpecialChallenge", "TheHuntMegaEdition2", 2731731095831523)
return v_u_3