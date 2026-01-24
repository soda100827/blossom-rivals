local Fusion = BlossomImport("src/F/Fusion.lua")
local Window = BlossomImport("src/ui/Components/Window.lua")
local Toggle = BlossomImport("src/ui/Components/Toggle.lua")

local New = Fusion.New
local Children = Fusion.Children

local UI = {}

function UI:Init(Client)
    self.Client = Client
    self.Logger = Client.Logger
    
    self.Target = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    self:CreateInterface()
end

function UI:CreateInterface()
    -- Cleanup old UI
    local old = self.Target:FindFirstChild("BlossomUI")
    if old then old:Destroy() end
    
    local App = New "ScreenGui" {
        Name = "BlossomUI",
        Parent = self.Target,
        ResetOnSpawn = false,
        
        [Children] = {
            Window {
                Title = "Blossom " .. self.Client.Version,
                
                [Children] = {
                    Toggle {
                        Title = "Movement Assist",
                        Callback = function(state)
                            if self.Client.Modules.Movement then
                                self.Client.Modules.Movement:Toggle(state)
                            end
                        end
                    },
                    
                    Toggle {
                        Title = "Visuals (ESP)",
                        Callback = function(state)
                            if self.Client.Modules.Visuals then
                                self.Client.Modules.Visuals:Toggle(state)
                            end
                        end
                    }
                }
            }
        }
    }
    
    self.ScreenGui = App
    self.Logger:Log("UI Interface Built with Fusion")
end

function UI:Cleanup()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return UI
