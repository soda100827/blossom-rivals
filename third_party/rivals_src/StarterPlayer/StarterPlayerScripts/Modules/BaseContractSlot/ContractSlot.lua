local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.StatisticsLibrary)
local v_u_4 = require(v1.Modules.ContractsLibrary)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(script.Parent)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new(p8, p9)
    local v10 = v_u_6.new()
    local v11 = v_u_7
    local v12 = setmetatable(v10, v11)
    v12._statistics_directory_name = p8
    v12._contract_name = p9
    v12._contract_info = v_u_4.Contracts[v12._contract_name]
    v12._progress = v_u_5:GetDirectoryStatistic(v12._statistics_directory_name, v12._contract_info.Identifier, v12._contract_info.StatisticName, v12._contract_info.ExtraStatisticNames)
    v12:_Init()
    return v12
end
function v_u_7._Setup(p13)
    local v14 = v_u_3.Info[p13._contract_info.StatisticName]
    local v15 = v14.FullDisplayName
    for _, v16 in pairs(p13._contract_info.ExtraStatisticNames) do
        v15 = v15 .. " + " .. v_u_3.Info[v16].FullDisplayName
    end
    p13:SetTitle(v15)
    p13:SetImage(v14.Image)
    p13:SetProgress(p13._progress)
    for _, v17 in pairs(p13._contract_info.Milestones) do
        local v18, v19 = table.unpack(v17)
        p13:AddMilestone(v18, v19, v14.TostringFunction)
    end
end
function v_u_7._Init(p20)
    p20:_Setup()
end
return v_u_7