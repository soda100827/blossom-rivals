--!strict

--// Services

--// Dependencies (require)

--// Constants

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
		isCustomHitSoundEnabled = false,
		hitSoundId = "160432334",
		isNoHurtEffectEnabled = false,
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
}

--// Private helpers

--// Public API
return Constants
