--!strict

--// Services

--// Dependencies (require)

--// Constants
local ESP_RENDER_INTERVAL = 1 / 60
local ESP_SKELETON_INTERVAL = 1 / 60

local ESP_TEXT_INTERVAL = 1 / 60
local ESP_SMOOTH_ALPHA = 0.25

--// Types

--// Private state
local Constants = {
	DEFAULT_SETTINGS = {
		isEspEnabled = false,
		shouldShowNames = true,
		shouldShowWeapon = false,
		shouldShowDistance = false,
		shouldShowBoxes = true,
		shouldShowSkeleton = false,
		shouldShowHealthbar = false,
		shouldShowHighlight = false,
		shouldShowTeammates = true,
		boxColor = Color3.new(1, 1, 1),
		textColor = Color3.new(1, 1, 1),
		weaponColor = Color3.new(1, 1, 1),
		distanceColor = Color3.new(1, 1, 1),
		skeletonColor = Color3.new(1, 1, 1),
		healthbarColor = Color3.new(0, 1, 0),
		healthbarOutlineColor = Color3.new(0, 0, 0),
		nameOutlineColor = Color3.new(0, 0, 0),
		weaponOutlineColor = Color3.new(0, 0, 0),
		distanceOutlineColor = Color3.new(0, 0, 0),
		boxOutlineColor = Color3.new(0, 0, 0),
		skeletonOutlineColor = Color3.new(0, 0, 0),
		highlightFill = Color3.new(1, 0, 0),
		highlightOutline = Color3.new(1, 1, 1),
		boxThickness = 1,
		skeletonThickness = 1,
		textSize = 12,

		shouldOutline = true,

		-- Hit Effects
		shouldPlayHitSound = false,
		hitSound = "Minecraft",
		hitSoundVolume = 0.5,
		shouldShowBulletTracers = false,
		shouldShowHitNotify = false,
		shouldShowKillNotify = false,
		shouldHideHitmarker = false,
		killNotifyLifetime = 1,
		hitNotifyLifetime = 1,
		tracerLifetime = 1,
		tracerThickness = 1,
	},
	SOUNDS = {
		Minecraft = "rbxassetid://4809574295",
		Gamesense = "rbxassetid://4809574295",
		Skeet = "rbxassetid://6607204501",
		Neverlose = "rbxassetid://6534575058",
		Rust = "rbxassetid://3744371342",
		Bameware = "rbxassetid://3124331820",
	},
	R15_JOINTS = {
		{ "Head", "UpperTorso" },
		{ "UpperTorso", "LowerTorso" },
		{ "LowerTorso", "LeftUpperLeg" },
		{ "LeftUpperLeg", "LeftLowerLeg" },
		{ "LeftLowerLeg", "LeftFoot" },
		{ "LowerTorso", "RightUpperLeg" },
		{ "RightUpperLeg", "RightLowerLeg" },
		{ "RightLowerLeg", "RightFoot" },
		{ "UpperTorso", "LeftUpperArm" },
		{ "LeftUpperArm", "LeftLowerArm" },
		{ "LeftLowerArm", "LeftHand" },
		{ "UpperTorso", "RightUpperArm" },
		{ "RightUpperArm", "RightLowerArm" },
		{ "RightLowerArm", "RightHand" },
	},
	ESP_RENDER_INTERVAL = ESP_RENDER_INTERVAL,
	ESP_SKELETON_INTERVAL = ESP_SKELETON_INTERVAL,
	ESP_TEXT_INTERVAL = ESP_TEXT_INTERVAL,
	ESP_SMOOTH_ALPHA = ESP_SMOOTH_ALPHA,
}

--// Private helpers

--// Public API
return Constants
