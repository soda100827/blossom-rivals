local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
require(v1.Modules.EnumBuilder)
require(v1.Modules.Utility)
local v_u_3 = {
	"PlayerDataController",
	"ComplianceController",
	"FunctionsController",
	"MiscController",
	"UserInterfaceController",
	"MonetizationController",
	"EnemyController",
	"CameraController",
	"MechanicsController",
	"FighterController",
	"SpectateController",
	"TightropeController",
	"EntityController",
	"DuelController",
	"GameComponentsController",
	"ControlsController",
	"LeaderboardController",
	"LobbyController",
	"QueuePadController",
	"LightingController",
	"ShootingRangeController",
	"CoreGuiController",
	"MusicController",
	"MobileController",
	"ShopController",
	"ProximityPromptController",
	"PlayerInteractionController",
	"DebugController",
	"MatchmakingController",
	"ChattingController",
	"EventController",
	"PrivateServerController",
	"TestingController",
	"ShadyChickenController",
	"WrapController",
	"ScavengerHuntController",
	"SocialController",
	"FFlagController",
	"AudioController",
	"BirthdayController",
	"ArcadeController",
	"EmoteController",
	"SeasonController",
}
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new()
	local v5 = v_u_4
	local v6 = setmetatable({}, v5)
	v6:_Init()
	return v6
end
function v_u_4.LoadModule(p7, p8)
	tick()
	p7[p8] = require(v_u_2.LocalPlayer.PlayerScripts.Controllers:WaitForChild(p8))
end
function v_u_4._LoadModules(p9)
	for _, v10 in pairs(v_u_3) do
		p9:LoadModule(v10)
	end
end
function v_u_4._Init(p11)
	p11:_LoadModules()
end
return v_u_4._new()
