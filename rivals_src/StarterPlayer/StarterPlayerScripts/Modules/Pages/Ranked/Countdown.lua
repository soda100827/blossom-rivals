local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Controllers.SeasonController)
local v_u_3 = {}
v_u_3.__index = v_u_3
function v_u_3.new(p4)
    local v5 = v_u_3
    local v6 = setmetatable({}, v5)
    v6.Page = p4
    v6.Frame = v6.Page.Container:WaitForChild("Countdown")
    v6.Title = v6.Frame:WaitForChild("Title")
    v6._thread = nil
    v6:_Init()
    return v6
end
function v_u_3.Open(p7)
    p7:_Update()
end
function v_u_3.Close(p8)
    p8:_Cleanup()
end
function v_u_3._Cleanup(p9)
    if p9._thread then
        task.cancel(p9._thread)
        p9._thread = nil
    end
end
function v_u_3._Update(p_u_10)
    p_u_10.Frame.Visible = v_u_2:GetTimeRemaining() ~= nil
    if p_u_10.Frame.Visible then
        p_u_10:_Cleanup()
        p_u_10._thread = task.spawn(function()
            while true do
                p_u_10.Title.Text = v_u_2:GetCountdownText() .. " \226\128\148 Your final ELO determines your Ranked season rewards!"
                wait(1)
            end
        end)
    end
end
function v_u_3._Init(_) end
return v_u_3