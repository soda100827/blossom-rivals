local Fusion = require(script.Parent.Parent.Vendor.Fusion)
local Theme = require(script.Parent.Parent.Theme.Default)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value

local function Window(props)
    local position = Value(UDim2.new(0.5, -250, 0.5, -175))
    
    local isDragging = Value(false)
    local dragStart = Value(Vector2.new(0,0))
    local startPos = Value(UDim2.new(0,0,0,0))
    
    -- Drag Logic
    local function messageToLogic(msg)
        -- Fusion usually handles logic inside components or controllers.
        -- For dragging, we can attach Input events to the header.
    end
    
    return New "Frame" {
        Name = "MainWindow",
        Size = props.Size or UDim2.new(0, 500, 0, 350),
        Position = position, -- Bound to state
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        
        -- Simple Drag Implementation via InputChanged on Header is tricky in pure declarative style without logic wrapping
        -- For brevity, we will rely on a wrapper or just simple existing logic. 
        -- But let's try to do it "Fusion Way" lightly.
        
        [Children] = {
            New "UICorner" { CornerRadius = UDim.new(0, 8) },
            New "UIStroke" { Color = Theme.Border, Thickness = 1 },
            
            -- Header
            New "Frame" {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Header,
                
                -- Input Handling for Drag
                [OnEvent "InputBegan"] = function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging:set(true)
                        dragStart:set(input.Position)
                        startPos:set(position:get())
                    end
                end,
                
                [OnEvent "InputChanged"] = function(input)
                     if input.UserInputType == Enum.UserInputType.MouseMovement then
                         -- We need a global input changed listener effectively, 
                         -- usually you'd bind this to UserInputService or a transparent full-screen frame.
                         -- For local component containment, we often use the object itself if it captures mouse.
                     end
                end,
                -- Note: Proper drag in Fusion often needs a service connection. 
                -- We will skip the complex drag logic implementation here for brevity 
                -- or add a simple "Draggable" utility later.
                
                [Children] = {
                    New "UICorner" { CornerRadius = UDim.new(0, 8) },
                    
                    -- Square off bottom
                     New "Frame" {
                        Size = UDim2.new(1, 0, 0, 10),
                        Position = UDim2.new(0, 0, 1, -10),
                        BackgroundColor3 = Theme.Header,
                        BorderSizePixel = 0
                    },
                    
                    -- Title
                    New "TextLabel" {
                        Size = UDim2.new(1, -20, 1, 0),
                        Position = UDim2.new(0, 20, 0, 0),
                        BackgroundTransparency = 1,
                        Text = props.Title,
                        TextColor3 = Theme.Text,
                        Font = Enum.Font.GothamBold,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }
                }
            },
            
            -- Content
            New "ScrollingFrame" {
                Size = UDim2.new(1, -20, 1, -50),
                Position = UDim2.new(0, 10, 0, 45),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.Accent,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0,0,0,0),
                
                [Children] = {
                    New "UIListLayout" {
                        Padding = UDim.new(0, 5),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    },
                    props[Children] -- Injected children
                }
            }
        }
    }
end

return Window
