---@diagnostic disable: undefined-global, unknown-symbol
local Fusion = require("@pkg/fusion")
local Theme = require("src/ui/Themes")

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local State = Fusion.Value
local Spring = Fusion.Spring
local Computed = Fusion.Computed

local function Toggle(props)
	local state = props.State or State(false)
	local callback = props.Callback or function() end

	local anim = Spring(
		Computed(function()
			return state:get() and 1 or 0
		end),
		25,
		0.8
	)

	return New("TextButton")({
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = Theme.ElementBackground,
		Text = "",
		AutoButtonColor = false,

		[OnEvent("MouseButton1Click")] = function()
			local newState = not state:get()
			state:set(newState)
			task.spawn(callback, newState)
		end,

		[Children] = {
			New("UICorner")({ CornerRadius = UDim.new(0, 6) }),

			New("TextLabel")({
				Size = UDim2.new(1, -50, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.GothamMedium,
				TextSize = 14,
				Text = props.Title,
			}),

			New("Frame")({
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 40, 0, 20),
				BackgroundColor3 = Computed(function()
					return state:get() and Theme.Accent or Theme.ElementHover
				end),

				[Children] = {
					New("UICorner")({ CornerRadius = UDim.new(1, 0) }),

					New("Frame")({
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.new(0, 16, 0, 16),
						Position = Computed(function()
							local alpha = anim:get()
							return UDim2.new(0, 2 + (20 * alpha), 0.5, 0)
						end),
						BackgroundColor3 = Theme.Text,

						[Children] = {
							New("UICorner")({ CornerRadius = UDim.new(1, 0) }),
						},
					}),
				},
			}),
		},
	})
end

return Toggle
