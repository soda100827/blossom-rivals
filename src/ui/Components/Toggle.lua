local Fusion = require(script.Parent.Parent.Vendor.Fusion)
local Theme = require(script.Parent.Parent.Theme.Default)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local State = Fusion.Value
local Spring = Fusion.Spring
local Tween = Fusion.Tween

local function Toggle(props)
    local state = props.State or State(false)
    local callback = props.Callback or function() end
    
    -- Animation state
    local indicatorPos = Spring(
        Fusion.Computed(function()
            return state:get() and 0 or 1
        end),
        25, -- speed
        0.8 -- damping
    )
    
    local indicatorColor = Fusion.Computed(function()
        return state:get() and Theme.Accent or Theme.ElementHover
    end)

    return New "TextButton" {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.ElementBackground,
        Text = "",
        AutoButtonColor = false,
        
        [OnEvent "MouseButton1Click"] = function()
            local current = state:get()
            state:set(not current)
            if callback then callback(not current) end
        end,
        
        [Children] = {
            New "UICorner" { CornerRadius = UDim.new(0, 6) },
            
            -- Title
            New "TextLabel" {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                Text = props.Title
            },
            
            -- Indicator Background (Slot)
            New "Frame" {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 20),
                BackgroundColor3 = Theme.ElementHover,
                
                [Children] = {
                    New "UICorner" { CornerRadius = UDim.new(1, 0) },
                    
                    -- Knob
                    New "Frame" {
                        AnchorPoint = Vector2.new(0, 0.5),
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = Fusion.Computed(function()
                            -- Animate between Left (0) and Right (1)
                            -- Padding exists, so we map 0->1 to specific UDim2
                            local alpha = indicatorPos:get() -- 1 is OFF (right aligned in previous logic? wait)
                            -- Let's rethink visual: Slot 40px wide. Knob 16px.
                            -- Off: Left. On: Right.
                            -- Correction: Previous logic was simpler. Let's do standard toggle.
                            -- Off (alpha 0) -> Position 2px
                            -- On (alpha 1) -> Position 22px
                            
                            -- Need to invert alpha logic from previous thought if using 0 as off
                            -- Let's trust 'state' directly
                             return UDim2.new(0, 2 + (20 * (state:get() and 1 or 0)), 0.5, 0)
                        end),
                        BackgroundColor3 = Theme.Text,
                        
                        [Children] = {
                            New "UICorner" { CornerRadius = UDim.new(1, 0) }
                        }
                    }
                }
            }
        }
    }
end

return Toggle
