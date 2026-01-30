local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("HttpService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.DebugLibrary)
local v_u_6 = require(v1.Modules.Utility)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController"))
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_10 = require(v_u_3.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local v_u_11 = v_u_3.LocalPlayer.PlayerScripts.UserInterface.WinHistorySlot
local v_u_12 = v_u_3.LocalPlayer.PlayerScripts.UserInterface.RawDataText
local v_u_13 = setmetatable({}, v_u_10)
v_u_13.__index = v_u_13
function v_u_13.new(p14, p15)
    local v16 = typeof(p14) == "string"
    local v17 = "Argument 1 invalid, expected a string, got " .. tostring(p14)
    assert(v16, v17)
    local v18 = typeof(p15) == "table"
    local v19 = "Argument 2 invalid, expected a table, got " .. tostring(p15)
    assert(v18, v19)
    local v20 = v_u_10.new(script.Name)
    local v21 = v_u_13
    local v22 = setmetatable(v20, v21)
    v22.CloseButton = v22.PromptFrame:WaitForChild("Close")
    v22.UsernameText = v22.PromptFrame:WaitForChild("Username")
    v22.TabsFrame = v22.PromptFrame:WaitForChild("Tabs")
    v22.RawDataButton = v22.TabsFrame:WaitForChild("RawData")
    v22.HaveWonAgainstButton = v22.TabsFrame:WaitForChild("HaveWonAgainst")
    v22.HaveWonWithButton = v22.TabsFrame:WaitForChild("HaveWonWith")
    v22.PagesFrame = v22.PromptFrame:WaitForChild("Pages")
    v22.RawDataFrame = v22.PagesFrame:WaitForChild("RawData")
    v22.RawDataSearchFrame = v22.RawDataFrame:WaitForChild("Search")
    v22.RawDataSearchBox = v22.RawDataSearchFrame:WaitForChild("Box")
    v22.RawDataLoadButton = v22.RawDataFrame:WaitForChild("Load")
    v22.RawDataList = v22.RawDataFrame:WaitForChild("List")
    v22.RawDataContainer = v22.RawDataList:WaitForChild("Container")
    v22.RawDataLayout = v22.RawDataContainer:WaitForChild("Layout")
    v22.HaveWonAgainstFrame = v22.PagesFrame:WaitForChild("HaveWonAgainst")
    v22.HaveWonAgainstList = v22.HaveWonAgainstFrame:WaitForChild("List")
    v22.HaveWonAgainstContainer = v22.HaveWonAgainstList:WaitForChild("Container")
    v22.HaveWonAgainstLayout = v22.HaveWonAgainstContainer:WaitForChild("Layout")
    v22.HaveWonAgainstEmptyText = v22.HaveWonAgainstContainer:WaitForChild("Empty")
    v22.HaveWonWithFrame = v22.PagesFrame:WaitForChild("HaveWonWith")
    v22.HaveWonWithList = v22.HaveWonWithFrame:WaitForChild("List")
    v22.HaveWonWithContainer = v22.HaveWonWithList:WaitForChild("Container")
    v22.HaveWonWithLayout = v22.HaveWonWithContainer:WaitForChild("Layout")
    v22.HaveWonWithEmptyText = v22.HaveWonWithContainer:WaitForChild("Empty")
    v22._name = p14
    v22._data = p15
    v22._raw_data_texts = {}
    v22:_Init()
    return v22
end
function v_u_13.SetPage(p23, p24)
    for _, v25 in pairs(p23.PagesFrame:GetChildren()) do
        v25.Visible = v25.Name == p24
    end
end
function v_u_13._UpdateRawDataSearch(p_u_26)
    local v27 = string.lower(p_u_26.RawDataSearchBox.Text)
    local v28 = {}
    for v29 in pairs(p_u_26._raw_data_texts) do
        v29.Visible = false
        v28[v29] = string.find(string.lower(v29.Text), v27) or nil
    end
    local function v_u_33(p30)
        for v31, v32 in pairs(p_u_26._raw_data_texts) do
            if v32 == p30 then
                v31.Visible = true
                v_u_33(v31)
            end
        end
    end
    for v35 in pairs(v28) do
        v35.Visible = true
        v_u_33(v35)
        while p_u_26._raw_data_texts[v35] ~= true do
            local v35 = p_u_26._raw_data_texts[v35]
            v35.Visible = true
        end
    end
end
function v_u_13._GenerateWinHistory(p_u_36)
    for _, v_u_37 in pairs({ "HaveWonAgainst", "HaveWonWith" }) do
        local v38 = p_u_36[v_u_37 .. "EmptyText"]
        local v39 = p_u_36[v_u_37 .. "Container"]
        local v40 = p_u_36[v_u_37 .. "Button"]
        local v_u_41 = p_u_36[v_u_37 .. "Layout"]
        local v_u_42 = p_u_36[v_u_37 .. "List"]
        v40.MouseButton1Click:Connect(function()
            p_u_36:SetPage(v_u_37)
        end)
        v_u_41:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            v_u_42.CanvasSize = UDim2.new(0, 0, 0, v_u_41.AbsoluteContentSize.Y)
        end)
        v_u_9:Add(v40)
        v38.Visible = true
        v38.Text = "Loading..."
        local v43 = p_u_36._data[v_u_37] or {}
        local v44 = {}
        for _, v45 in pairs(v43) do
            local v46 = v45[1]
            table.insert(v44, v46)
        end
        local v47 = v_u_8:GetUserInfos(v44)
        local v48 = true
        for v49, v50 in pairs(v43) do
            local v51, v52 = table.unpack(v50)
            local v53 = v47[tostring(v51)]
            local v54 = not v53 or v_u_8:UseDisplayNames() and v53.DisplayName or (v53.Username or "[Failed to load user info]")
            local v55 = "#" .. tostring(v51)
            local v56
            if v53 and (v53.Username and (v_u_8:UsernamesAllowed() and v53.Username ~= v54)) then
                local v57 = v53.Username
                v56 = " @" .. tostring(v57) or ""
            else
                v56 = ""
            end
            local v58 = v55 .. v56
            local v59 = v_u_11:Clone()
            v59.Picture.Image = string.format(v_u_4.HEADSHOT_IMAGE, v51)
            v59.DisplayName.Text = v54
            v59.DisplayName.Position = v58 == "" and UDim2.new(0.15, 0, 0.5, 0) or UDim2.new(0.15, 0, 0.4, 0)
            v59.Username.Text = v58
            v59.Username.Visible = v58 ~= ""
            v59.Quantity.Text = v_u_6:PrettyNumber(v52)
            local v60 = v59.QuantityLabel
            local v61
            if v_u_37 == "HaveWonWith" then
                v61 = v52 == 1 and "win with them" or "wins with them"
            else
                v61 = v52 == 1 and "win against them" or "wins against them"
            end
            v60.Text = v61
            v59.LayoutOrder = v49
            v59.Parent = v39
            v48 = false
        end
        v38.Text = "Empty"
        v38.Visible = v48
    end
end
function v_u_13._GenerateRawData(p_u_62)
    p_u_62.RawDataLoadButton.Visible = false
    p_u_62.RawDataSearchFrame.Visible = true
    local v63 = v_u_5:HasTotalAccess(v_u_3.LocalPlayer.UserId, v_u_7:Get("GroupRank"))
    local v64 = #v_u_2:JSONEncode(p_u_62._data)
    local v65 = p_u_62._data.RedFlags
    if v65 then
        v65 = p_u_62._data.RedFlags[#p_u_62._data.RedFlags]
    end
    if v65 then
        local v66 = v65.Reason
        local v67 = "-- red flag:    " .. tostring(v66)
        local v68 = v_u_12:Clone()
        v68.Text = v67
        v68.LayoutOrder = -998
        v68.Parent = p_u_62.RawDataContainer
    end
    local v69 = pairs
    local v70 = p_u_62._data.Receipts
    local v71 = 0
    for _, v72 in v69(typeof(v70) == "table" and (p_u_62._data.Receipts or {}) or {}) do
        v71 = v71 + (v72.CurrencySpent or 0)
    end
    p_u_62._data.Receipts = v63 and (p_u_62._data.Receipts or "Hidden for privacy reasons") or "Hidden for privacy reasons"
    local v73 = v_u_6:PrettyNumber(v64)
    local v74 = v64 / 4000000 * 1000
    local v75 = "-- data size:    " .. v73 .. "    (" .. math.floor(v74) / 10 .. "%)"
    local v76 = v_u_12:Clone()
    v76.Text = v75
    v76.LayoutOrder = -999
    v76.Parent = p_u_62.RawDataContainer
    local v77
    if v71 > 10000 and not v63 then
        v77 = "-- robux spent:    >10,000 " .. utf8.char(57346)
    else
        v77 = "-- robux spent:    " .. v_u_6:PrettyNumber(v71) .. utf8.char(57346)
    end
    local v78 = v_u_12:Clone()
    v78.Text = v77
    v78.LayoutOrder = -997
    v78.Parent = p_u_62.RawDataContainer
    local v79 = v_u_12:Clone()
    v79.Text = ""
    v79.LayoutOrder = -1
    v79.Parent = p_u_62.RawDataContainer
    local v_u_80 = 0
    local function v_u_87(p81, p82, p83, p84)
        local v85 = string.format(typeof(p82) == "string" and "\"%s\"" or "%s", (tostring(p82)))
        local v86 = v_u_12:Clone()
        v86.Text = string.format("%s[\"%s\"] = %s", p83, p81, v85) .. ";"
        v86.LayoutOrder = v_u_80
        v86.Parent = p_u_62.RawDataContainer
        p_u_62._raw_data_texts[v86] = p84 or true
        v_u_80 = v_u_80 + 1
    end
    local function v_u_100(p88, p89, p90, p91)
        local v92 = string.rep(" ", 8 * (p89 - 1))
        local v93 = string.rep(" ", 8 * p89)
        local v94
        if p90 then
            v94 = v_u_12:Clone()
            v94.Text = string.format("%s[\"%s\"] = %s", v92, p90, "{")
            v94.LayoutOrder = v_u_80
            v94.Parent = p_u_62.RawDataContainer
            p_u_62._raw_data_texts[v94] = p91 or true
            v_u_80 = v_u_80 + 1
        else
            v94 = nil
        end
        local v95 = true
        for v96, v97 in pairs(p88) do
            v95 = false
            if typeof(v97) == "table" then
                v_u_100(v97, p89 + 1, v96, v94)
            else
                v_u_87(v96, v97, v93, v94)
            end
        end
        if v95 then
            local v98 = v_u_12:Clone()
            v98.Text = v93 .. "-- empty"
            v98.LayoutOrder = v_u_80
            v98.Parent = p_u_62.RawDataContainer
            p_u_62._raw_data_texts[v98] = p91 or true
            v_u_80 = v_u_80 + 1
        end
        if p90 then
            local v99 = v_u_12:Clone()
            v99.Text = v92 .. "};"
            v99.LayoutOrder = v_u_80
            v99.Parent = p_u_62.RawDataContainer
            p_u_62._raw_data_texts[v99] = p91 or true
            v_u_80 = v_u_80 + 1
        end
    end
    local v101 = {}
    for v102 in pairs(p_u_62._data) do
        table.insert(v101, v102)
    end
    table.sort(v101, function(p103, p104)
        return v_u_6:StringLessThan(p103, p104)
    end)
    for _, v105 in pairs(v101) do
        local v106 = p_u_62._data[v105]
        if typeof(v106) == "table" then
            v_u_100(v106, 1, v105)
        else
            v_u_87(v105, v106, "")
        end
    end
    p_u_62.RawDataList.Visible = true
end
function v_u_13._Setup(p107)
    p107.UsernameText.Text = "@" .. p107._name
end
function v_u_13._Init(p_u_108)
    p_u_108.CloseButton.MouseButton1Click:Connect(function()
        p_u_108:CloseRequest()
    end)
    p_u_108.RawDataLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p_u_108.RawDataList.CanvasSize = UDim2.new(0, 0, 0, p_u_108.RawDataLayout.AbsoluteContentSize.Y)
    end)
    p_u_108.RawDataButton.MouseButton1Click:Connect(function()
        p_u_108:SetPage("RawData")
    end)
    p_u_108.RawDataLoadButton.MouseButton1Click:Connect(function()
        p_u_108:_GenerateRawData()
    end)
    p_u_108.RawDataSearchBox.FocusLost:Connect(function()
        p_u_108:_UpdateRawDataSearch()
    end)
    p_u_108:_Setup()
    task.spawn(p_u_108._GenerateWinHistory, p_u_108)
    p_u_108:SetPage("RawData")
    v_u_9:Add(p_u_108.CloseButton)
    v_u_9:Add(p_u_108.RawDataButton)
    v_u_9:Add(p_u_108.RawDataLoadButton)
end
return v_u_13