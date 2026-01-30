local v_u_1 = game:GetService("TestService")
local v_u_2 = game:GetService("RunService")
return {
    ["GetTestAttribute"] = function(_, p3)
        if v_u_2:IsStudio() then
            while true do
                local v4 = v_u_1:GetAttribute(p3)
                if v4 ~= nil then
                    break
                end
                warn("TestService attribute not found, waiting for", p3)
                wait(1)
            end
            if v4 == "" then
                return nil
            else
                return v4
            end
        else
            return nil
        end
    end
}