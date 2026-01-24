---@diagnostic disable: undefined-global, unknown-symbol
local UserInputService = game:GetService("UserInputService")

local Fusion = require("@pkg/fusion")
local Theme = require("src/ui/Themes")

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local State = Fusion.Value

local function Window(props)
	local position = State(UDim2.new(0.5, -250, 0.5, -175))

	local isDragging = false
	local dragStart = Vector2.new(0, 0)
	local startPos = UDim2.new(0, 0, 0, 0)

	local function InputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
			dragStart = input.Position
			startPos = position:get()
		end
	end

	UserInputService.InputChanged:Connect(function(input)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local newPos =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			position:set(newPos)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)

	return New("Frame")({
		Name = "MainWindow",
		Size = props.Size or UDim2.new(0, 500, 0, 350),
		Position = position,
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,

		[Children] = {
			New("UICorner")({ CornerRadius = UDim.new(0, 8) }),
			New("UIStroke")({ Color = Theme.Border, Thickness = 1 }),

			-- Header
			New("Frame")({
				Name = "Header",
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundColor3 = Theme.Header,

				[OnEvent("InputBegan")] = InputBegan,

				[Children] = {
					New("UICorner")({ CornerRadius = UDim.new(0, 8) }),
					New("Frame")({
						Size = UDim2.new(1, 0, 0, 10),
						Position = UDim2.new(0, 0, 1, -10),
						BackgroundColor3 = Theme.Header,
						BorderSizePixel = 0,
					}),
					New("TextLabel")({
						Size = UDim2.new(1, -20, 1, 0),
						Position = UDim2.new(0, 20, 0, 0),
						BackgroundTransparency = 1,
						Text = props.Title,
						TextColor3 = Theme.Text,
						Font = Enum.Font.GothamBold,
						TextSize = 16,
						TextXAlignment = Enum.TextXAlignment.Left,
					}),
				},
			}),

			-- Content
			New("ScrollingFrame")({
				Size = UDim2.new(1, -20, 1, -50),
				Position = UDim2.new(0, 10, 0, 45),
				BackgroundTransparency = 1,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = Theme.Accent,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				BorderSizePixel = 0,

				[Children] = {
					New("UIListLayout")({
						Padding = UDim.new(0, 5),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
					props[Children],
				},
			}),
		},
	})
end

return Window
