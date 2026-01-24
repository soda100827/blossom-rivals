local Visuals = {
    Enabled = false,
    Drawings = {}
}

function Visuals:Init(Client)
    self.Client = Client
    self.Logger = Client.Logger
    self.Logger:Log("Visuals module initialized")
end

function Visuals:Toggle(state)
    self.Enabled = state
    if state then
        self:UpdateVisuals()
    else
        self:ClearVisuals()
    end
end

function Visuals:UpdateVisuals()
    -- ESP 등의 렌더링 루프 시작
    -- RunService.RenderStepped 이벤트에 연결하여 매 프레임 그리기
    self.Logger:Log("Visuals loop started")
end

function Visuals:ClearVisuals()
    -- 드로잉 객체 제거
    for _, drawing in pairs(self.Drawings) do
        if drawing.Remove then drawing:Remove() end
    end
    self.Drawings = {}
end

function Visuals:Cleanup()
    self:ClearVisuals()
end

return Visuals
