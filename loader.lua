local Blossom = {
    Version = "1.0.0",
    Loaded = false
}

-- 환경 감지 및 기본 설정
local function getEnvironment()
    if identifyexecutor then
        return identifyexecutor()
    end
    return "Unknown"
end

function Blossom:Boot()
    if self.Loaded then
        warn("[Blossom] Already loaded!")
        return
    end
    
    print(string.format("[Blossom] Loader initialized. Environment: %s", getEnvironment()))
    
    -- 실제 로직은 src/init.lua에서 처리
    -- 개발 환경에서는 로컬 파일을 require 모듈로 불러오는 것을 가정합니다.
    -- 실제 배포시에는 loadstring + game:HttpGet 등을 사용합니다.
    
    local success, result = pcall(function()
        return require(script.Parent.src.init)
    end)
    
    if not success then
        warn("[Blossom] Failed to load core:", result)
    end
end

return Blossom:Boot()
